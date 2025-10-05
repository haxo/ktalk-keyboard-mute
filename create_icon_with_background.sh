#!/bin/bash

echo "🎨 Creating microphone icon with background..."

# Create a temporary Swift script to generate icon with background
cat > create_icon_with_bg.swift << 'EOF'
import Cocoa
import AppKit

// Create a 1024x1024 image
let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)

image.lockFocus()

// Create background with gradient
let backgroundRect = NSRect(origin: .zero, size: size)
let backgroundGradient = NSGradient(colors: [
    NSColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 1.0),  // Light blue
    NSColor(red: 0.0, green: 0.2, blue: 0.7, alpha: 1.0)   // Dark blue
])
backgroundGradient?.draw(in: backgroundRect, angle: 135)

// Add subtle pattern to background
let patternColor = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
patternColor.setFill()

// Draw subtle circles pattern
for i in 0..<8 {
    for j in 0..<8 {
        let x = CGFloat(i) * 128 + 64
        let y = CGFloat(j) * 128 + 64
        let circleRect = NSRect(x: x, y: y, width: 4, height: 4)
        let circlePath = NSBezierPath(ovalIn: circleRect)
        circlePath.fill()
    }
}

// Create microphone icon (larger and centered)
let micSize: CGFloat = 600  // Much larger microphone
let micX = (size.width - micSize) / 2
let micY = (size.height - micSize) / 2
let micRect = NSRect(x: micX, y: micY, width: micSize, height: micSize)

// Create gradient for microphone body
let micGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9),  // White
    NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)   // Light gray
])
micGradient?.draw(in: micRect, angle: 90)

// Add border to microphone
NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0).setStroke()
let borderPath = NSBezierPath(roundedRect: micRect, xRadius: 50, yRadius: 50)
borderPath.lineWidth = 8
borderPath.stroke()

// Draw microphone grille (larger)
let grilleColor = NSColor(red: 0.0, green: 0.2, blue: 0.6, alpha: 1.0)
grilleColor.setFill()

let grilleY = micY + 100
let grilleWidth = micSize - 200
let grilleHeight: CGFloat = 8

for i in 0..<8 {
    let y = grilleY + (CGFloat(i) * 50)
    let lineRect = NSRect(x: micX + 100, y: y, width: grilleWidth, height: grilleHeight)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 4, yRadius: 4)
    linePath.fill()
}

// Draw microphone stand (larger)
let standRect = NSRect(x: micX + 150, y: micY - 100, width: 300, height: 100)
let standGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9),
    NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
])
standGradient?.draw(in: standRect, angle: 90)

// Draw microphone base (larger)
let baseRect = NSRect(x: micX - 100, y: micY - 150, width: micSize + 200, height: 100)
let baseGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9),
    NSColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.8)
])
baseGradient?.draw(in: baseRect, angle: 0)

// Add shadow to base
let shadowRect = NSRect(x: micX - 100, y: micY - 160, width: micSize + 200, height: 15)
NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3).setFill()
let shadowPath = NSBezierPath(roundedRect: shadowRect, xRadius: 10, yRadius: 10)
shadowPath.fill()

// Draw microphone cable (larger)
let cableRect = NSRect(x: micX + micSize, y: micY + 200, width: 200, height: 20)
let cableGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9),
    NSColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
])
cableGradient?.draw(in: cableRect, angle: 0)

// Add microphone button (larger)
let buttonRect = NSRect(x: micX + 250, y: micY + 400, width: 100, height: 100)
let buttonGradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0),
    NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0)
])
buttonGradient?.draw(in: buttonRect, angle: 90)

// Add white dot in button
NSColor.white.setFill()
let dotRect = NSRect(x: micX + 275, y: micY + 425, width: 50, height: 50)
let dotPath = NSBezierPath(ovalIn: dotRect)
dotPath.fill()

// Add overall shadow to the entire icon
let shadowImage = NSImage(size: size)
shadowImage.lockFocus()
NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).setFill()
let overallShadowRect = NSRect(x: 20, y: 20, width: size.width - 40, height: size.height - 40)
let overallShadowPath = NSBezierPath(roundedRect: overallShadowRect, xRadius: 100, yRadius: 100)
overallShadowPath.fill()
shadowImage.unlockFocus()

// Composite the shadow behind the main image
shadowImage.draw(in: NSRect(origin: .zero, size: size), from: NSRect(origin: .zero, size: size), operation: .sourceOver, fraction: 1.0)

image.unlockFocus()

// Save as PNG
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])

try! pngData?.write(to: URL(fileURLWithPath: "mic_icon_with_bg.png"))

print("✅ Microphone icon with background created!")
EOF

# Run the Swift script
swift create_icon_with_bg.swift

if [ $? -eq 0 ]; then
    echo "✅ Icon with background generated successfully!"
    
    # Create iconset directory
    rm -rf BackgroundAppIcon.iconset
    mkdir -p BackgroundAppIcon.iconset
    
    # Generate all required sizes from the icon with background
    echo "📐 Generating all icon sizes..."
    
    # 16x16
    sips -s format png -z 16 16 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_16x16.png
    sips -s format png -z 32 32 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_16x16@2x.png
    
    # 32x32
    sips -s format png -z 32 32 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_32x32.png
    sips -s format png -z 64 64 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_32x32@2x.png
    
    # 128x128
    sips -s format png -z 128 128 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_128x128.png
    sips -s format png -z 256 256 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_128x128@2x.png
    
    # 256x256
    sips -s format png -z 256 256 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_256x256.png
    sips -s format png -z 512 512 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_256x256@2x.png
    
    # 512x512
    sips -s format png -z 512 512 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_512x512.png
    sips -s format png -z 1024 1024 mic_icon_with_bg.png --out BackgroundAppIcon.iconset/icon_512x512@2x.png
    
    # Create Contents.json
    cat > BackgroundAppIcon.iconset/Contents.json << 'EOF'
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
    echo "🎨 Creating icon with background .icns file..."
    iconutil -c icns BackgroundAppIcon.iconset
    
    if [ $? -eq 0 ]; then
        echo "✅ Icon with background AppIcon.icns created successfully!"
        # Replace the old icns file
        cp AppIcon.icns AppIcon_small.icns
        cp BackgroundAppIcon.icns AppIcon.icns
        echo "🔄 Replaced AppIcon.icns with background version"
    else
        echo "❌ Failed to create icon with background .icns file"
        exit 1
    fi
    
    # Cleanup
    rm -rf BackgroundAppIcon.iconset create_icon_with_bg.swift mic_icon_with_bg.png
    
    echo "🎉 Icon with background created!"
else
    echo "❌ Failed to generate icon with background"
    exit 1
fi
