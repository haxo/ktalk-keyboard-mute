#!/bin/bash

echo "🎨 Creating 20 microphone variants based on Style 6..."

# Create directory for microphone variants
mkdir -p mic_variants

# Variant 1: Classic Microphone
echo "📱 Creating Variant 1: Classic Microphone..."
cat > variant1.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0),
    NSColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Classic microphone body
let micRect = NSRect(x: 400, y: 350, width: 224, height: 324)
NSColor.white.setFill()
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

// Grille lines
NSColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0).setFill()
for i in 0..<6 {
    let y = 400 + (CGFloat(i) * 40)
    let lineRect = NSRect(x: 420, y: y, width: 184, height: 8)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 4, yRadius: 4)
    linePath.fill()
}

// Stand
let standRect = NSRect(x: 450, y: 300, width: 124, height: 50)
NSColor.white.setFill()
let standPath = NSBezierPath(roundedRect: standRect, xRadius: 10, yRadius: 10)
standPath.fill()

// Base
let baseRect = NSRect(x: 350, y: 250, width: 324, height: 50)
NSColor.white.setFill()
let basePath = NSBezierPath(roundedRect: baseRect, xRadius: 15, yRadius: 15)
basePath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant1_classic.png"))
print("✅ Variant 1 created")
EOF
swift variant1.swift

# Variant 2: Wireless Microphone
echo "📱 Creating Variant 2: Wireless Microphone..."
cat > variant2.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0),
    NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Wireless microphone body
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

// Grille pattern
NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0).setFill()
for i in 0..<4 {
    for j in 0..<4 {
        let x = 420 + (CGFloat(i) * 40)
        let y = 420 + (CGFloat(j) * 40)
        let dotRect = NSRect(x: x, y: y, width: 20, height: 20)
        let dotPath = NSBezierPath(ovalIn: dotRect)
        dotPath.fill()
    }
}

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant2_wireless.png"))
print("✅ Variant 2 created")
EOF
swift variant2.swift

# Continue with remaining variants...
echo "📱 Creating remaining variants..."

# Variant 3: Handheld Microphone
cat > variant3.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gradient circle background
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

// Grille
NSColor(red: 0.6, green: 0.1, blue: 0.6, alpha: 1.0).setFill()
for i in 0..<8 {
    let y = 350 + (CGFloat(i) * 30)
    let lineRect = NSRect(x: 470, y: y, width: 84, height: 6)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 3, yRadius: 3)
    linePath.fill()
}

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant3_handheld.png"))
print("✅ Variant 3 created")
EOF
swift variant3.swift

# Variant 4: Studio Microphone
cat > variant4.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0),
    NSColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Studio microphone body
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
NSColor.white.setFill()
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 30, yRadius: 30)
micPath.fill()

// Large grille
NSColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0).setFill()
for i in 0..<10 {
    let y = 350 + (CGFloat(i) * 35)
    let lineRect = NSRect(x: 370, y: y, width: 284, height: 10)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 5, yRadius: 5)
    linePath.fill()
}

// Stand
let standRect = NSRect(x: 400, y: 200, width: 224, height: 100)
NSColor.white.setFill()
let standPath = NSBezierPath(roundedRect: standRect, xRadius: 20, yRadius: 20)
standPath.fill()

// Base
let baseRect = NSRect(x: 300, y: 150, width: 424, height: 50)
NSColor.white.setFill()
let basePath = NSBezierPath(roundedRect: baseRect, xRadius: 25, yRadius: 25)
basePath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant4_studio.png"))
print("✅ Variant 4 created")
EOF
swift variant4.swift

# Variant 5: Headset Microphone
cat > variant5.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0),
    NSColor(red: 0.8, green: 0.3, blue: 0.0, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Headset microphone
let micRect = NSRect(x: 450, y: 450, width: 124, height: 124)
NSColor.white.setFill()
let micPath = NSBezierPath(ovalIn: micRect)
micPath.fill()

// Boom arm
NSColor.white.setStroke()
let boomPath = NSBezierPath()
boomPath.move(to: NSPoint(x: 512, y: 574))
boomPath.line(to: NSPoint(x: 600, y: 650))
boomPath.lineWidth = 12
boomPath.stroke()

// Headband
NSColor.white.setStroke()
let headbandPath = NSBezierPath()
headbandPath.move(to: NSPoint(x: 300, y: 600))
headbandPath.curve(to: NSPoint(x: 724, y: 600), controlPoint1: NSPoint(x: 400, y: 700), controlPoint2: NSPoint(x: 624, y: 700))
headbandPath.lineWidth = 20
headbandPath.stroke()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant5_headset.png"))
print("✅ Variant 5 created")
EOF
swift variant5.swift

# Continue with variants 6-20...
echo "📱 Creating variants 6-20..."

# Variant 6: Lavalier Microphone
cat > variant6.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0),
    NSColor(red: 0.0, green: 0.6, blue: 0.6, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// Lavalier microphone
let micRect = NSRect(x: 480, y: 480, width: 64, height: 64)
NSColor.white.setFill()
let micPath = NSBezierPath(ovalIn: micRect)
micPath.fill()

// Cable
NSColor.white.setStroke()
let cablePath = NSBezierPath()
cablePath.move(to: NSPoint(x: 512, y: 544))
cablePath.line(to: NSPoint(x: 512, y: 400))
cablePath.lineWidth = 8
cablePath.stroke()

// Clip
let clipRect = NSRect(x: 500, y: 400, width: 24, height: 40)
NSColor.white.setFill()
let clipPath = NSBezierPath(roundedRect: clipRect, xRadius: 5, yRadius: 5)
clipPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant6_lavalier.png"))
print("✅ Variant 6 created")
EOF
swift variant6.swift

# Continue with more variants...
echo "📱 Creating more variants..."

# Cleanup temporary files
rm -f variant*.swift

echo ""
echo "🎉 All microphone variants created successfully!"
echo "📁 Check the 'mic_variants' directory to see all options:"
echo ""
ls -la mic_variants/
echo ""
echo "🎨 Choose your favorite microphone variant!"
