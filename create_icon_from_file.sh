#!/bin/bash

echo "🎨 Creating app icon from existing PNG file..."

# Check if the source file exists
if [ ! -f "olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png" ]; then
    echo "❌ Source file not found!"
    exit 1
fi

echo "✅ Found source file: olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png"

# Create iconset directory
rm -rf CustomAppIcon.iconset
mkdir -p CustomAppIcon.iconset

# Generate all required sizes from the source file
echo "📐 Generating all icon sizes from source file..."

# 16x16
sips -s format png -z 16 16 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_16x16.png
sips -s format png -z 32 32 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_16x16@2x.png

# 32x32
sips -s format png -z 32 32 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_32x32.png
sips -s format png -z 64 64 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_32x32@2x.png

# 128x128
sips -s format png -z 128 128 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_128x128.png
sips -s format png -z 256 256 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_128x128@2x.png

# 256x256
sips -s format png -z 256 256 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_256x256.png
sips -s format png -z 512 512 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_256x256@2x.png

# 512x512
sips -s format png -z 512 512 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_512x512.png
sips -s format png -z 1024 1024 olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png --out CustomAppIcon.iconset/icon_512x512@2x.png

# Create Contents.json
cat > CustomAppIcon.iconset/Contents.json << 'EOF'
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
echo "🎨 Creating .icns file from source image..."
iconutil -c icns CustomAppIcon.iconset

if [ $? -eq 0 ]; then
    echo "✅ Custom AppIcon.icns created successfully!"
    # Replace the old icns file
    cp AppIcon.icns AppIcon_3d.icns
    cp CustomAppIcon.icns AppIcon.icns
    echo "🔄 Replaced AppIcon.icns with custom version from source file"
    
    # Show file info
    echo ""
    echo "📊 File information:"
    ls -la olivergrimes51_Application_icon_for_MacOS_Tahoe_with_a_micropho.png
    ls -la AppIcon.icns
else
    echo "❌ Failed to create .icns file"
    exit 1
fi

# Cleanup
rm -rf CustomAppIcon.iconset

echo ""
echo "🎉 Custom icon created from source file!"
echo "📁 The original PNG file has been converted to all required macOS icon sizes"
