#!/bin/bash

# Ktalk KeyboardMute Build Script
# Compiles and runs the Ktalk KeyboardMute application

set -e  # Exit on any error

echo "🔧 Building Ktalk KeyboardMute application..."

# Check if Swift is available
if ! command -v swiftc &> /dev/null; then
    echo "❌ Swift compiler not found. Please install Xcode Command Line Tools:"
    echo "   xcode-select --install"
    exit 1
fi

# Clean previous build
if [ -f "KeyboardMute" ]; then
    echo "🧹 Cleaning previous build..."
    rm -f KeyboardMute
fi

# Compile the application
echo "⚙️ Compiling KeyboardMute.swift..."
swiftc -o KeyboardMute KeyboardMute.swift -framework Cocoa -framework Carbon

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    echo "🚀 Starting Ktalk KeyboardMute..."
    echo "   Use Cmd+Shift+Z to toggle microphone"
    echo "   Press Ctrl+C to quit"
    echo ""
    ./KeyboardMute
else
    echo "❌ Compilation failed!"
    exit 1
fi