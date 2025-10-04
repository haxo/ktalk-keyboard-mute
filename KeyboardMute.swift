import Cocoa
import Carbon

class KeyboardMute: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var isMicrophoneMuted = false
    var eventHandler: EventHandlerRef?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Starting KeyboardMute...")
        
        // Создаем элемент статус-бара
        createStatusItem()
        
        // Регистрируем глобальные горячие клавиши
        registerGlobalHotkey()
        
        // Скрываем приложение из Dock
        NSApp.setActivationPolicy(.accessory)
        
        // Устанавливаем обработчик событий
        setupEventHandling()
        
        print("KeyboardMute запущен! Используйте Cmd+Shift+M для переключения микрофона.")
    }
    
    func setupEventHandling() {
        // Создаем обработчик событий для горячих клавиш
        let eventMask = (1 << kEventClassKeyboard) | (1 << kEventClassApplication)
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
        var result = GetEventParameter(
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
        
        // Создаем меню
        let menu = createMenu()
        statusItem?.menu = menu
    }
    
    func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        let toggleItem = NSMenuItem(title: "Toggle Microphone (Cmd+Shift+M)", action: #selector(toggleMicrophone), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    func registerGlobalHotkey() {
        let keyCode: UInt32 = 46 // M key
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
            print("Hotkey Cmd+Shift+M registered successfully")
        }
    }
    
    @objc func toggleMicrophone() {
        print("Toggling microphone...")
        
        isMicrophoneMuted.toggle()
        
        // Обновляем иконку
        updateButtonIcon()
        
        // Показываем плашку
        showMicrophonePlate()
        
        // Показываем уведомление
        showNotification()
        
        print("Microphone toggled: \(isMicrophoneMuted ? "MUTED" : "ACTIVE")")
    }
    
    func updateButtonIcon() {
        if let button = statusItem?.button {
            if isMicrophoneMuted {
                button.image = NSImage(systemSymbolName: "mic.slash", accessibilityDescription: "Microphone Muted")
                button.toolTip = "Microphone Muted - Click to unmute"
            } else {
                button.image = NSImage(systemSymbolName: "mic", accessibilityDescription: "Microphone Active")
                button.toolTip = "Microphone Active - Click to mute"
            }
        }
    }
    
    func showMicrophonePlate() {
        // Подход 1: NSVisualEffectView (текущий)
        createVisualEffectPlate()
        
        // Если не работает, раскомментировать другие подходы:
        // createPanelPlate()        // Подход 2: NSPanel
        // createCoreAnimationPlate() // Подход 3: Core Animation
        // createStatusBarPlate()    // Подход 4: NSStatusBar
    }
    
    func createVisualEffectPlate() {
        guard let mainScreen = NSScreen.main else { return }
        
        // Создаем окно плашки
        let plateWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Настраиваем окно как системное уведомление
        plateWindow.level = NSWindow.Level.floating
        plateWindow.backgroundColor = NSColor.clear
        plateWindow.isOpaque = false
        plateWindow.hasShadow = true
        plateWindow.ignoresMouseEvents = true
        plateWindow.collectionBehavior = [.canJoinAllSpaces, .stationary]
        plateWindow.animationBehavior = .utilityWindow
        
        // Центрируем на экране
        let screenFrame = mainScreen.visibleFrame
        let x = screenFrame.origin.x + (screenFrame.width - 100) / 2
        let y = screenFrame.origin.y + (screenFrame.height - 100) / 2
        plateWindow.setFrameOrigin(NSPoint(x: x, y: y))
        
        // Создаем NSVisualEffectView для размытого фона
        let visualEffectView = NSVisualEffectView(frame: plateWindow.contentView!.bounds)
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 20
        plateWindow.contentView = visualEffectView
        
        // Создаем иконку микрофона
        let iconView = NSImageView(frame: NSRect(x: 20, y: 20, width: 60, height: 60))
        iconView.image = NSImage(systemSymbolName: isMicrophoneMuted ? "mic.slash" : "mic", accessibilityDescription: nil)
        iconView.image?.size = NSSize(width: 60, height: 60)
        iconView.contentTintColor = NSColor.labelColor
        visualEffectView.addSubview(iconView)
        
        // Показываем плашку
        plateWindow.makeKeyAndOrderFront(nil)
        
        // Анимация появления
        plateWindow.alphaValue = 0.0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            plateWindow.animator().alphaValue = 1.0
        })
        
        // Скрываем плашку через 1.2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                context.timingFunction = CAMediaTimingFunction(name: .easeIn)
                plateWindow.animator().alphaValue = 0.0
            }) {
                plateWindow.close()
            }
        }
    }
    
    // Подход 2: NSPanel
    func createPanelPlate() {
        guard let mainScreen = NSScreen.main else { return }
        
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        panel.level = NSWindow.Level.floating
        panel.backgroundColor = NSColor.clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.ignoresMouseEvents = true
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
        panel.animationBehavior = .utilityWindow
        
        // Центрируем
        let screenFrame = mainScreen.visibleFrame
        let x = screenFrame.origin.x + (screenFrame.width - 100) / 2
        let y = screenFrame.origin.y + (screenFrame.height - 100) / 2
        panel.setFrameOrigin(NSPoint(x: x, y: y))
        
        // Контент
        let contentView = NSView(frame: panel.contentView!.bounds)
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 20
        contentView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.7).cgColor
        panel.contentView = contentView
        
        // Иконка
        let iconView = NSImageView(frame: NSRect(x: 20, y: 20, width: 60, height: 60))
        iconView.image = NSImage(systemSymbolName: isMicrophoneMuted ? "mic.slash" : "mic", accessibilityDescription: nil)
        iconView.image?.size = NSSize(width: 60, height: 60)
        iconView.contentTintColor = NSColor.white
        contentView.addSubview(iconView)
        
        panel.makeKeyAndOrderFront(nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            panel.close()
        }
    }
    
    // Подход 3: Core Animation
    func createCoreAnimationPlate() {
        guard let mainScreen = NSScreen.main else { return }
        
        let plateWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        plateWindow.level = NSWindow.Level.floating
        plateWindow.backgroundColor = NSColor.clear
        plateWindow.isOpaque = false
        plateWindow.hasShadow = true
        plateWindow.ignoresMouseEvents = true
        
        // Центрируем
        let screenFrame = mainScreen.visibleFrame
        let x = screenFrame.origin.x + (screenFrame.width - 100) / 2
        let y = screenFrame.origin.y + (screenFrame.height - 100) / 2
        plateWindow.setFrameOrigin(NSPoint(x: x, y: y))
        
        // Контент с Core Animation
        let contentView = NSView(frame: plateWindow.contentView!.bounds)
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 20
        contentView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.8).cgColor
        
        // Анимация масштабирования
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = 0.2
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        contentView.layer?.add(scaleAnimation, forKey: "scale")
        
        plateWindow.contentView = contentView
        
        // Иконка
        let iconView = NSImageView(frame: NSRect(x: 20, y: 20, width: 60, height: 60))
        iconView.image = NSImage(systemSymbolName: isMicrophoneMuted ? "mic.slash" : "mic", accessibilityDescription: nil)
        iconView.image?.size = NSSize(width: 60, height: 60)
        iconView.contentTintColor = NSColor.white
        contentView.addSubview(iconView)
        
        plateWindow.makeKeyAndOrderFront(nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            plateWindow.close()
        }
    }
    
    // Подход 4: NSStatusBar временное уведомление
    func createStatusBarPlate() {
        // Создаем временное уведомление в статус-баре
        if let button = statusItem?.button {
            let originalImage = button.image
            let originalTint = button.contentTintColor
            
            // Большая иконка
            let plateIcon = NSImage(systemSymbolName: isMicrophoneMuted ? "mic.slash" : "mic", accessibilityDescription: nil)
            plateIcon?.size = NSSize(width: 32, height: 32)
            button.image = plateIcon
            button.contentTintColor = isMicrophoneMuted ? NSColor.systemRed : NSColor.systemGreen
            
            // Анимация
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                button.animator().alphaValue = 0.7
            }) {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.2
                    button.animator().alphaValue = 1.0
                })
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                button.image = originalImage
                button.contentTintColor = originalTint
            }
        }
    }
    
    func showNotification() {
        let notification = NSUserNotification()
        notification.title = "KeyboardMute"
        notification.informativeText = isMicrophoneMuted ? "Microphone Muted" : "Microphone Active"
        notification.soundName = nil
        
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    @objc func quitApp() {
        print("Quitting application...")
        
        // Освобождаем ресурсы
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

// Главная функция
let app = NSApplication.shared
let delegate = KeyboardMute()
app.delegate = delegate
app.run()

