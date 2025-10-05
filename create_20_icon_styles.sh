#!/bin/bash

echo "🎨 Creating 20 different microphone icon styles..."

# Create directory for all styles
mkdir -p icon_styles

# Style 1: Minimalist Blue Circle
echo "📱 Creating Style 1: Minimalist Blue Circle..."
cat > style1.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Blue circle background
let circleRect = NSRect(x: 200, y: 200, width: 624, height: 624)
let gradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0),
    NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// White microphone
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
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style1_minimalist_blue.png"))
print("✅ Style 1 created")
EOF
swift style1.swift

# Style 2: Dark Theme with Glow
echo "📱 Creating Style 2: Dark Theme with Glow..."
cat > style2.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Dark background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0),
    NSColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 135)

// Glowing microphone
let micRect = NSRect(x: 300, y: 250, width: 424, height: 524)
let micGradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0),
    NSColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0)
])
micGradient?.draw(in: micRect, angle: 90)

// Glow effect
NSColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 0.3).setFill()
let glowRect = NSRect(x: 280, y: 230, width: 464, height: 564)
let glowPath = NSBezierPath(roundedRect: glowRect, xRadius: 30, yRadius: 30)
glowPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style2_dark_glow.png"))
print("✅ Style 2 created")
EOF
swift style2.swift

# Style 3: Flat Design
echo "📱 Creating Style 3: Flat Design..."
cat > style3.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Flat blue background
NSColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0).setFill()
let bgRect = NSRect(origin: .zero, size: size)
let bgPath = NSBezierPath(rect: bgRect)
bgPath.fill()

// Flat white microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 10, yRadius: 10)
micPath.fill()

// Flat grille
NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 1.0).setFill()
for i in 0..<8 {
    let y = 350 + (CGFloat(i) * 50)
    let lineRect = NSRect(x: 370, y: y, width: 284, height: 12)
    let linePath = NSBezierPath(rect: lineRect)
    linePath.fill()
}

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style3_flat.png"))
print("✅ Style 3 created")
EOF
swift style3.swift

# Style 4: Neon Style
echo "📱 Creating Style 4: Neon Style..."
cat > style4.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Black background
NSColor.black.setFill()
let bgRect = NSRect(origin: .zero, size: size)
let bgPath = NSBezierPath(rect: bgRect)
bgPath.fill()

// Neon cyan microphone
NSColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
let micRect = NSRect(x: 300, y: 250, width: 424, height: 524)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

// Neon outline
NSColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.8).setStroke()
micPath.lineWidth = 8
micPath.stroke()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style4_neon.png"))
print("✅ Style 4 created")
EOF
swift style4.swift

# Style 5: Material Design
echo "📱 Creating Style 5: Material Design..."
cat > style5.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Material blue background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0),
    NSColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 45)

// Material microphone with shadow
let shadowRect = NSRect(x: 320, y: 230, width: 384, height: 564)
NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).setFill()
let shadowPath = NSBezierPath(roundedRect: shadowRect, xRadius: 20, yRadius: 20)
shadowPath.fill()

let micRect = NSRect(x: 300, y: 250, width: 424, height: 524)
NSColor.white.setFill()
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style5_material.png"))
print("✅ Style 5 created")
EOF
swift style5.swift

# Continue with remaining styles...
echo "📱 Creating remaining styles..."

# Style 6: Gradient Circle
cat > style6.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gradient circle
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0),
    NSColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 400, y: 350, width: 224, height: 324)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style6_gradient_circle.png"))
print("✅ Style 6 created")
EOF
swift style6.swift

# Style 7: Purple Theme
cat > style7.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Purple background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0),
    NSColor(red: 0.4, green: 0.1, blue: 0.6, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 135)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style7_purple.png"))
print("✅ Style 7 created")
EOF
swift style7.swift

# Style 8: Green Theme
cat > style8.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Green background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0),
    NSColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 90)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style8_green.png"))
print("✅ Style 8 created")
EOF
swift style8.swift

