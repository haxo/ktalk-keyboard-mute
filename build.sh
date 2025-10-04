#!/bin/bash

echo "🔧 Компилируем KeyboardMute приложение..."

# Компилируем приложение
swiftc -o KeyboardMute KeyboardMute.swift -framework Cocoa -framework Carbon

if [ $? -eq 0 ]; then
    echo "✅ Компиляция успешна!"
    echo "🚀 Запускаем приложение..."
    ./KeyboardMute
else
    echo "❌ Ошибка компиляции!"
    exit 1
fi