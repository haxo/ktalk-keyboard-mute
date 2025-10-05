# Ktalk KeyboardMute - Deployment Guide

This guide covers how to build, package, and distribute Ktalk KeyboardMute for different scenarios.

## 🏗️ Building for Distribution

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- Apple Developer Account (for code signing)
- Valid code signing certificate

### Build Process

#### 1. Command Line Build

```bash
# Clean previous builds
rm -f KeyboardMute KeyboardMute.app

# Build the application using the app bundle script
chmod +x build_app_bundle.sh
./build_app_bundle.sh

# Or manually build and create app bundle
swiftc -o KeyboardMute KeyboardMute.swift -framework Cocoa -framework Carbon
mkdir -p KeyboardMute.app/Contents/MacOS
cp KeyboardMute KeyboardMute.app/Contents/MacOS/
cp KeyboardMute.entitlements KeyboardMute.app/Contents/
cp AppIcon.icns KeyboardMute.app/Contents/Resources/
```

#### 2. Xcode Build

1. Open `KeyboardMute.xcodeproj` in Xcode
2. Select "Any Mac" as destination
3. Product → Archive
4. Export as macOS App

### Code Signing

#### 1. Update Bundle Identifier

In Xcode project settings:
- Change Bundle Identifier to your own (e.g., `com.yourcompany.keyboardmute`)
- Update Team and Signing Certificate

#### 2. Update Entitlements

Ensure `KeyboardMute.entitlements` includes necessary permissions:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.device.audio-input</key>
    <true/>
    <key>com.apple.security.device.camera</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-only</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-write</key>
    <true/>
</dict>
</plist>
```

## 🎨 Icon Management

### Creating App Icons

The project includes automated tools for creating app icons from source images:

#### 1. Using the Icon Creation Script

```bash
# Create icon from microphone PNG file
chmod +x create_icon_from_mic.sh
./create_icon_from_mic.sh
```

This script will:
- Convert `free-icon-mic-772252.png` to all required macOS icon sizes
- Generate `.icns` file for the app bundle
- Update `Assets.xcassets` with all icon variants
- Create backup of previous icon

#### 2. Icon Requirements

For proper macOS integration, ensure your source image:
- Is at least 1024x1024 pixels
- Has transparent background (PNG format)
- Uses high contrast colors for visibility at small sizes
- Follows Apple's Human Interface Guidelines

#### 3. Manual Icon Creation

If you need to create icons manually:

```bash
# Create iconset directory
mkdir -p CustomIcon.iconset

# Generate all required sizes
sips -s format png -z 16 16 source.png --out CustomIcon.iconset/icon_16x16.png
sips -s format png -z 32 32 source.png --out CustomIcon.iconset/icon_16x16@2x.png
# ... (repeat for all sizes)

# Create .icns file
iconutil -c icns CustomIcon.iconset
```

## 📦 Packaging

### 1. Create DMG Installer

```bash
# Ensure app bundle is built with proper icon
./build_app_bundle.sh

# Create DMG
hdiutil create -volname "KeyboardMute" -srcfolder KeyboardMute.app -ov -format UDZO KeyboardMute.dmg

# Mount and customize (optional)
hdiutil attach KeyboardMute.dmg
# Add background image, customize layout
hdiutil detach /Volumes/KeyboardMute
```

### 2. Create ZIP Archive

```bash
# Create ZIP for GitHub releases
zip -r KeyboardMute-v1.2.0.zip KeyboardMute.app
```

### 3. Create PKG Installer

```bash
# Create package installer
pkgbuild --root . --identifier com.yourcompany.keyboardmute --version 1.2.0 --install-location /Applications KeyboardMute.pkg
```

## 🚀 Distribution Methods

### 1. GitHub Releases

1. **Create Release:**
   - Go to GitHub repository
   - Click "Releases" → "Create a new release"
   - Tag version (e.g., `v1.2.0`)
   - Upload DMG and ZIP files

2. **Release Notes:**
   ```markdown
   ## Ktalk KeyboardMute v1.2.0
   
   ### New Features
   - Enhanced visual feedback system
   - Improved Ktalk integration
   - Better error handling
   
   ### Bug Fixes
   - Fixed hotkey registration issues
   - Improved accessibility permissions
   
   ### System Requirements
   - macOS 13.0 or later
   - Microphone access required
   ```

### 2. Homebrew Cask

Create `ktalk-keyboard-mute.rb`:

```ruby
cask "ktalk-keyboard-mute" do
  version "1.2.0"
  sha256 "your-sha256-hash"
  
  url "https://github.com/yourusername/ktalk-keyboard-mute/releases/download/v#{version}/KeyboardMute.dmg"
  name "Ktalk KeyboardMute"
  desc "Simple microphone toggle for macOS with Ktalk integration"
  homepage "https://github.com/yourusername/ktalk-keyboard-mute"
  
  app "KeyboardMute.app"
  
  zap trash: [
    "~/Library/Preferences/com.yourcompany.keyboardmute.plist",
    "~/Library/Application Support/KeyboardMute"
  ]
