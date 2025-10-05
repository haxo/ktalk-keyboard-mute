import Cocoa
import Carbon

class KeyboardMute: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var isMicrophoneMuted = false
    var eventHandler: EventHandlerRef?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Starting KeyboardMute...")
        
        // Create status bar item
        createStatusItem()
        
        // Register global hotkey
        registerGlobalHotkey()
        
        // Hide app from Dock
        NSApp.setActivationPolicy(.accessory)
        
        // Setup event handling
        setupEventHandling()
        
        print("KeyboardMute started! Use Shift+Cmd+Z to toggle microphone.")
    }
    
    func setupEventHandling() {
        // Create event handler for hotkeys
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
            print("Failed to register hotkey: \(status)")
        } else {
            print("Hotkey Cmd+Shift+Z registered successfully")
        }
    }
    
    @objc func toggleMicrophone() {
        print("Toggling microphone...")
        
        isMicrophoneMuted.toggle()
        
        // Update icon
        updateButtonIcon()
        
        // Show visual feedback
        showMicrophonePlate()
        
        // Show notification
        showNotification()
        
        // Send M key to Ktalk conference window
        sendMToKtalkConference()
        
        print("Microphone toggled: \(isMicrophoneMuted ? "MUTED" : "ACTIVE")")
    }
    
    func updateButtonIcon() {
        if let button = statusItem?.button {
            // Always show microphone icon, regardless of state
            button.image = NSImage(systemSymbolName: "mic", accessibilityDescription: "Microphone")
            button.toolTip = isMicrophoneMuted ? "Microphone Muted" : "Microphone Active"
        }
    }
    
    func showMicrophonePlate() {
        createPanelPlate()
    }
    
    func createPanelPlate() {
        guard let mainScreen = NSScreen.main else { return }
        
        print("🎤 Creating microphone plate: \(isMicrophoneMuted ? "MUTED" : "ACTIVE")")
        
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
        
        print("📐 Screen: \(Int(screenWidth))x\(Int(screenHeight)), Plate: \(Int(plateSize))x\(Int(plateSize)), Icon: \(Int(iconSize))x\(Int(iconSize))")
        
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
        
        // Create icon with fixed size (always show microphone)
        let micImage = NSImage(systemSymbolName: "mic", accessibilityDescription: nil)
        
        // Set image directly
        iconView.image = micImage
        iconView.contentTintColor = isMicrophoneMuted ? NSColor.systemRed : NSColor.systemGreen
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
        
        // Hide panel after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            panel.close()
            print("🎤 Microphone plate closed")
        }
    }
    
    func showNotification() {
        let notification = NSUserNotification()
        notification.title = "KeyboardMute"
        notification.informativeText = isMicrophoneMuted ? "Microphone Muted" : "Microphone Active"
        notification.soundName = nil
        
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func sendMToKtalkConference() {
        print("🎤 Sending M key to Ktalk conference window...")
        
        // Find Ktalk application
        let runningApps = NSWorkspace.shared.runningApplications
        let ktalkApp = runningApps.first { app in
            let bundleId = app.bundleIdentifier ?? ""
            let appName = app.localizedName ?? ""
            return bundleId.lowercased().contains("ktalk") || 
                   bundleId.lowercased().contains("m-pm") ||
                   appName.lowercased().contains("толк") || 
                   appName.lowercased().contains("ktalk")
        }
        
        guard let app = ktalkApp else {
            print("❌ Ktalk application not found")
            return
        }
        
        print("✅ Found Ktalk application: \(app.localizedName ?? "Unknown") (PID: \(app.processIdentifier))")
        
        // Get application windows
        let appElement = AXUIElementCreateApplication(app.processIdentifier)
        var windowsRef: CFTypeRef?
        let windowsResult = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)
        
        guard windowsResult == .success, let windows = windowsRef as? [AXUIElement] else {
            print("❌ Could not get application windows")
            return
        }
        
        // Find conference window by unique features
        var conferenceWindow: AXUIElement?
        for window in windows {
            var titleRef: CFTypeRef?
            let titleResult = AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
            let title = (titleResult == .success) ? (titleRef as? String ?? "") : ""
            
            print("🔍 Checking window: \"\(title)\"")
            
            // Check for conference control buttons
            if hasConferenceControlButtons(in: window) {
                conferenceWindow = window
                print("✅ Found conference window by control buttons: \"\(title)\"")
                break
            }
        }
        
        guard let window = conferenceWindow else {
            print("❌ Conference window not found")
            return
        }
        
        // Bring window to front
        print("🔄 Bringing conference window to front...")
        AXUIElementSetAttributeValue(window, kAXFocusedAttribute as CFString, true as CFTypeRef)
        
        // Activate application
        app.activate(options: [])
        
        // Wait half a second
        print("⏱️ Waiting 0.5 seconds...")
        usleep(500000) // 0.5 seconds
        
        // Send M key
        print("⌨️ Sending M key to Ktalk...")
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: 46, keyDown: true) // 46 = M key
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: 46, keyDown: false)
        
        guard let downEvent = keyDownEvent, let upEvent = keyUpEvent else {
            print("❌ Could not create keyboard events")
            return
        }
        
        // Send plain M key without modifiers
        downEvent.flags = []
        upEvent.flags = []
        
        downEvent.post(tap: .cghidEventTap)
        usleep(100000) // 0.1 seconds between press and release
        upEvent.post(tap: .cghidEventTap)
        
        print("✅ M key sent to Ktalk conference window")
    }
    
    func hasConferenceControlButtons(in window: AXUIElement) -> Bool {
        var microphoneButtonFound = false
        var cameraButtonFound = false
        var recordingButtonFound = false
        
        // Recursively search for conference control buttons
        findConferenceButtons(in: window, microphoneFound: &microphoneButtonFound, cameraFound: &cameraButtonFound, recordingFound: &recordingButtonFound)
        
        // Conference window should have both microphone AND camera buttons
        let isConferenceWindow = microphoneButtonFound && cameraButtonFound
        
        if isConferenceWindow {
            print("🎯 Found conference buttons: microphone=\(microphoneButtonFound), camera=\(cameraButtonFound), recording=\(recordingButtonFound)")
        }
        
        return isConferenceWindow
    }
    
    func findConferenceButtons(in element: AXUIElement, microphoneFound: inout Bool, cameraFound: inout Bool, recordingFound: inout Bool) {
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
            
            let allText = "\(description) \(help) \(value)".lowercased()
            
            // Check for conference control buttons
            if allText.contains("микрофон") || allText.contains("microphone") || allText.contains("mute") || allText.contains("unmute") {
                microphoneFound = true
                print("🎤 Found microphone button: '\(description)'")
            } else if allText.contains("камер") || allText.contains("camera") || allText.contains("video") {
                cameraFound = true
                print("📹 Found camera button: '\(description)'")
            } else if allText.contains("запис") || allText.contains("record") || allText.contains("recording") {
                recordingFound = true
                print("🎯 Found recording button: '\(description)'")
            }
        }
        
        // Recursively search in child elements
        var childrenRef: CFTypeRef?
        let childrenResult = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &childrenRef)
        
        if childrenResult == .success, let children = childrenRef as? [AXUIElement] {
            for child in children {
                findConferenceButtons(in: child, microphoneFound: &microphoneButtonFound, cameraFound: &cameraButtonFound, recordingFound: &recordingButtonFound)
            }
        }
    }
    
    @objc func quitApp() {
        print("Quitting application...")
        
        // Release resources
        if let eventHandler = eventHandler {
            UnregisterEventHotKey(eventHandler)
        }
        
        NSApplication.shared.terminate(nil)
    }
    
    deinit {
        if let eventHandler = eventHandler {
            UnregisterEventHotKey(eventHandler)
        }
    }
}

// Main function
let app = NSApplication.shared
let delegate = KeyboardMute()
app.delegate = delegate
app.run()