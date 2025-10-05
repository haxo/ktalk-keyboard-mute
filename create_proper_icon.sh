#!/bin/bash

echo "🎨 Creating proper microphone icon from SF Symbol..."

# Create a temporary Swift script to generate proper icon
cat > create_icon.swift << 'EOF'
import Cocoa
import AppKit

// Create a 1024x1024 image
let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)

image.lockFocus()

// Set background to transparent
NSColor.clear.setFill()
NSRect(origin: .zero, size: size).fill()

// Create microphone icon using SF Symbol
let micImage = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "Microphone")
micImage?.size = NSSize(width: 800, height: 800) // Leave some padding

// Center the icon
let x = (size.width - 800) / 2
let y = (size.height - 800) / 2
let rect = NSRect(x: x, y: y, width: 800, height: 800)

// Set blue color
NSColor.systemBlue.set()

// Draw the icon with blue color
micImage?.draw(in: rect)

image.unlockFocus()

// Save as PNG
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])

try! pngData?.write(to: URL(fileURLWithPath: "proper_mic_icon.png"))

print("✅ Proper microphone icon created!")
EOF

# Run the Swift script
swift create_icon.swift

if [ $? -eq 0 ]; then
    echo "✅ Icon generated successfully!"
    
    # Create iconset directory
    rm -rf ProperAppIcon.iconset
    mkdir -p ProperAppIcon.iconset
    
    # Generate all required sizes from the proper icon
    echo "📐 Generating all icon sizes..."
    
    # 16x16
    sips -s format png -z 16 16 proper_mic_icon.png --out ProperAppIcon.iconset/icon_16x16.png
    sips -s format png -z 32 32 proper_mic_icon.png --out ProperAppIcon.iconset/icon_16x16@2x.png
    
    # 32x32
    sips -s format png -z 32 32 proper_mic_icon.png --out ProperAppIcon.iconset/icon_32x32.png
    sips -s format png -z 64 64 proper_mic_icon.png --out ProperAppIcon.iconset/icon_32x32@2x.png
    
    # 128x128
    sips -s format png -z 128 128 proper_mic_icon.png --out ProperAppIcon.iconset/icon_128x128.png
    sips -s format png -z 256 256 proper_mic_icon.png --out ProperAppIcon.iconset/icon_128x128@2x.png
    
    # 256x256
    sips -s format png -z 256 256 proper_mic_icon.png --out ProperAppIcon.iconset/icon_256x256.png
    sips -s format png -z 512 512 proper_mic_icon.png --out ProperAppIcon.iconset/icon_256x256@2x.png
    
    # 512x512
    sips -s format png -z 512 512 proper_mic_icon.png --out ProperAppIcon.iconset/icon_512x512.png
    sips -s format png -z 1024 1024 proper_mic_icon.png --out ProperAppIcon.iconset/icon_512x512@2x.png
    
    # Create Contents.json
    cat > ProperAppIcon.iconset/Contents.json << 'EOF'
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
    echo "🎨 Creating proper .icns file..."
    iconutil -c icns ProperAppIcon.iconset
    
    if [ $? -eq 0 ]; then
        echo "✅ Proper AppIcon.icns created successfully!"
        # Replace the old icns file
        cp AppIcon.icns AppIcon_stretched.icns
        cp ProperAppIcon.icns AppIcon.icns
        echo "🔄 Replaced AppIcon.icns with proper version"
    else
        echo "❌ Failed to create proper .icns file"
        exit 1
    fi
    
    # Cleanup
    rm -rf ProperAppIcon.iconset create_icon.swift proper_mic_icon.png
    
    echo "🎉 Proper icon created!"
else
    echo "❌ Failed to generate proper icon"
    exit 1
fi
