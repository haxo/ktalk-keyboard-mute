#!/usr/bin/env swift

import Cocoa
import ApplicationServices

print("🔍 Анализ окна конференции на наличие уникальных иконок...")

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
    exit(1)
}

print("✅ Найдено приложение Толк: \(app.localizedName ?? "Unknown") (PID: \(app.processIdentifier))")

// Получаем окна приложения
let appElement = AXUIElementCreateApplication(app.processIdentifier)
var windowsRef: CFTypeRef?
let windowsResult = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)

guard windowsResult == .success, let windows = windowsRef as? [AXUIElement] else {
    print("❌ Не удалось получить окна приложения")
    exit(1)
}

print("🪟 Найдено \(windows.count) окон:")

for (windowIndex, window) in windows.enumerated() {
    // Получаем заголовок окна
    var titleRef: CFTypeRef?
    let titleResult = AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
    let title = (titleResult == .success) ? (titleRef as? String ?? "Без названия") : "Без названия"
    
    print("\n📱 Окно \(windowIndex + 1): \"\(title)\"")
    
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
    
    print("   📐 Позиция: (\(Int(position.x)), \(Int(position.y)))")
    print("   📏 Размер: \(Int(size.width))x\(Int(size.height))")
    
    // Проверяем, является ли это окном конференции
    let lowerTitle = title.lowercased()
    let isConferenceWindow = lowerTitle.contains("конференц") || 
                            lowerTitle.contains("conference") || 
                            lowerTitle.contains("встреч") || 
                            lowerTitle.contains("meeting") ||
                            lowerTitle.contains("звонок") ||
                            lowerTitle.contains("call") ||
                            lowerTitle.contains("спринт")
    
    if isConferenceWindow {
        print("   🎯 *** ОКНО КОНФЕРЕНЦИИ ***")
    }
    
    // Анализируем все элементы в окне
    print("   🔍 Анализ элементов в окне...")
    analyzeWindowElements(in: window, level: 0, isConferenceWindow: isConferenceWindow)
}

