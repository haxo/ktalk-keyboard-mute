#!/bin/bash

echo "🎨 Creating 3D microphone icon based on reference..."

# Create a temporary Swift script to generate 3D microphone icon
cat > create_3d_mic.swift << 'EOF'
import Cocoa
import AppKit

// Create a 1024x1024 image
let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)

image.lockFocus()

// Create vibrant gradient background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0),  // Turquoise
    NSColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0),  // Yellow
    NSColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0),  // Orange
    NSColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0),  // Pink
    NSColor(red: 0.6, green: 0.0, blue: 0.8, alpha: 1.0)   // Purple
])
bgGradient?.draw(in: bgRect, angle: 45)

// Add subtle pattern overlay
let patternColor = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
patternColor.setFill()

// Draw subtle circles pattern
for i in 0..<12 {
    for j in 0..<12 {
        let x = CGFloat(i) * 85 + 42
        let y = CGFloat(j) * 85 + 42
        let circleRect = NSRect(x: x, y: y, width: 3, height: 3)
        let circlePath = NSBezierPath(ovalIn: circleRect)
        circlePath.fill()
    }
}

// Create microphone body (cream/beige color)
let micBodyRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micGradient = NSGradient(colors: [
    NSColor(red: 0.95, green: 0.92, blue: 0.85, alpha: 1.0),  // Light cream
    NSColor(red: 0.88, green: 0.84, blue: 0.75, alpha: 1.0),  // Medium cream
    NSColor(red: 0.82, green: 0.78, blue: 0.68, alpha: 1.0)   // Darker cream
])
micGradient?.draw(in: micBodyRect, angle: 90)

// Add highlight to microphone body
let highlightRect = NSRect(x: 360, y: 320, width: 100, height: 384)
let highlightGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4),  // White highlight
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)   // Transparent
])
highlightGradient?.draw(in: highlightRect, angle: 0)

// Draw equalizer bars on microphone body
NSColor.black.setFill()
for i in 0..<8 {
    let x = 380 + (CGFloat(i) * 30)
    let height = CGFloat.random(in: 20...80)
    let y = 400 + (80 - height) / 2
    let barRect = NSRect(x: x, y: y, width: 8, height: height)
    let barPath = NSBezierPath(roundedRect: barRect, xRadius: 4, yRadius: 4)
    barPath.fill()
}

// Create microphone grille (golden/bronze color)
let grilleRect = NSRect(x: 400, y: 650, width: 224, height: 74)
let grilleGradient = NSGradient(colors: [
    NSColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0),  // Golden
    NSColor(red: 0.6, green: 0.4, blue: 0.1, alpha: 1.0),  // Bronze
    NSColor(red: 0.4, green: 0.3, blue: 0.1, alpha: 1.0)   // Dark bronze
])
grilleGradient?.draw(in: grilleRect, angle: 90)

// Add hexagonal pattern to grille
NSColor(red: 0.9, green: 0.7, blue: 0.3, alpha: 0.8).setStroke()
for i in 0..<6 {
    for j in 0..<4 {
        let x = 410 + (CGFloat(i) * 35)
        let y = 660 + (CGFloat(j) * 15)
        let hexPath = NSBezierPath()
        hexPath.move(to: NSPoint(x: x, y: y + 7))
        hexPath.line(to: NSPoint(x: x + 6, y: y + 12))
        hexPath.line(to: NSPoint(x: x + 18, y: y + 12))
        hexPath.line(to: NSPoint(x: x + 24, y: y + 7))
        hexPath.line(to: NSPoint(x: x + 18, y: y + 2))
        hexPath.line(to: NSPoint(x: x + 6, y: y + 2))
        hexPath.close()
        hexPath.lineWidth = 1
        hexPath.stroke()
    }
}

// Create U-shaped holder (chrome/silver)
let holderRect = NSRect(x: 320, y: 350, width: 384, height: 100)
let holderGradient = NSGradient(colors: [
    NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),  // Light silver
    NSColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),  // Medium silver
    NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)   // Dark silver
])
holderGradient?.draw(in: holderRect, angle: 90)

// Add chrome highlights to holder
NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6).setFill()
let chromeHighlightRect = NSRect(x: 330, y: 360, width: 364, height: 20)
let chromeHighlightPath = NSBezierPath(roundedRect: chromeHighlightRect, xRadius: 10, yRadius: 10)
chromeHighlightPath.fill()

// Create attachment points
let attachmentRect1 = NSRect(x: 340, y: 380, width: 20, height: 20)
let attachmentRect2 = NSRect(x: 664, y: 380, width: 20, height: 20)
NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).setFill()
let attachmentPath1 = NSBezierPath(ovalIn: attachmentRect1)
let attachmentPath2 = NSBezierPath(ovalIn: attachmentRect2)
attachmentPath1.fill()
attachmentPath2.fill()

// Add shadow under microphone
let shadowRect = NSRect(x: 360, y: 280, width: 304, height: 20)
NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3).setFill()
let shadowPath = NSBezierPath(roundedRect: shadowRect, xRadius: 10, yRadius: 10)
shadowPath.fill()

// Add overall glow effect
let glowRect = NSRect(x: 50, y: 50, width: 924, height: 924)
NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).setFill()
let glowPath = NSBezierPath(roundedRect: glowRect, xRadius: 50, yRadius: 50)
glowPath.fill()

image.unlockFocus()

// Save as PNG
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])

try! pngData?.write(to: URL(fileURLWithPath: "3d_microphone_icon.png"))

print("✅ 3D microphone icon created!")
EOF

# Run the Swift script
swift create_3d_mic.swift

if [ $? -eq 0 ]; then
    echo "✅ 3D icon generated successfully!"
    
    # Create iconset directory
    rm -rf ThreeDAppIcon.iconset
    mkdir -p ThreeDAppIcon.iconset
    
    # Generate all required sizes from the 3D icon
    echo "📐 Generating all icon sizes..."
    
    # 16x16
    sips -s format png -z 16 16 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_16x16.png
    sips -s format png -z 32 32 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_16x16@2x.png
    
    # 32x32
    sips -s format png -z 32 32 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_32x32.png
    sips -s format png -z 64 64 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_32x32@2x.png
    
    # 128x128
    sips -s format png -z 128 128 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_128x128.png
    sips -s format png -z 256 256 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_128x128@2x.png
    
    # 256x256
    sips -s format png -z 256 256 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_256x256.png
    sips -s format png -z 512 512 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_256x256@2x.png
    
    # 512x512
    sips -s format png -z 512 512 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_512x512.png
    sips -s format png -z 1024 1024 3d_microphone_icon.png --out ThreeDAppIcon.iconset/icon_512x512@2x.png
    
    # Create Contents.json
    cat > ThreeDAppIcon.iconset/Contents.json << 'EOF'
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
    echo "🎨 Creating 3D .icns file..."
    iconutil -c icns ThreeDAppIcon.iconset
    
    if [ $? -eq 0 ]; then
        echo "✅ 3D AppIcon.icns created successfully!"
        # Replace the old icns file
        cp AppIcon.icns AppIcon_old.icns
        cp ThreeDAppIcon.icns AppIcon.icns
        echo "🔄 Replaced AppIcon.icns with 3D version"
    else
        echo "❌ Failed to create 3D .icns file"
        exit 1
    fi
    
    # Cleanup
    rm -rf ThreeDAppIcon.iconset create_3d_mic.swift 3d_microphone_icon.png
    
    echo "🎉 3D microphone icon created!"
else
    echo "❌ Failed to generate 3D icon"
    exit 1
fi
