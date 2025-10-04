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
        // Подход 2: NSPanel (тестируем)
        createPanelPlate()
        
        // Другие подходы:
        // createVisualEffectPlate()  // Подход 1: NSVisualEffectView - segmentation fault
        // createStatusBarPlate()     // Подход 4: NSStatusBar - не видно плашки
        // createCoreAnimationPlate() // Подход 3: Core Animation - может вызывать ошибки
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
        
        print("🎤 Creating NSPanel plate: \(isMicrophoneMuted ? "MUTED" : "ACTIVE")")
        
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 120, height: 120),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Настройки панели для системного вида
        panel.level = NSWindow.Level.floating
        panel.backgroundColor = NSColor.clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.ignoresMouseEvents = true
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
        panel.animationBehavior = .utilityWindow
        panel.hidesOnDeactivate = false
        
        // Центрируем на экране
        let screenFrame = mainScreen.visibleFrame
        let x = screenFrame.origin.x + (screenFrame.width - 120) / 2
        let y = screenFrame.origin.y + (screenFrame.height - 120) / 2
        panel.setFrameOrigin(NSPoint(x: x, y: y))
        
        // Создаем контент с размытым фоном
        let contentView = NSView(frame: panel.contentView!.bounds)
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 25
        contentView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.8).cgColor
        contentView.layer?.masksToBounds = true
        
        // Добавляем размытие
        let blurEffect = NSVisualEffectView(frame: contentView.bounds)
        blurEffect.material = .hudWindow
        blurEffect.blendingMode = .behindWindow
        blurEffect.state = .active
        blurEffect.wantsLayer = true
        blurEffect.layer?.cornerRadius = 25
        contentView.addSubview(blurEffect)
        
        panel.contentView = contentView
        
        // Создаем большую иконку микрофона
        let iconView = NSImageView(frame: NSRect(x: 30, y: 30, width: 60, height: 60))
        iconView.image = NSImage(systemSymbolName: isMicrophoneMuted ? "mic.slash" : "mic", accessibilityDescription: nil)
        iconView.image?.size = NSSize(width: 60, height: 60)
        iconView.contentTintColor = isMicrophoneMuted ? NSColor.systemRed : NSColor.systemGreen
        contentView.addSubview(iconView)
        
        // Показываем панель
        panel.makeKeyAndOrderFront(nil)
        
        // Анимация появления
        panel.alphaValue = 0.0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().alphaValue = 1.0
        })
        
        // Скрываем панель через 1.5 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                context.timingFunction = CAMediaTimingFunction(name: .easeIn)
                panel.animator().alphaValue = 0.0
            }) {
                panel.close()
                print("🎤 NSPanel plate closed")
            }
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
        // Создаем заметную плашку в статус-баре
        if let button = statusItem?.button {
            let originalImage = button.image
            let originalTint = button.contentTintColor
            
            print("🎤 Creating plate: \(isMicrophoneMuted ? "MUTED" : "ACTIVE")")
            
            // Большая иконка с ярким цветом
            let plateIcon = NSImage(systemSymbolName: isMicrophoneMuted ? "mic.slash" : "mic", accessibilityDescription: nil)
            plateIcon?.size = NSSize(width: 40, height: 40)
            button.image = plateIcon
            button.contentTintColor = isMicrophoneMuted ? NSColor.systemRed : NSColor.systemGreen
            
            // Простая анимация пульсации
            var pulseCount = 0
            let maxPulses = 6
            
            func pulse() {
                if pulseCount < maxPulses {
                    NSAnimationContext.runAnimationGroup({ context in
                        context.duration = 0.15
                        button.animator().alphaValue = 0.3
                    }) {
                        NSAnimationContext.runAnimationGroup({ context in
                            context.duration = 0.15
                            button.animator().alphaValue = 1.0
                        }) {
                            pulseCount += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                pulse()
                            }
                        }
                    }
                } else {
                    // Возвращаем оригинальную иконку
                    button.image = originalImage
                    button.contentTintColor = originalTint
                    print("🎤 Plate animation completed")
                }
            }
            
            pulse()
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