func analyzeWindowElements(in window: AXUIElement, level: Int, isConferenceWindow: Bool) {
    let indent = String(repeating: "  ", count: level + 2)
    
    var childrenRef: CFTypeRef?
    let childrenResult = AXUIElementCopyAttributeValue(window, kAXChildrenAttribute as CFString, &childrenRef)
    
    if childrenResult == .success, let children = childrenRef as? [AXUIElement] {
        var buttonCount = 0
        var imageCount = 0
        var iconCount = 0
        var microphoneElements = 0
        var videoElements = 0
        var conferenceSpecificElements = 0
        
        for element in children {
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
            
            // Получаем позицию и размер элемента
            var positionRef: CFTypeRef?
            var sizeRef: CFTypeRef?
            let posResult = AXUIElementCopyAttributeValue(element, kAXPositionAttribute as CFString, &positionRef)
            let sizeResult = AXUIElementCopyAttributeValue(element, kAXSizeAttribute as CFString, &sizeRef)
            
            var position = CGPoint(x: 0, y: 0)
            var size = CGSize(width: 0, height: 0)
            
            if posResult == .success, let posValue = positionRef {
                AXValueGetValue(posValue as! AXValue, .cgPoint, &position)
            }
            
            if sizeResult == .success, let sizeValue = sizeRef {
                AXValueGetValue(sizeValue as! AXValue, .cgSize, &size)
            }
            
            // Анализируем тип элемента
            if role == "AXButton" {
                buttonCount += 1
                
                // Проверяем на специфичные для конференции элементы
                let allText = "\(title) \(description) \(help) \(value)".lowercased()
                
                if allText.contains("микрофон") || allText.contains("microphone") || allText.contains("mute") || allText.contains("unmute") {
                    microphoneElements += 1
                    print("\(indent)🎤 КНОПКА МИКРОФОНА:")
                    print("\(indent)   Заголовок: '\(title)'")
                    print("\(indent)   Описание: '\(description)'")
                    print("\(indent)   Help: '\(help)'")
                    print("\(indent)   Позиция: (\(Int(position.x)), \(Int(position.y)))")
                    print("\(indent)   Размер: \(Int(size.width))x\(Int(size.height))")
                } else if allText.contains("камер") || allText.contains("camera") || allText.contains("video") {
                    videoElements += 1
                    print("\(indent)📹 КНОПКА КАМЕРЫ:")
                    print("\(indent)   Заголовок: '\(title)'")
                    print("\(indent)   Описание: '\(description)'")
                    print("\(indent)   Help: '\(help)'")
                    print("\(indent)   Позиция: (\(Int(position.x)), \(Int(position.y)))")
                    print("\(indent)   Размер: \(Int(size.width))x\(Int(size.height))")
                } else if allText.contains("поделиться") || allText.contains("share") || 
                         allText.contains("участник") || allText.contains("participant") ||
                         allText.contains("чат") || allText.contains("chat") ||
                         allText.contains("настройк") || allText.contains("setting") ||
                         allText.contains("завершить") || allText.contains("end") ||
                         allText.contains("выйти") || allText.contains("leave") {
                    conferenceSpecificElements += 1
                    print("\(indent)🎯 КНОПКА КОНФЕРЕНЦИИ:")
                    print("\(indent)   Заголовок: '\(title)'")
                    print("\(indent)   Описание: '\(description)'")
                    print("\(indent)   Help: '\(help)'")
                    print("\(indent)   Позиция: (\(Int(position.x)), \(Int(position.y)))")
                    print("\(indent)   Размер: \(Int(size.width))x\(Int(size.height))")
                }
            } else if role == "AXImage" {
                imageCount += 1
                print("\(indent)🖼️ ИЗОБРАЖЕНИЕ:")
                print("\(indent)   Заголовок: '\(title)'")
                print("\(indent)   Описание: '\(description)'")
                print("\(indent)   Позиция: (\(Int(position.x)), \(Int(position.y)))")
                print("\(indent)   Размер: \(Int(size.width))x\(Int(size.height))")
            } else if role == "AXStaticText" && !title.isEmpty {
                // Проверяем текст на специфичные для конференции слова
                let lowerText = title.lowercased()
                if lowerText.contains("участник") || lowerText.contains("participant") ||
                   lowerText.contains("время") || lowerText.contains("time") ||
                   lowerText.contains("звонок") || lowerText.contains("call") ||
                   lowerText.contains("встреч") || lowerText.contains("meeting") {
                    conferenceSpecificElements += 1
                    print("\(indent)📝 ТЕКСТ КОНФЕРЕНЦИИ:")
                    print("\(indent)   Текст: '\(title)'")
                    print("\(indent)   Позиция: (\(Int(position.x)), \(Int(position.y)))")
                    print("\(indent)   Размер: \(Int(size.width))x\(Int(size.height))")
                }
            }
            
            // Рекурсивно анализируем дочерние элементы
            analyzeWindowElements(in: element, level: level + 1, isConferenceWindow: isConferenceWindow)
        }
        
        // Выводим статистику для окна
        print("\(indent)📊 СТАТИСТИКА ОКНА:")
        print("\(indent)   Кнопки: \(buttonCount)")
        print("\(indent)   Изображения: \(imageCount)")
        print("\(indent)   Элементы микрофона: \(microphoneElements)")
        print("\(indent)   Элементы камеры: \(videoElements)")
        print("\(indent)   Элементы конференции: \(conferenceSpecificElements)")
        
        if isConferenceWindow {
            print("\(indent)🎯 УНИКАЛЬНЫЕ ПРИЗНАКИ ОКНА КОНФЕРЕНЦИИ:")
            print("\(indent)   - Наличие кнопок микрофона: \(microphoneElements > 0 ? "✅" : "❌")")
            print("\(indent)   - Наличие кнопок камеры: \(videoElements > 0 ? "✅" : "❌")")
            print("\(indent)   - Специфичные элементы конференции: \(conferenceSpecificElements)")
            print("\(indent)   - Общее количество кнопок: \(buttonCount)")
        }
    }
}

print("\n✅ Анализ завершен!")
