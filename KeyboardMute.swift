import Cocoa
import Carbon

// MARK: - App State Container
class AppState: ObservableObject {
    @Published var isMicrophoneMuted: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .microphoneStateChanged, object: self, userInfo: ["isMuted": isMicrophoneMuted])
        }
    }
    @Published var isAppActive: Bool = true {
        didSet {
            NotificationCenter.default.post(name: .appStateChanged, object: self, userInfo: ["isActive": isAppActive])
        }
    }
    @Published var lastToggleTime: Date = Date()
    @Published var ktalkAppsFound: [NSRunningApplication] = [] {
        didSet {
            NotificationCenter.default.post(name: .ktalkAppsUpdated, object: self, userInfo: ["apps": ktalkAppsFound])
        }
    }
    @Published var currentConferenceWindow: AXUIElement? {
        didSet {
            NotificationCenter.default.post(name: .conferenceWindowChanged, object: self, userInfo: ["window": currentConferenceWindow as Any])
        }
    }
    
    // Settings
    @Published var hotkeyEnabled: Bool = true
    @Published var showVisualFeedback: Bool = true
    @Published var plateDisplayDuration: TimeInterval = 1.5
    
    // Computed properties
    var microphoneStatusText: String {
        return isMicrophoneMuted ? "Microphone Muted" : "Microphone Active"
    }
    
    var microphoneIconName: String {
        return isMicrophoneMuted ? "mic.slash" : "mic"
    }
    
    var microphoneIconColor: NSColor {
        return isMicrophoneMuted ? .systemRed : .systemBlue
    }
    
    // State management methods
    func toggleMicrophone() {
        isMicrophoneMuted.toggle()
        lastToggleTime = Date()
    }
    
    func setMicrophoneState(_ muted: Bool) {
        isMicrophoneMuted = muted
        lastToggleTime = Date()
    }
    
    func updateKtalkApps(_ apps: [NSRunningApplication]) {
        ktalkAppsFound = apps
    }
    
    func setConferenceWindow(_ window: AXUIElement?) {
        currentConferenceWindow = window
    }
    
    func reset() {
        isMicrophoneMuted = false
        isAppActive = true
        lastToggleTime = Date()
        ktalkAppsFound = []
        currentConferenceWindow = nil
    }
}

