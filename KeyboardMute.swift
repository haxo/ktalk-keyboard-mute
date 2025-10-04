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
        
        print("KeyboardMute запущен! Используйте Shift+Cmd+Z для переключения микрофона.")
    }
    
    
    func setupEventHandling() {
        // Создаем обработчик событий для горячих клавиш
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
        
        // Отправляем клавишу M в окно конференции Толк
        sendMToKtalkConference()
        
        print("Microphone toggled: \(isMicrophoneMuted ? "MUTED" : "ACTIVE")")
    }
    
    func updateButtonIcon() {
        if let button = statusItem?.button {
            // Всегда показываем микрофон включен, независимо от состояния
            button.image = NSImage(systemSymbolName: "mic", accessibilityDescription: "Microphone")
            button.toolTip = nil
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
        
        // Динамический расчет размеров на основе разрешения монитора
        let screenWidth = mainScreen.frame.width
        let screenHeight = mainScreen.frame.height
        let minDimension = min(screenWidth, screenHeight)
        
        // Плашка составляет 15% от меньшей стороны экрана
        let plateSize = minDimension * 0.15
        let plateWidth = plateSize
        let plateHeight = plateSize
        
        // Иконка составляет 60% от размера плашки (уменьшена в 1.5 раза)
        let iconSize = plateSize * 0.6
        let iconWidth = iconSize
        let iconHeight = iconSize
        
        // Отступы составляют 5% от размера плашки
        _ = plateSize * 0.05
        
        print("📐 Screen: \(Int(screenWidth))x\(Int(screenHeight)), Plate: \(Int(plateSize))x\(Int(plateSize)), Icon: \(Int(iconSize))x\(Int(iconSize))")
        
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: plateWidth, height: plateHeight),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Настройки панели для системного вида
        panel.level = NSWindow.Level.floating
        panel.backgroundColor = NSColor.clear
        panel.isOpaque = false
        panel.hasShadow = false
        panel.ignoresMouseEvents = true
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
        panel.animationBehavior = .utilityWindow
        panel.hidesOnDeactivate = false
        
        // Центрируем на экране
        let screenFrame = mainScreen.visibleFrame
        let x = screenFrame.origin.x + (screenFrame.width - plateWidth) / 2
        let y = screenFrame.origin.y + (screenFrame.height - plateHeight) / 2
        panel.setFrameOrigin(NSPoint(x: x, y: y))
        
        // Создаем контент только с размытым фоном (без черного фона)
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
        
        // Создаем фиксированный контейнер для иконки
        let iconContainerSize = min(iconWidth, iconHeight) // Квадратный контейнер
        let iconX = (plateWidth - iconContainerSize) / 2
        let iconY = (plateHeight - iconContainerSize) / 2
        
        // Создаем контейнер-родитель с фиксированным размером
        let iconContainer = NSView(frame: NSRect(x: iconX, y: iconY, width: iconContainerSize, height: iconContainerSize))
        iconContainer.wantsLayer = true
        iconContainer.layer?.backgroundColor = NSColor.clear.cgColor
        
        // Создаем NSImageView внутри контейнера
        let iconView = NSImageView(frame: NSRect(x: 0, y: 0, width: iconContainerSize, height: iconContainerSize))
        iconView.imageScaling = .scaleProportionallyUpOrDown
        iconView.imageAlignment = .alignCenter
        
        // Создаем иконку с фиксированным размером (всегда микрофон включен)
        let micImage = NSImage(systemSymbolName: "mic", accessibilityDescription: nil)
        
        // Устанавливаем изображение напрямую
        iconView.image = micImage
        iconView.contentTintColor = NSColor.red
        iconView.wantsLayer = true
        iconView.layer?.shouldRasterize = true
        iconView.layer?.rasterizationScale = NSScreen.main?.backingScaleFactor ?? 1.0
        
        // Добавляем iconView в контейнер, а контейнер в blurEffect
        iconContainer.addSubview(iconView)
        blurEffect.addSubview(iconContainer)
        
        // Показываем панель
        panel.makeKeyAndOrderFront(nil)
        
        // Простое появление без анимации
        panel.alphaValue = 1.0
        
        // Скрываем панель через 1.5 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            panel.close()
            print("🎤 NSPanel plate closed")
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
    
    func sendMToKtalkConference() {
        print("🎤 Отправка клавиши M в окно конференции Толк...")
        
        // Находим приложение Толк
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
            print("❌ Приложение Толк не найдено")
            return
        }
        
        print("✅ Найдено приложение Толк: \(app.localizedName ?? "Unknown") (PID: \(app.processIdentifier))")
        
        // Получаем окна приложения
        let appElement = AXUIElementCreateApplication(app.processIdentifier)
        var windowsRef: CFTypeRef?
        let windowsResult = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)
        
        guard windowsResult == .success, let windows = windowsRef as? [AXUIElement] else {
            print("❌ Не удалось получить окна приложения")
            return
        }
        
        // Ищем окно конференции по уникальным признакам
        var conferenceWindow: AXUIElement?
        for window in windows {
            var titleRef: CFTypeRef?
            let titleResult = AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
            let title = (titleResult == .success) ? (titleRef as? String ?? "") : ""
            
            print("🔍 Проверяем окно: \"\(title)\"")
            
            // Проверяем наличие кнопок управления конференцией
            if hasConferenceControlButtons(in: window) {
                conferenceWindow = window
                print("✅ Найдено окно конференции по кнопкам управления: \"\(title)\"")
                break
            }
        }
        
        guard let window = conferenceWindow else {
            print("❌ Окно конференции не найдено")
            return
        }
        
        // Поднимаем окно наверх
        print("🔄 Поднимаем окно конференции наверх...")
        AXUIElementSetAttributeValue(window, kAXFocusedAttribute as CFString, true as CFTypeRef)
        
        // Активируем приложение
        app.activate(options: [])
        
        // Ждем полсекунды
        print("⏱️ Ожидание 0.5 секунды...")
        usleep(500000) // 0.5 секунды
        
        // Отправляем клавишу M
        print("⌨️ Отправка клавиши M в Толк...")
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: 46, keyDown: true) // 46 = M key
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: 46, keyDown: false)
        
        guard let downEvent = keyDownEvent, let upEvent = keyUpEvent else {
            print("❌ Не удалось создать события клавиатуры")
            return
        }
        
        // Отправляем просто клавишу M без модификаторов
        downEvent.flags = []
        upEvent.flags = []
        
        downEvent.post(tap: .cghidEventTap)
        usleep(100000) // 0.1 секунды между нажатием и отпусканием
        upEvent.post(tap: .cghidEventTap)
        
        print("✅ Клавиша M отправлена в окно конференции Толк")
    }
    
    func hasConferenceControlButtons(in window: AXUIElement) -> Bool {
        var microphoneButtonFound = false
        var cameraButtonFound = false
        var recordingButtonFound = false
        
        // Рекурсивно ищем кнопки управления конференцией
        findConferenceButtons(in: window, microphoneFound: &microphoneButtonFound, cameraFound: &cameraButtonFound, recordingFound: &recordingButtonFound)
        
        // Окно конференции должно иметь кнопки микрофона И камеры
        let isConferenceWindow = microphoneButtonFound && cameraButtonFound
        
        if isConferenceWindow {
            print("🎯 Найдены кнопки конференции: микрофон=\(microphoneButtonFound), камера=\(cameraButtonFound), запись=\(recordingButtonFound)")
        }
        
        return isConferenceWindow
    }
    
    func findConferenceButtons(in element: AXUIElement, microphoneFound: inout Bool, cameraFound: inout Bool, recordingFound: inout Bool) {
        // Получаем роль элемента
        var roleRef: CFTypeRef?
        let roleResult = AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &roleRef)
        let role = (roleResult == .success) ? (roleRef as? String ?? "unknown") : "unknown"
        
        if role == "AXButton" {
            // Получаем описание элемента
            var descriptionRef: CFTypeRef?
            let descResult = AXUIElementCopyAttributeValue(element, kAXDescriptionAttribute as CFString, &descriptionRef)
            let description = (descResult == .success) ? (descriptionRef as? String ?? "") : ""
            
            // Получаем help (tooltip) элемента
            var helpRef: CFTypeRef?
            let helpResult = AXUIElementCopyAttributeValue(element, kAXHelpAttribute as CFString, &helpRef)
            let help = (helpResult == .success) ? (helpRef as? String ?? "") : ""
            
            // Получаем значение элемента
            var valueRef: CFTypeRef?
            let valueResult = AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueRef)
            let value = (valueResult == .success) ? (valueRef as? String ?? "") : ""
            
            let allText = "\(description) \(help) \(value)".lowercased()
            
            // Проверяем на кнопки управления конференцией
            if allText.contains("микрофон") || allText.contains("microphone") || allText.contains("mute") || allText.contains("unmute") {
                microphoneFound = true
                print("🎤 Найдена кнопка микрофона: '\(description)'")
            } else if allText.contains("камер") || allText.contains("camera") || allText.contains("video") {
                cameraFound = true
                print("📹 Найдена кнопка камеры: '\(description)'")
            } else if allText.contains("запис") || allText.contains("record") || allText.contains("recording") {
                recordingFound = true
                print("🎯 Найдена кнопка записи: '\(description)'")
            }
        }
        
        // Рекурсивно ищем в дочерних элементах
        var childrenRef: CFTypeRef?
        let childrenResult = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &childrenRef)
        
        if childrenResult == .success, let children = childrenRef as? [AXUIElement] {
            for child in children {
                findConferenceButtons(in: child, microphoneFound: &microphoneFound, cameraFound: &cameraFound, recordingFound: &recordingFound)
            }
        }
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