# Style 9: Orange Theme
cat > style9.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Orange background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0),
    NSColor(red: 0.8, green: 0.3, blue: 0.0, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 45)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style9_orange.png"))
print("✅ Style 9 created")
EOF
swift style9.swift

# Style 10: Pink Theme
cat > style10.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Pink background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.4, blue: 0.8, alpha: 1.0),
    NSColor(red: 0.8, green: 0.2, blue: 0.6, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 135)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style10_pink.png"))
print("✅ Style 10 created")
EOF
swift style10.swift

# Continue with styles 11-20...
echo "📱 Creating styles 11-20..."

# Style 11: Teal Theme
cat > style11.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Teal background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0),
    NSColor(red: 0.0, green: 0.6, blue: 0.6, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 90)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style11_teal.png"))
print("✅ Style 11 created")
EOF
swift style11.swift

# Style 12: Red Theme
cat > style12.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Red background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0),
    NSColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 45)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style12_red.png"))
print("✅ Style 12 created")
EOF
swift style12.swift

# Style 13: Yellow Theme
cat > style13.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Yellow background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0),
    NSColor(red: 0.8, green: 0.6, blue: 0.0, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 135)

// Black microphone
NSColor.black.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style13_yellow.png"))
print("✅ Style 13 created")
EOF
swift style13.swift

# Style 14: Indigo Theme
cat > style14.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Indigo background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.3, green: 0.2, blue: 0.8, alpha: 1.0),
    NSColor(red: 0.2, green: 0.1, blue: 0.6, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 90)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style14_indigo.png"))
print("✅ Style 14 created")
EOF
swift style14.swift

# Style 15: Cyan Theme
cat > style15.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Cyan background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0),
    NSColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 45)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style15_cyan.png"))
print("✅ Style 15 created")
EOF
swift style15.swift

# Style 16: Lime Theme
cat > style16.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Lime background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.8, green: 1.0, blue: 0.0, alpha: 1.0),
    NSColor(red: 0.6, green: 0.8, blue: 0.0, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 135)

// Black microphone
NSColor.black.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style16_lime.png"))
print("✅ Style 16 created")
EOF
swift style16.swift

# Style 17: Brown Theme
cat > style17.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Brown background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0),
    NSColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 90)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style17_brown.png"))
print("✅ Style 17 created")
EOF
swift style17.swift

# Style 18: Gray Theme
cat > style18.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gray background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0),
    NSColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 45)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style18_gray.png"))
print("✅ Style 18 created")
EOF
swift style18.swift

# Style 19: Rainbow Theme
cat > style19.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Rainbow background
let bgRect = NSRect(origin: .zero, size: size)
let bgGradient = NSGradient(colors: [
    NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
    NSColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0),
    NSColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0),
    NSColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0),
    NSColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0),
    NSColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0)
])
bgGradient?.draw(in: bgRect, angle: 0)

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style19_rainbow.png"))
print("✅ Style 19 created")
EOF
swift style19.swift

# Style 20: Monochrome Theme
cat > style20.swift << 'EOF'
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Black background
NSColor.black.setFill()
let bgRect = NSRect(origin: .zero, size: size)
let bgPath = NSBezierPath(rect: bgRect)
bgPath.fill()

// White microphone
NSColor.white.setFill()
let micRect = NSRect(x: 350, y: 300, width: 324, height: 424)
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

// White grille
NSColor.white.setFill()
for i in 0..<8 {
    let y = 350 + (CGFloat(i) * 50)
    let lineRect = NSRect(x: 370, y: y, width: 284, height: 12)
    let linePath = NSBezierPath(rect: lineRect)
    linePath.fill()
}

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "icon_styles/style20_monochrome.png"))
print("✅ Style 20 created")
EOF
swift style20.swift

# Cleanup temporary files
rm -f style*.swift

echo ""
echo "🎉 All 20 icon styles created successfully!"
echo "📁 Check the 'icon_styles' directory to see all options:"
echo ""
ls -la icon_styles/
echo ""
echo "🎨 Choose your favorite style and let me know which number you prefer!"