// MARK: - Keyboard Mute Application
class KeyboardMute: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var eventHandler: EventHandlerRef?
    var stateUpdateTimer: Timer?
    
    // Global state container
    let appState = AppState()
    
    // App version
    let version = "1.6.0"
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Request accessibility permissions
        requestAccessibilityPermissions()
        
        createStatusItem()
        registerGlobalHotkey()
        NSApp.setActivationPolicy(.accessory)
        setupEventHandling()
        setupStateObservers()
        startStateUpdateTimer()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Stop the state update timer
        stopStateUpdateTimer()
        
        // Remove event handler
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
        }
        
        // Remove notification observers
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if !accessEnabled {
            print("❌ Accessibility permissions not granted. Please enable in System Preferences > Security & Privacy > Privacy > Accessibility")
        } else {
            print("✅ Accessibility permissions granted")
        }
    }
    
    func startStateUpdateTimer() {
        // Stop existing timer if any
        stopStateUpdateTimer()
        
        // Create new timer that fires every 1 second
        stateUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMicrophoneStateFromKtalk()
        }
    }
    
    func stopStateUpdateTimer() {
        stateUpdateTimer?.invalidate()
        stateUpdateTimer = nil
    }
    
    func updateMicrophoneStateFromKtalk() {
        // Only update if we have a conference window
        guard appState.currentConferenceWindow != nil else {
            return
        }
        
        // Find Ktalk applications and check microphone state
        let runningApps = NSWorkspace.shared.runningApplications
        let ktalkApps = runningApps.filter { app in
            let bundleId = app.bundleIdentifier ?? ""
            let appName = app.localizedName ?? ""
            return bundleId.lowercased().contains("ktalk") || 
                   bundleId.lowercased().contains("m-pm") ||
                   appName.lowercased().contains("толк") || 
                   appName.lowercased().contains("ktalk")
        }
        
        guard !ktalkApps.isEmpty else {
            return
        }
        
        // Check all Ktalk applications for conference windows
        for app in ktalkApps {
            let appElement = AXUIElementCreateApplication(app.processIdentifier)
            var windowsRef: CFTypeRef?
            let windowsResult = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)
            
            guard windowsResult == .success, let windows = windowsRef as? [AXUIElement] else {
                continue
            }
            
            // Check each window for conference control buttons
            for window in windows {
                let conferenceResult = hasConferenceControlButtons(in: window)
                if conferenceResult.isConference {
                    // Update microphone state based on found buttons
                    if let micState = conferenceResult.microphoneState {
                        // Only update if state has changed
                        if appState.isMicrophoneMuted != micState {
                            appState.setMicrophoneState(micState)
                            updateButtonIcon()
                        }
                    }
                    return // Found conference window, stop searching
                }
            }
        }
    }
    
    func setupEventHandling() {
        _ = (1 << kEventClassKeyboard) | (1 << kEventClassApplication)
        InstallEventHandler(
            GetApplicationEventTarget(),
            { (nextHandler, theEvent, userData) -> OSStatus in
                let app = Unmanaged<KeyboardMute>.fromOpaque(userData!).takeUnretainedValue()
                return app.handleHotKeyEvent(nextHandler, theEvent)
            },
            1,
            [EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))],
            Unmanaged.passUnretained(self).toOpaque(),
            &eventHandler
        )
    }
    
    func setupStateObservers() {
        // Observe microphone state changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMicrophoneStateChanged),
            name: .microphoneStateChanged,
            object: appState
        )
        
        // Observe app state changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppStateChanged),
            name: .appStateChanged,
            object: appState
        )
        
        // Observe Ktalk apps updates
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKtalkAppsUpdated),
            name: .ktalkAppsUpdated,
            object: appState
        )
        
        // Observe conference window changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleConferenceWindowChanged),
            name: .conferenceWindowChanged,
            object: appState
        )
    }
    
    func handleHotKeyEvent(_ nextHandler: EventHandlerCallRef?, _ theEvent: EventRef?) -> OSStatus {
        var hotKeyID = EventHotKeyID()
        let result = GetEventParameter(
            theEvent!,
            OSType(kEventParamDirectObject),
            OSType(typeEventHotKeyID),
            nil,
            MemoryLayout<EventHotKeyID>.size,
            nil,
            &hotKeyID
        )
        
        if result == noErr && hotKeyID.signature == 0x4D555445 { // "MUTE"
            DispatchQueue.main.async {
                self.toggleMicrophone()
            }
        }
        
        return noErr
    }
    
    func createStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            updateButtonIcon()
            button.action = #selector(toggleMicrophone)
            button.target = self
        }
        
        // Create menu
        let menu = createMenu()
        statusItem?.menu = menu
    }
    
    func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        let toggleItem = NSMenuItem(title: "Toggle Microphone (Cmd+Shift+Z)", action: #selector(toggleMicrophone), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)
        
        let refreshItem = NSMenuItem(title: "Refresh State", action: #selector(refreshMicrophoneState), keyEquivalent: "r")
        refreshItem.target = self
        menu.addItem(refreshItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    func registerGlobalHotkey() {
        let keyCode: UInt32 = 6 // Z key
        let modifiers: UInt32 = UInt32(cmdKey | shiftKey)
        
        let hotKeyID = EventHotKeyID(signature: 0x4D555445, id: 1) // "MUTE" as OSType
        
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &eventHandler
        )
        
        if status != noErr {
            // Hotkey registration failed
        }
    }
    
    @objc func toggleMicrophone() {
        appState.toggleMicrophone()
        updateButtonIcon()
        sendMToKtalkConference()
        showMicrophonePlate()
    }
    
    @objc func refreshMicrophoneState() {
        updateMicrophoneStateFromKtalk()
    }
    
    func updateButtonIcon() {
        if let button = statusItem?.button {
            // Show microphone icon with strikethrough when muted
            let iconName = appState.microphoneIconName
            button.image = NSImage(systemSymbolName: iconName, accessibilityDescription: "Microphone")
            button.toolTip = appState.microphoneStatusText
        }
    }
    
    func showMicrophonePlate() {
        createPanelPlate()
    }
    
    func createPanelPlate() {
        guard let mainScreen = NSScreen.main else { return }
        
        
        // Dynamic size calculation based on monitor resolution
        let screenWidth = mainScreen.frame.width
        let screenHeight = mainScreen.frame.height
        let minDimension = min(screenWidth, screenHeight)
        
        // Plate size is 15% of the smaller screen dimension
        let plateSize = minDimension * 0.15
        let plateWidth = plateSize
        let plateHeight = plateSize
        
        // Icon size is 60% of plate size
        let iconSize = plateSize * 0.6
        let iconWidth = iconSize
        let iconHeight = iconSize
        
        // Screen dimensions calculated
        
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: plateWidth, height: plateHeight),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Panel settings for system-like appearance
        panel.level = NSWindow.Level.floating
        panel.backgroundColor = NSColor.clear
        panel.isOpaque = false
        panel.hasShadow = false
        panel.ignoresMouseEvents = true
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
        panel.animationBehavior = .utilityWindow
        panel.hidesOnDeactivate = false
        
        // Center on screen
        let screenFrame = mainScreen.visibleFrame
        let x = screenFrame.origin.x + (screenFrame.width - plateWidth) / 2
        let y = screenFrame.origin.y + (screenFrame.height - plateHeight) / 2
        panel.setFrameOrigin(NSPoint(x: x, y: y))
        
        // Create content with blur effect
        let blurEffect = NSVisualEffectView(frame: panel.contentView!.bounds)
        blurEffect.material = .hudWindow
        blurEffect.blendingMode = .behindWindow
        blurEffect.state = .active
        blurEffect.wantsLayer = true
        blurEffect.layer?.cornerRadius = 30
        blurEffect.layer?.masksToBounds = true
        blurEffect.layer?.shouldRasterize = true
        blurEffect.layer?.rasterizationScale = NSScreen.main?.backingScaleFactor ?? 1.0
        
        panel.contentView = blurEffect
        
        // Create fixed container for icon
        let iconContainerSize = min(iconWidth, iconHeight) // Square container
        let iconX = (plateWidth - iconContainerSize) / 2
        let iconY = (plateHeight - iconContainerSize) / 2
        
        // Create parent container with fixed size
        let iconContainer = NSView(frame: NSRect(x: iconX, y: iconY, width: iconContainerSize, height: iconContainerSize))
        iconContainer.wantsLayer = true
        iconContainer.layer?.backgroundColor = NSColor.clear.cgColor
        
        // Create NSImageView inside container
        let iconView = NSImageView(frame: NSRect(x: 0, y: 0, width: iconContainerSize, height: iconContainerSize))
        iconView.imageScaling = .scaleProportionallyUpOrDown
        iconView.imageAlignment = .alignCenter
        
        // Create icon with fixed size - show crossed out microphone when muted
        let iconName = appState.microphoneIconName
        let micImage = NSImage(systemSymbolName: iconName, accessibilityDescription: nil)
        
        // Set image directly
        iconView.image = micImage
        iconView.contentTintColor = appState.microphoneIconColor
        iconView.wantsLayer = true
        iconView.layer?.shouldRasterize = true
        iconView.layer?.rasterizationScale = NSScreen.main?.backingScaleFactor ?? 1.0
        
        // Add iconView to container, container to blurEffect
        iconContainer.addSubview(iconView)
        blurEffect.addSubview(iconContainer)
        
        // Show panel
        panel.makeKeyAndOrderFront(nil)
        
        // Simple appearance without animation
        panel.alphaValue = 1.0
        
        // Hide panel after configured duration
        DispatchQueue.main.asyncAfter(deadline: .now() + appState.plateDisplayDuration) {
            panel.close()
        }
    }
    
    
    func sendMToKtalkConference() {
        // Find all Ktalk applications
        let runningApps = NSWorkspace.shared.runningApplications
        let ktalkApps = runningApps.filter { app in
            let bundleId = app.bundleIdentifier ?? ""
            let appName = app.localizedName ?? ""
            return bundleId.lowercased().contains("ktalk") || 
                   bundleId.lowercased().contains("m-pm") ||
                   appName.lowercased().contains("толк") || 
                   appName.lowercased().contains("ktalk")
        }
        
        // Update state with found apps
        appState.updateKtalkApps(ktalkApps)
        
        guard !ktalkApps.isEmpty else {
            return
        }
        
        // Check all Ktalk applications for conference windows
        var conferenceWindow: AXUIElement?
        var foundApp: NSRunningApplication?
        
        for app in ktalkApps {
            // Get application windows
            let appElement = AXUIElementCreateApplication(app.processIdentifier)
            var windowsRef: CFTypeRef?
            let windowsResult = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)
            
            guard windowsResult == .success, let windows = windowsRef as? [AXUIElement] else {
                continue
            }
            
            // Check each window for conference control buttons
            for window in windows {
                // Check for conference control buttons
                let conferenceResult = hasConferenceControlButtons(in: window)
                if conferenceResult.isConference {
                    conferenceWindow = window
                    foundApp = app
                    
                    // Update microphone state based on found buttons
                    if let micState = conferenceResult.microphoneState {
                        appState.setMicrophoneState(micState)
                        updateButtonIcon()
                    }
                    break
                }
            }
            
            if conferenceWindow != nil {
                break
            }
        }
        
        guard let window = conferenceWindow, let app = foundApp else {
            appState.setConferenceWindow(nil)
            return
        }
        
        // Update state with found conference window
        appState.setConferenceWindow(window)
        
        // Bring window to front
        AXUIElementSetAttributeValue(window, kAXFocusedAttribute as CFString, true as CFTypeRef)
        
        // Activate application
        app.activate(options: [])
        
        // Wait half a second
        usleep(500000) // 0.5 seconds
        
        // Send M key
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: 46, keyDown: true) // 46 = M key
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: 46, keyDown: false)
        
        guard let downEvent = keyDownEvent, let upEvent = keyUpEvent else {
            return
        }
        
        // Send plain M key without modifiers
        downEvent.flags = []
        upEvent.flags = []
        
        downEvent.post(tap: .cghidEventTap)
        usleep(100000) // 0.1 seconds between press and release
        upEvent.post(tap: .cghidEventTap)
        
        // Update state after sending the key
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateMicrophoneStateFromKtalk()
        }
    }
    
    func hasConferenceControlButtons(in window: AXUIElement) -> (isConference: Bool, microphoneState: Bool?) {
        var microphoneButtonFound = false
        var cameraButtonFound = false
        var chatButtonFound = false
        var joinButtonFound = false
        var enableMicrophoneButtonFound = false
        var disableMicrophoneButtonFound = false
        
        // Recursively search for conference control buttons
        findConferenceButtons(in: window, microphoneFound: &microphoneButtonFound, cameraFound: &cameraButtonFound, chatFound: &chatButtonFound, joinFound: &joinButtonFound, enableMicrophoneFound: &enableMicrophoneButtonFound, disableMicrophoneFound: &disableMicrophoneButtonFound)
        
        // Conference window should have microphone AND camera AND chat buttons, but NOT join button
        let isConferenceWindow = microphoneButtonFound && cameraButtonFound && chatButtonFound && !joinButtonFound
        
        // Determine microphone state based on found buttons
        var microphoneState: Bool? = nil
        if isConferenceWindow {
            if enableMicrophoneButtonFound && !disableMicrophoneButtonFound {
                microphoneState = false // Microphone is OFF (need to enable)
            } else if disableMicrophoneButtonFound && !enableMicrophoneButtonFound {
                microphoneState = true // Microphone is ON (need to disable)
            }
        }
        
        return (isConference: isConferenceWindow, microphoneState: microphoneState)
    }
    
    func findConferenceButtons(in element: AXUIElement, microphoneFound: inout Bool, cameraFound: inout Bool, chatFound: inout Bool, joinFound: inout Bool, enableMicrophoneFound: inout Bool, disableMicrophoneFound: inout Bool) {
        // Get element role
        var roleRef: CFTypeRef?
        let roleResult = AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &roleRef)
        let role = (roleResult == .success) ? (roleRef as? String ?? "unknown") : "unknown"
        
        if role == "AXButton" {
            // Get element description
            var descriptionRef: CFTypeRef?
            let descResult = AXUIElementCopyAttributeValue(element, kAXDescriptionAttribute as CFString, &descriptionRef)
            let description = (descResult == .success) ? (descriptionRef as? String ?? "") : ""
            
            // Get help (tooltip) element
            var helpRef: CFTypeRef?
            let helpResult = AXUIElementCopyAttributeValue(element, kAXHelpAttribute as CFString, &helpRef)
            let help = (helpResult == .success) ? (helpRef as? String ?? "") : ""
            
            // Get element value
            var valueRef: CFTypeRef?
            let valueResult = AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueRef)
            let value = (valueResult == .success) ? (valueRef as? String ?? "") : ""
            
            // Get element enabled state (not used but kept for future use)
            var enabledRef: CFTypeRef?
            let enabledResult = AXUIElementCopyAttributeValue(element, kAXEnabledAttribute as CFString, &enabledRef)
            let _ = (enabledResult == .success) ? (enabledRef as? Bool ?? true) : true
            
            let allText = "\(description) \(help) \(value)".lowercased()
            
            // Check for conference control buttons - расширенный поиск
            if allText.contains("включить микрофон") || allText.contains("микрофон включить") || allText.contains("unmute") || allText.contains("microphone on") {
                microphoneFound = true
                enableMicrophoneFound = true
            } else if allText.contains("выключить микрофон") || allText.contains("микрофон выключить") || allText.contains("mute") || allText.contains("microphone off") {
                microphoneFound = true
                disableMicrophoneFound = true
            } else if allText.contains("включить камеру") || allText.contains("выключить камеру") || allText.contains("камера") || allText.contains("camera") || allText.contains("video") {
                cameraFound = true
            } else if allText.contains("чат") || allText.contains("chat") || allText.contains("сообщения") {
                chatFound = true
            } else if allText.contains("присоединиться") || allText.contains("join") || allText.contains("подключиться") {
                joinFound = true
            }
        }
        
        // Recursively search in child elements
        var childrenRef: CFTypeRef?
        let childrenResult = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &childrenRef)
        
        if childrenResult == .success, let children = childrenRef as? [AXUIElement] {
            for child in children {
                findConferenceButtons(in: child, microphoneFound: &microphoneFound, cameraFound: &cameraFound, chatFound: &chatFound, joinFound: &joinFound, enableMicrophoneFound: &enableMicrophoneFound, disableMicrophoneFound: &disableMicrophoneFound)
            }
        }
    }
    
    // MARK: - State Change Handlers
    @objc func handleMicrophoneStateChanged(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateButtonIcon()
        }
    }
    
    @objc func handleAppStateChanged(_ notification: Notification) {
        // Handle app state changes if needed
        print("App state changed: \(appState.isAppActive)")
    }
    
    @objc func handleKtalkAppsUpdated(_ notification: Notification) {
        // Handle Ktalk apps updates if needed
        print("Ktalk apps updated: \(appState.ktalkAppsFound.count) apps found")
    }
    
    @objc func handleConferenceWindowChanged(_ notification: Notification) {
        // Handle conference window changes if needed
        print("Conference window changed: \(appState.currentConferenceWindow != nil ? "Found" : "Not found")")
    }
    
    @objc func quitApp() {
        // Release resources
        if let eventHandler = eventHandler {
            UnregisterEventHotKey(eventHandler)
        }
        
        // Remove observers
        NotificationCenter.default.removeObserver(self)
        
        NSApplication.shared.terminate(nil)
    }
    
    
    deinit {
        if let eventHandler = eventHandler {
            UnregisterEventHotKey(eventHandler)
        }
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let microphoneStateChanged = Notification.Name("microphoneStateChanged")
    static let appStateChanged = Notification.Name("appStateChanged")
    static let ktalkAppsUpdated = Notification.Name("ktalkAppsUpdated")
    static let conferenceWindowChanged = Notification.Name("conferenceWindowChanged")
}

// Main function
let app = NSApplication.shared
let delegate = KeyboardMute()
app.delegate = delegate
app.run()