#!/usr/bin/env swift

import Cocoa
import ApplicationServices

print("🔍 Поиск окна конференции в приложении Толк...")

// Находим все процессы ktalk
let runningApps = NSWorkspace.shared.runningApplications
let ktalkApps = runningApps.filter { app in
    let bundleId = app.bundleIdentifier ?? ""
    let appName = app.localizedName ?? ""
    return bundleId.lowercased().contains("ktalk") || 
           bundleId.lowercased().contains("m-pm") ||
           appName.lowercased().contains("толк") || 
           appName.lowercased().contains("ktalk")
}

if ktalkApps.isEmpty {
    print("❌ Приложения Толк не найдены")
    exit(1)
}

print("✅ Найдено \(ktalkApps.count) приложение(й) Толк:")

for (index, app) in ktalkApps.enumerated() {
    print("📱 \(index + 1). \(app.localizedName ?? "Unknown") (PID: \(app.processIdentifier))")
    
    // Получаем окна приложения
    let appElement = AXUIElementCreateApplication(app.processIdentifier)
    var windowsRef: CFTypeRef?
    let windowsResult = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)
    
    if windowsResult == .success, let windows = windowsRef as? [AXUIElement] {
        print("   🪟 Найдено \(windows.count) окон:")
        
        for (windowIndex, window) in windows.enumerated() {
            // Получаем заголовок окна
            var titleRef: CFTypeRef?
            let titleResult = AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
            let title = (titleResult == .success) ? (titleRef as? String ?? "Без названия") : "Без названия"
            
            // Получаем позицию и размер окна
            var positionRef: CFTypeRef?
            var sizeRef: CFTypeRef?
            let posResult = AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &positionRef)
            let sizeResult = AXUIElementCopyAttributeValue(window, kAXSizeAttribute as CFString, &sizeRef)
            
            var position = CGPoint(x: 0, y: 0)
            var size = CGSize(width: 0, height: 0)
            
            if posResult == .success, let posValue = positionRef {
                AXValueGetValue(posValue as! AXValue, .cgPoint, &position)
            }
            
            if sizeResult == .success, let sizeValue = sizeRef {
                AXValueGetValue(sizeValue as! AXValue, .cgSize, &size)
            }
            
            print("      \(windowIndex + 1). \"\(title)\"")
            print("         📐 Позиция: (\(Int(position.x)), \(Int(position.y)))")
            print("         📏 Размер: \(Int(size.width))x\(Int(size.height))")
            
            // Проверяем, является ли это окном конференции
            let lowerTitle = title.lowercased()
            if lowerTitle.contains("конференц") || 
               lowerTitle.contains("conference") || 
               lowerTitle.contains("встреч") || 
               lowerTitle.contains("meeting") ||
               lowerTitle.contains("звонок") ||
               lowerTitle.contains("call") {
                print("         🎯 *** ВОЗМОЖНО ОКНО КОНФЕРЕНЦИИ ***")
            }
            
            // Ищем кнопки микрофона в окне
            findMicrophoneButtons(in: window, windowTitle: title)
        }
    } else {
        print("   ❌ Не удалось получить окна приложения")
    }
    print()
}

func findMicrophoneButtons(in window: AXUIElement, windowTitle: String) {
    print("         🔍 Поиск кнопок микрофона в окне \"\(windowTitle)\"...")
    
    var childrenRef: CFTypeRef?
    let childrenResult = AXUIElementCopyAttributeValue(window, kAXChildrenAttribute as CFString, &childrenRef)
    
    if childrenResult == .success, let children = childrenRef as? [AXUIElement] {
        findMicrophoneButtonsRecursive(in: children, level: 0)
    }
}

func findMicrophoneButtonsRecursive(in elements: [AXUIElement], level: Int) {
    let indent = String(repeating: "  ", count: level + 3)
    
    for element in elements {
        // Получаем роль элемента
        var roleRef: CFTypeRef?
        let roleResult = AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &roleRef)
        let role = (roleResult == .success) ? (roleRef as? String ?? "unknown") : "unknown"
        
        // Получаем заголовок элемента
        var titleRef: CFTypeRef?
        let titleResult = AXUIElementCopyAttributeValue(element, kAXTitleAttribute as CFString, &titleRef)
        let title = (titleResult == .success) ? (titleRef as? String ?? "") : ""
        
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
        
        // Проверяем, является ли это кнопкой микрофона
        let allText = "\(title) \(description) \(help) \(value)".lowercased()
        if allText.contains("микрофон") || 
           allText.contains("microphone") || 
           allText.contains("mute") || 
           allText.contains("unmute") ||
           allText.contains("включить") ||
           allText.contains("выключить") {
            
            print("\(indent)🎤 НАЙДЕНА КНОПКА МИКРОФОНА:")
            print("\(indent)   Роль: \(role)")
            print("\(indent)   Заголовок: '\(title)'")
            print("\(indent)   Описание: '\(description)'")
            print("\(indent)   Help: '\(help)'")
            print("\(indent)   Значение: '\(value)'")
            
            // Получаем позицию и размер кнопки
            var positionRef: CFTypeRef?
            var sizeRef: CFTypeRef?
            let posResult = AXUIElementCopyAttributeValue(element, kAXPositionAttribute as CFString, &positionRef)
            let sizeResult = AXUIElementCopyAttributeValue(element, kAXSizeAttribute as CFString, &sizeRef)
            
            if posResult == .success, let posValue = positionRef {
                var position = CGPoint(x: 0, y: 0)
                AXValueGetValue(posValue as! AXValue, .cgPoint, &position)
                print("\(indent)   📐 Позиция: (\(Int(position.x)), \(Int(position.y)))")
            }
            
            if sizeResult == .success, let sizeValue = sizeRef {
                var size = CGSize(width: 0, height: 0)
                AXValueGetValue(sizeValue as! AXValue, .cgSize, &size)
                print("\(indent)   📏 Размер: \(Int(size.width))x\(Int(size.height))")
            }
            
            // Проверяем, можно ли нажать на кнопку
            var actionsRef: CFArray?
            let actionsResult = AXUIElementCopyActionNames(element, &actionsRef)
            if actionsResult == .success, let actions = actionsRef as? [String] {
                print("\(indent)   ⚡ Доступные действия: \(actions.joined(separator: ", "))")
            }
        }
        
        // Рекурсивно ищем в дочерних элементах
        var childrenRef: CFTypeRef?
        let childrenResult = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &childrenRef)
        
        if childrenResult == .success, let children = childrenRef as? [AXUIElement] {
            findMicrophoneButtonsRecursive(in: children, level: level + 1)
        }
    }
}

print("\n✅ Поиск завершен!")
