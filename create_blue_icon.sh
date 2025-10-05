#!/bin/bash

echo "🎨 Creating blue microphone icon..."

# Create a temporary Swift script to generate blue icon
cat > create_blue_icon.swift << 'EOF'
import Cocoa
import AppKit

// Create a 1024x1024 image
let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)

image.lockFocus()

// Set background to transparent
NSColor.clear.setFill()
NSRect(origin: .zero, size: size).fill()

// Create a blue microphone icon manually
let blueColor = NSColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0) // System blue
blueColor.setFill()

// Draw microphone body (rounded rectangle)
let micBodyRect = NSRect(x: 300, y: 200, width: 200, height: 400)
let micBodyPath = NSBezierPath(roundedRect: micBodyRect, xRadius: 40, yRadius: 40)
micBodyPath.fill()

// Draw microphone grille (horizontal lines)
for i in 0..<8 {
    let y = 250 + (i * 40)
    let lineRect = NSRect(x: 320, y: y, width: 160, height: 8)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 4, yRadius: 4)
    linePath.fill()
}

// Draw microphone stand
let standRect = NSRect(x: 350, y: 100, width: 100, height: 100)
let standPath = NSBezierPath(roundedRect: standRect, xRadius: 20, yRadius: 20)
standPath.fill()

// Draw microphone base
let baseRect = NSRect(x: 200, y: 50, width: 400, height: 50)
let basePath = NSBezierPath(roundedRect: baseRect, xRadius: 25, yRadius: 25)
basePath.fill()

// Draw microphone cable
let cableRect = NSRect(x: 450, y: 300, width: 200, height: 20)
let cablePath = NSBezierPath(roundedRect: cableRect, xRadius: 10, yRadius: 10)
cablePath.fill()

image.unlockFocus()

// Save as PNG
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])

try! pngData?.write(to: URL(fileURLWithPath: "blue_mic_icon.png"))

print("✅ Blue microphone icon created!")
EOF

# Run the Swift script
swift create_blue_icon.swift

if [ $? -eq 0 ]; then
    echo "✅ Blue icon generated successfully!"
    
    # Create iconset directory
    rm -rf BlueAppIcon.iconset
    mkdir -p BlueAppIcon.iconset
    
    # Generate all required sizes from the blue icon
    echo "📐 Generating all icon sizes..."
    
    # 16x16
    sips -s format png -z 16 16 blue_mic_icon.png --out BlueAppIcon.iconset/icon_16x16.png
    sips -s format png -z 32 32 blue_mic_icon.png --out BlueAppIcon.iconset/icon_16x16@2x.png
    
    # 32x32
    sips -s format png -z 32 32 blue_mic_icon.png --out BlueAppIcon.iconset/icon_32x32.png
    sips -s format png -z 64 64 blue_mic_icon.png --out BlueAppIcon.iconset/icon_32x32@2x.png
    
    # 128x128
    sips -s format png -z 128 128 blue_mic_icon.png --out BlueAppIcon.iconset/icon_128x128.png
    sips -s format png -z 256 256 blue_mic_icon.png --out BlueAppIcon.iconset/icon_128x128@2x.png
    
    # 256x256
    sips -s format png -z 256 256 blue_mic_icon.png --out BlueAppIcon.iconset/icon_256x256.png
    sips -s format png -z 512 512 blue_mic_icon.png --out BlueAppIcon.iconset/icon_256x256@2x.png
    
    # 512x512
    sips -s format png -z 512 512 blue_mic_icon.png --out BlueAppIcon.iconset/icon_512x512.png
    sips -s format png -z 1024 1024 blue_mic_icon.png --out BlueAppIcon.iconset/icon_512x512@2x.png
    
    # Create Contents.json
    cat > BlueAppIcon.iconset/Contents.json << 'EOF'
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
    echo "🎨 Creating blue .icns file..."
    iconutil -c icns BlueAppIcon.iconset
    
    if [ $? -eq 0 ]; then
        echo "✅ Blue AppIcon.icns created successfully!"
        # Replace the old icns file
        cp AppIcon.icns AppIcon_black.icns
        cp BlueAppIcon.icns AppIcon.icns
        echo "🔄 Replaced AppIcon.icns with blue version"
    else
        echo "❌ Failed to create blue .icns file"
        exit 1
    fi
    
    # Cleanup
    rm -rf BlueAppIcon.iconset create_blue_icon.swift blue_mic_icon.png
    
    echo "🎉 Blue icon created!"
else
    echo "❌ Failed to generate blue icon"
    exit 1
fi