end
```

### 3. Mac App Store

#### Requirements

- App Store Connect account
- App Store review process
- Sandboxing compliance
- Privacy policy

#### Steps

1. **Prepare for App Store:**
   - Update bundle identifier
   - Add App Store metadata
   - Create app icons (all required sizes)
   - Add privacy policy

2. **Upload to App Store Connect:**
   - Archive in Xcode
   - Upload via Xcode or Application Loader
   - Fill out metadata and screenshots
   - Submit for review

### 4. Direct Distribution

#### Website Download

1. **Host on your website:**
   - Upload DMG file
   - Create download page
   - Add installation instructions

2. **Update mechanism:**
   - Implement Sparkle framework
   - Add update checking
   - Provide automatic updates

## 🔐 Security Considerations

### Code Signing

- **Developer ID:** Required for distribution outside App Store
- **Notarization:** Required for macOS 10.15+
- **Hardened Runtime:** Enable for better security

### Notarization Process

```bash
# Submit for notarization
xcrun notarytool submit KeyboardMute.dmg --apple-id your@email.com --password your-app-password --team-id YOUR_TEAM_ID

# Check status
xcrun notarytool history --apple-id your@email.com --password your-app-password --team-id YOUR_TEAM_ID

# Staple notarization
xcrun stapler staple KeyboardMute.dmg
```

### Privacy

- **Privacy Policy:** Required for App Store
- **Data Collection:** Disclose any data collection
- **Permissions:** Explain why permissions are needed

## 📊 Analytics and Monitoring

### Crash Reporting

Consider adding:
- **Crashlytics:** For crash reporting
- **Sentry:** For error tracking
- **Firebase:** For analytics

### Usage Analytics

- **Privacy-compliant analytics**
- **No personal data collection**
- **Opt-in only**

## 🔄 Update Strategy

### Version Management

- **Semantic Versioning:** MAJOR.MINOR.PATCH
- **Changelog:** Document all changes
- **Migration:** Handle data migration if needed

### Update Delivery

1. **GitHub Releases:** Manual download
2. **Homebrew:** Automatic via `brew upgrade`
3. **App Store:** Automatic via App Store
4. **Sparkle:** Automatic updates for direct distribution

## 🧪 Testing Before Release

### Pre-Release Checklist

- [ ] Test on multiple macOS versions
- [ ] Test on different screen sizes
- [ ] Verify all permissions work
- [ ] Test hotkey functionality
- [ ] Verify Ktalk integration
- [ ] Check memory usage
- [ ] Test accessibility features
- [ ] Verify code signing
- [ ] Test notarization
- [ ] Update documentation

### Beta Testing

1. **Internal Testing:**
   - Test with team members
   - Use TestFlight for iOS (if applicable)
   - Test on different hardware

2. **External Testing:**
   - GitHub beta releases
   - Closed beta group
   - Feedback collection

## 📈 Release Metrics

### Track Success

- **Download counts**
- **User feedback**
- **Crash reports**
- **Feature usage**
- **Support requests**

### Continuous Improvement

- **Regular updates**
- **Bug fixes**
- **Feature requests**
- **Performance optimization**

---

For questions about deployment, please open an issue or contact the maintainers.
