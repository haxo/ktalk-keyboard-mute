#!/bin/bash

echo "🎨 Creating app icon from free-icon-mic-772252.png..."

# Check if the source file exists
if [ ! -f "free-icon-mic-772252.png" ]; then
    echo "❌ Source file not found!"
    exit 1
fi

echo "✅ Found source file: free-icon-mic-772252.png"

# Create iconset directory
rm -rf MicAppIcon.iconset
mkdir -p MicAppIcon.iconset

# Generate all required sizes from the source file
echo "📐 Generating all icon sizes from source file..."

# 16x16
sips -s format png -z 16 16 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_16x16.png
sips -s format png -z 32 32 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_16x16@2x.png

# 32x32
sips -s format png -z 32 32 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_32x32.png
sips -s format png -z 64 64 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_32x32@2x.png

# 128x128
sips -s format png -z 128 128 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_128x128.png
sips -s format png -z 256 256 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_128x128@2x.png

# 256x256
sips -s format png -z 256 256 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_256x256.png
sips -s format png -z 512 512 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_256x256@2x.png

# 512x512
sips -s format png -z 512 512 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_512x512.png
sips -s format png -z 1024 1024 free-icon-mic-772252.png --out MicAppIcon.iconset/icon_512x512@2x.png

# Create Contents.json
cat > MicAppIcon.iconset/Contents.json << 'EOF'
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
echo "🎨 Creating .icns file from microphone icon..."
iconutil -c icns MicAppIcon.iconset

if [ $? -eq 0 ]; then
    echo "✅ MicAppIcon.icns created successfully!"
    
    # Backup current icon
    if [ -f "AppIcon.icns" ]; then
        cp AppIcon.icns AppIcon_backup.icns
        echo "💾 Backed up current AppIcon.icns to AppIcon_backup.icns"
    fi
    
    # Replace the main icon
    cp MicAppIcon.icns AppIcon.icns
    echo "🔄 Replaced AppIcon.icns with microphone icon version"
    
    # Show file info
    echo ""
    echo "📊 File information:"
    ls -la free-icon-mic-772252.png
    ls -la MicAppIcon.icns
    ls -la AppIcon.icns
else
    echo "❌ Failed to create .icns file"
    exit 1
fi

# Cleanup
rm -rf MicAppIcon.iconset

echo ""
echo "🎉 Microphone icon created successfully!"
echo "📁 The PNG file has been converted to all required macOS icon sizes"
echo "🎯 AppIcon.icns has been updated with the microphone icon"
