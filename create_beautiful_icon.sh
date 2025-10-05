#!/bin/bash

echo "🎨 Creating beautiful microphone icon..."

# Create a temporary Swift script to generate beautiful icon
cat > create_beautiful_icon.swift << 'EOF'
import Cocoa
import AppKit

// Create a 1024x1024 image
let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)

image.lockFocus()

// Set background to transparent
NSColor.clear.setFill()
NSRect(origin: .zero, size: size).fill()

// Create beautiful microphone icon with gradient
let micBodyRect = NSRect(x: 300, y: 250, width: 200, height: 350)

// Create gradient for microphone body
let gradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0),  // Bright blue
    NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0)   // Darker blue
])
gradient?.draw(in: micBodyRect, angle: 90)

// Add highlight to microphone body
let highlightRect = NSRect(x: 320, y: 270, width: 60, height: 310)
let highlightGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3),  // White highlight
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)   // Transparent
])
highlightGradient?.draw(in: highlightRect, angle: 0)

// Draw microphone grille with better design
let grilleColor = NSColor(red: 0.0, green: 0.2, blue: 0.6, alpha: 1.0)
grilleColor.setFill()

for i in 0..<6 {
    let y = 300 + (i * 45)
    let lineRect = NSRect(x: 320, y: y, width: 160, height: 6)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 3, yRadius: 3)
    linePath.fill()
}

// Draw microphone stand with gradient
let standRect = NSRect(x: 350, y: 150, width: 100, height: 100)
let standGradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0),
    NSColor(red: 0.0, green: 0.2, blue: 0.7, alpha: 1.0)
])
standGradient?.draw(in: standRect, angle: 90)

// Draw microphone base with gradient
let baseRect = NSRect(x: 200, y: 100, width: 400, height: 50)
let baseGradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0),
    NSColor(red: 0.0, green: 0.1, blue: 0.6, alpha: 1.0)
])
baseGradient?.draw(in: baseRect, angle: 0)

// Add shadow to base
let shadowRect = NSRect(x: 200, y: 90, width: 400, height: 10)
NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).setFill()
let shadowPath = NSBezierPath(roundedRect: shadowRect, xRadius: 5, yRadius: 5)
shadowPath.fill()

// Draw microphone cable with gradient
let cableRect = NSRect(x: 450, y: 400, width: 200, height: 15)
let cableGradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0),
    NSColor(red: 0.0, green: 0.2, blue: 0.7, alpha: 1.0)
])
cableGradient?.draw(in: cableRect, angle: 0)

// Add small details
let detailColor = NSColor(red: 0.0, green: 0.1, blue: 0.5, alpha: 1.0)
detailColor.setFill()

// Microphone button
let buttonRect = NSRect(x: 380, y: 500, width: 40, height: 40)
let buttonPath = NSBezierPath(ovalIn: buttonRect)
buttonPath.fill()

// Add white dot in button
NSColor.white.setFill()
let dotRect = NSRect(x: 390, y: 510, width: 20, height: 20)
let dotPath = NSBezierPath(ovalIn: dotRect)
dotPath.fill()

image.unlockFocus()

// Save as PNG
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])

try! pngData?.write(to: URL(fileURLWithPath: "beautiful_mic_icon.png"))

print("✅ Beautiful microphone icon created!")
EOF

# Run the Swift script
swift create_beautiful_icon.swift

if [ $? -eq 0 ]; then
    echo "✅ Beautiful icon generated successfully!"
    
    # Create iconset directory
    rm -rf BeautifulAppIcon.iconset
    mkdir -p BeautifulAppIcon.iconset
    
    # Generate all required sizes from the beautiful icon
    echo "📐 Generating all icon sizes..."
    
    # 16x16
    sips -s format png -z 16 16 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_16x16.png
    sips -s format png -z 32 32 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_16x16@2x.png
    
    # 32x32
    sips -s format png -z 32 32 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_32x32.png
    sips -s format png -z 64 64 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_32x32@2x.png
    
    # 128x128
    sips -s format png -z 128 128 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_128x128.png
    sips -s format png -z 256 256 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_128x128@2x.png
    
    # 256x256
    sips -s format png -z 256 256 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_256x256.png
    sips -s format png -z 512 512 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_256x256@2x.png
    
    # 512x512
    sips -s format png -z 512 512 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_512x512.png
    sips -s format png -z 1024 1024 beautiful_mic_icon.png --out BeautifulAppIcon.iconset/icon_512x512@2x.png
    
    # Create Contents.json
    cat > BeautifulAppIcon.iconset/Contents.json << 'EOF'
{
  "images" : [
    {
      "filename" : "icon_16x16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_16x16@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_32x32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_32x32@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_128x128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_128x128@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_256x256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_256x256@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_512x512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_512x512@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
    
    # Create .icns file
    echo "🎨 Creating beautiful .icns file..."
    iconutil -c icns BeautifulAppIcon.iconset
    
    if [ $? -eq 0 ]; then
        echo "✅ Beautiful AppIcon.icns created successfully!"
        # Replace the old icns file
        cp AppIcon.icns AppIcon_ugly.icns
        cp BeautifulAppIcon.icns AppIcon.icns
        echo "🔄 Replaced AppIcon.icns with beautiful version"
    else
        echo "❌ Failed to create beautiful .icns file"
        exit 1
    fi
    
    # Cleanup
    rm -rf BeautifulAppIcon.iconset create_beautiful_icon.swift beautiful_mic_icon.png
    
    echo "🎉 Beautiful icon created!"
else
    echo "❌ Failed to generate beautiful icon"
    exit 1
fi
