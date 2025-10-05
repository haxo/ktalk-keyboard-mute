#!/bin/bash

echo "🎨 Creating .icns icon from PNG files..."

# Create iconset directory
mkdir -p AppIcon.iconset

# Copy PNG files to iconset with proper naming
cp Assets.xcassets/AppIcon.appiconset/icon_16x16.png AppIcon.iconset/icon_16x16.png
cp Assets.xcassets/AppIcon.appiconset/icon_16x16@2x.png AppIcon.iconset/icon_16x16@2x.png
cp Assets.xcassets/AppIcon.appiconset/icon_32x32.png AppIcon.iconset/icon_32x32.png
cp Assets.xcassets/AppIcon.appiconset/icon_32x32@2x.png AppIcon.iconset/icon_32x32@2x.png
cp Assets.xcassets/AppIcon.appiconset/icon_128x128.png AppIcon.iconset/icon_128x128.png
cp Assets.xcassets/AppIcon.appiconset/icon_128x128@2x.png AppIcon.iconset/icon_128x128@2x.png
cp Assets.xcassets/AppIcon.appiconset/icon_256x256.png AppIcon.iconset/icon_256x256.png
cp Assets.xcassets/AppIcon.appiconset/icon_256x256@2x.png AppIcon.iconset/icon_256x256@2x.png
cp Assets.xcassets/AppIcon.appiconset/icon_512x512.png AppIcon.iconset/icon_512x512.png
cp Assets.xcassets/AppIcon.appiconset/icon_512x512@2x.png AppIcon.iconset/icon_512x512@2x.png

# Create .icns file
iconutil -c icns AppIcon.iconset

if [ $? -eq 0 ]; then
    echo "✅ AppIcon.icns created successfully!"
    rm -rf AppIcon.iconset
else
    echo "❌ Failed to create .icns file"
    exit 1
fi
