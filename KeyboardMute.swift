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

