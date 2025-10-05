#!/bin/bash

echo "🔧 Fixing icon proportions..."

# Create temporary directory for fixed icons
mkdir -p fixed_icons

# Function to create properly proportioned icon
create_icon() {
    local size=$1
    local input_file=$2
    local output_file=$3
    
    echo "📐 Creating ${size}x${size} icon..."
    
    # Create a square canvas with proper background
    sips -s format png -z $size $size "$input_file" --out "$output_file"
}

# Get the largest source icon (512x512)
SOURCE_ICON="Assets.xcassets/AppIcon.appiconset/icon_512x512.png"

# Create all required sizes with proper proportions
create_icon 16 "$SOURCE_ICON" "fixed_icons/icon_16x16.png"
create_icon 32 "$SOURCE_ICON" "fixed_icons/icon_16x16@2x.png"
create_icon 32 "$SOURCE_ICON" "fixed_icons/icon_32x32.png"
create_icon 64 "$SOURCE_ICON" "fixed_icons/icon_32x32@2x.png"
create_icon 128 "$SOURCE_ICON" "fixed_icons/icon_128x128.png"
create_icon 256 "$SOURCE_ICON" "fixed_icons/icon_128x128@2x.png"
create_icon 256 "$SOURCE_ICON" "fixed_icons/icon_256x256.png"
create_icon 512 "$SOURCE_ICON" "fixed_icons/icon_256x256@2x.png"
create_icon 512 "$SOURCE_ICON" "fixed_icons/icon_512x512.png"
create_icon 1024 "$SOURCE_ICON" "fixed_icons/icon_512x512@2x.png"

echo "✅ Fixed icons created!"

# Create new iconset directory
rm -rf FixedAppIcon.iconset
mkdir -p FixedAppIcon.iconset

# Copy fixed icons to iconset
cp fixed_icons/* FixedAppIcon.iconset/

# Create Contents.json for fixed iconset
cat > FixedAppIcon.iconset/Contents.json << 'EOF'
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

# Create .icns file from fixed iconset
echo "🎨 Creating fixed .icns file..."
iconutil -c icns FixedAppIcon.iconset

if [ $? -eq 0 ]; then
    echo "✅ Fixed AppIcon.icns created successfully!"
    # Replace the old icns file
    cp AppIcon.icns AppIcon_backup.icns
    cp FixedAppIcon.icns AppIcon.icns
    echo "🔄 Replaced AppIcon.icns with fixed version"
else
    echo "❌ Failed to create fixed .icns file"
    exit 1
fi

# Cleanup
rm -rf fixed_icons FixedAppIcon.iconset FixedAppIcon.icns

echo "🎉 Icon proportions fixed!"
