#!/bin/bash

echo "🎨 Creating additional microphone variants..."

# Create directory
mkdir -p mic_variants

# Variant 7: Blue Classic
echo "📱 Creating Variant 7: Blue Classic..."
cat > variant7.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Blue gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0),
    NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Classic microphone
let micRect = NSRect(x: 400, y: 350, width: 224, height: 324)
NSColor.white.setFill()
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

// Grille
NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0).setFill()
for i in 0..<6 {
    let y = 400 + (CGFloat(i) * 40)
    let lineRect = NSRect(x: 420, y: y, width: 184, height: 8)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 4, yRadius: 4)
    linePath.fill()
}

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant7_blue_classic.png"))
print("✅ Variant 7 created")
EOF
swift variant7.swift

# Variant 8: Green Wireless
echo "📱 Creating Variant 8: Green Wireless..."
cat > variant8.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Green gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0),
    NSColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Wireless microphone
let micRect = NSRect(x: 400, y: 400, width: 224, height: 224)
NSColor.white.setFill()
let micPath = NSBezierPath(ovalIn: micRect)
micPath.fill()

// Antenna
NSColor.white.setStroke()
let antennaPath = NSBezierPath()
antennaPath.move(to: NSPoint(x: 512, y: 624))
antennaPath.line(to: NSPoint(x: 512, y: 700))
antennaPath.lineWidth = 8
antennaPath.stroke()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant8_green_wireless.png"))
print("✅ Variant 8 created")
EOF
swift variant8.swift

# Variant 9: Purple Handheld
echo "📱 Creating Variant 9: Purple Handheld..."
cat > variant9.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Purple gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 0.8, green: 0.2, blue: 0.8, alpha: 1.0),
    NSColor(red: 0.6, green: 0.1, blue: 0.6, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Handheld microphone
let micRect = NSRect(x: 450, y: 300, width: 124, height: 424)
NSColor.white.setFill()
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 15, yRadius: 15)
micPath.fill()

// Handle
let handleRect = NSRect(x: 460, y: 200, width: 104, height: 100)
NSColor.white.setFill()
let handlePath = NSBezierPath(roundedRect: handleRect, xRadius: 10, yRadius: 10)
handlePath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant9_purple_handheld.png"))
print("✅ Variant 9 created")
EOF
swift variant9.swift

# Variant 10: Orange Studio
echo "📱 Creating Variant 10: Orange Studio..."
cat > variant10.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Orange gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0),
    NSColor(red: 0.8, green: 0.3, blue: 0.0, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Studio microphone
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
NSColor.white.setFill()
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 30, yRadius: 30)
micPath.fill()

// Large grille
NSColor(red: 0.8, green: 0.3, blue: 0.0, alpha: 1.0).setFill()
for i in 0..<10 {
    let y = 350 + (CGFloat(i) * 35)
    let lineRect = NSRect(x: 370, y: y, width: 284, height: 10)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 5, yRadius: 5)
    linePath.fill()
}

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant10_orange_studio.png"))
print("✅ Variant 10 created")
EOF
swift variant10.swift

# Cleanup
rm -f variant*.swift

echo ""
echo "🎉 Additional variants created successfully!"
echo "📁 Check the 'mic_variants' directory:"
echo ""
ls -la mic_variants/
echo ""
echo "🎨 Now you have 10 microphone variants to choose from!"
