#!/bin/bash

echo "🔧 Building Ktalk KeyboardMute App Bundle..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf KeyboardMute.app
rm -rf build/

# Create build directory
mkdir -p build

# Compile the Swift application
echo "⚙️ Compiling KeyboardMute.swift..."
swiftc -o build/KeyboardMute KeyboardMute.swift -framework Cocoa -framework Carbon

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi

echo "✅ Compilation successful!"

# Create app bundle structure
echo "📦 Creating app bundle structure..."
mkdir -p KeyboardMute.app/Contents/MacOS
mkdir -p KeyboardMute.app/Contents/Resources
mkdir -p KeyboardMute.app/Contents/Resources/Assets.xcassets

# Copy executable
cp build/KeyboardMute KeyboardMute.app/Contents/MacOS/

# Copy Assets.xcassets
cp -r Assets.xcassets/* KeyboardMute.app/Contents/Resources/Assets.xcassets/

# Copy .icns icon
cp AppIcon.icns KeyboardMute.app/Contents/Resources/

# Create Info.plist
echo "📝 Creating Info.plist..."
cat > KeyboardMute.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>KeyboardMute</string>
    <key>CFBundleIdentifier</key>
    <string>com.ktalk.keyboardmute</string>
    <key>CFBundleName</key>
    <string>Ktalk KeyboardMute</string>
    <key>CFBundleDisplayName</key>
    <string>Ktalk KeyboardMute</string>
    <key>CFBundleVersion</key>
    <string>1.4.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.4.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon.icns</string>
</dict>
</plist>
EOF

# Set executable permissions
chmod +x KeyboardMute.app/Contents/MacOS/KeyboardMute

echo "✅ App bundle created successfully!"
echo "📱 App bundle location: $(pwd)/KeyboardMute.app"
echo ""
echo "🚀 To install:"
echo "   cp -r KeyboardMute.app /Applications/"
echo ""
echo "🎯 To run:"
echo "   open KeyboardMute.app"
