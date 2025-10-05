#!/bin/bash

echo "🎨 Creating full 20 microphone variants..."

# Create directory
mkdir -p mic_variants

# Function to create variant
create_variant() {
    local num=$1
    local name=$2
    local color1=$3
    local color2=$4
    local mic_type=$5
    
    echo "📱 Creating Variant $num: $name..."
    
    cat > variant${num}.swift << EOF
import Cocoa
import AppKit

let size = NSSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Gradient circle background
let circleRect = NSRect(x: 100, y: 100, width: 824, height: 824)
let gradient = NSGradient(colors: [
    NSColor(red: $color1, alpha: 1.0),
    NSColor(red: $color2, alpha: 1.0)
])
gradient?.draw(in: circleRect, angle: 90)

$mic_type

image.unlockFocus()
let tiffData = image.tiffRepresentation
let bitmapRep = NSBitmapImageRep(data: tiffData!)
let pngData = bitmapRep?.representation(using: .png, properties: [:])
try! pngData?.write(to: URL(fileURLWithPath: "mic_variants/variant${num}_${name,,}.png"))
print("✅ Variant $num created")
EOF
    
    swift variant${num}.swift
    rm variant${num}.swift
}

# Define microphone types
MIC_CLASSIC='// Classic microphone
let micRect = NSRect(x: 400, y: 350, width: 224, height: 324)
NSColor.white.setFill()
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 20, yRadius: 20)
micPath.fill()

// Grille
NSColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0).setFill()
for i in 0..<6 {
    let y = 400 + (CGFloat(i) * 40)
    let lineRect = NSRect(x: 420, y: y, width: 184, height: 8)
    let linePath = NSBezierPath(roundedRect: lineRect, xRadius: 4, yRadius: 4)
    linePath.fill()
}'

MIC_WIRELESS='// Wireless microphone
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
antennaPath.stroke()'

MIC_HANDHELD='// Handheld microphone
let micRect = NSRect(x: 450, y: 300, width: 124, height: 424)
NSColor.white.setFill()
let micPath = NSBezierPath(roundedRect: micRect, xRadius: 15, yRadius: 15)
micPath.fill()

// Handle
let handleRect = NSRect(x: 460, y: 200, width: 104, height: 100)
NSColor.white.setFill()
let handlePath = NSBezierPath(roundedRect: handleRect, xRadius: 10, yRadius: 10)
handlePath.fill()'

MIC_STUDIO='// Studio microphone
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
}'

MIC_HEADSET='// Headset microphone
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
boomPath.stroke()'

MIC_LAVALIER='// Lavalier microphone
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
cablePath.stroke()'

# Create all 20 variants
create_variant 1 "Classic" "1.0, 0.3, 0.3" "0.8, 0.1, 0.1" "$MIC_CLASSIC"
create_variant 2 "Wireless" "0.0, 0.6, 1.0" "0.0, 0.3, 0.8" "$MIC_WIRELESS"
create_variant 3 "Handheld" "0.8, 0.2, 0.8" "0.6, 0.1, 0.6" "$MIC_HANDHELD"
create_variant 4 "Studio" "0.2, 0.8, 0.2" "0.1, 0.6, 0.1" "$MIC_STUDIO"
create_variant 5 "Headset" "1.0, 0.5, 0.0" "0.8, 0.3, 0.0" "$MIC_HEADSET"
create_variant 6 "Lavalier" "0.0, 0.8, 0.8" "0.0, 0.6, 0.6" "$MIC_LAVALIER"
create_variant 7 "Classic" "0.3, 0.2, 0.8" "0.2, 0.1, 0.6" "$MIC_CLASSIC"
create_variant 8 "Wireless" "1.0, 0.2, 0.2" "0.8, 0.1, 0.1" "$MIC_WIRELESS"
create_variant 9 "Handheld" "1.0, 0.8, 0.0" "0.8, 0.6, 0.0" "$MIC_HANDHELD"
create_variant 10 "Studio" "0.6, 0.2, 0.8" "0.4, 0.1, 0.6" "$MIC_STUDIO"
create_variant 11 "Headset" "0.0, 0.8, 1.0" "0.0, 0.6, 0.8" "$MIC_HEADSET"
create_variant 12 "Lavalier" "0.8, 1.0, 0.0" "0.6, 0.8, 0.0" "$MIC_LAVALIER"
create_variant 13 "Classic" "0.6, 0.4, 0.2" "0.4, 0.2, 0.1" "$MIC_CLASSIC"
create_variant 14 "Wireless" "0.5, 0.5, 0.5" "0.3, 0.3, 0.3" "$MIC_WIRELESS"
create_variant 15 "Handheld" "1.0, 0.4, 0.8" "0.8, 0.2, 0.6" "$MIC_HANDHELD"
create_variant 16 "Studio" "0.0, 1.0, 1.0" "0.0, 0.8, 0.8" "$MIC_STUDIO"
create_variant 17 "Headset" "0.8, 0.0, 1.0" "0.6, 0.0, 0.8" "$MIC_HEADSET"
create_variant 18 "Lavalier" "1.0, 0.0, 0.5" "0.8, 0.0, 0.3" "$MIC_LAVALIER"
create_variant 19 "Classic" "0.0, 0.0, 0.0" "0.2, 0.2, 0.2" "$MIC_CLASSIC"
create_variant 20 "Wireless" "1.0, 1.0, 1.0" "0.8, 0.8, 0.8" "$MIC_WIRELESS"

echo ""
echo "🎉 All 20 microphone variants created successfully!"
echo "📁 Check the 'mic_variants' directory:"
echo ""
ls -la mic_variants/
echo ""
echo "🎨 Choose your favorite microphone variant (1-20)!"
