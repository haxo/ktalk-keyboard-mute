# Ktalk KeyboardMute

A smart macOS application that provides instant microphone control for Ktalk video conferences. Features intelligent conference window detection and automatic state synchronization.

## ✨ Features

- 🎤 **Smart microphone toggle** - Instantly mute/unmute your microphone in Ktalk
- ⌨️ **Global hotkey support** - Use `Cmd+Shift+Z` from anywhere in the system
- 🎯 **Intelligent conference detection** - Automatically finds Ktalk conference windows
- 🔄 **State synchronization** - Reads microphone state from Ktalk interface
- 🎨 **Visual feedback** - Status bar icon and floating notification show microphone status
- 📱 **Menu bar integration** - Easy access via system tray icon
- 🎨 **Modern app icon** - Beautiful microphone icon designed for macOS
- 🔒 **Privacy focused** - No data collection, runs locally on your machine

## 🚀 Installation

### Option 1: Build from Source (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/ktalk-keyboard-mute.git
   cd ktalk-keyboard-mute
   ```

2. **Build the application:**
   ```bash
   chmod +x build_app_bundle.sh
   ./build_app_bundle.sh
   ```

3. **Run the application:**
   ```bash
   open KeyboardMute.app
   ```

### Option 2: Using Xcode

1. Open `KeyboardMute.xcodeproj` in Xcode
2. Select the "KeyboardMute" scheme
3. Press `Cmd+R` to build and run

### Option 3: Manual Compilation

```bash
swiftc -o KeyboardMute KeyboardMute.swift -framework Cocoa -framework Carbon
./KeyboardMute
```

## 📖 Usage

1. **First Launch:** The app will request microphone permissions on first run
2. **Menu Bar:** Look for the microphone icon in your menu bar
3. **Toggle Microphone:** 
   - Press `Cmd+Shift+Z` from anywhere
   - Or click the microphone icon in the menu bar
4. **Visual Feedback:** A beautiful floating notification will appear showing the current microphone status

## 🎯 Ktalk Integration

KeyboardMute features intelligent integration with Ktalk conference software:

### 🔍 Smart Conference Detection
- **Window Analysis:** Scans all Ktalk application windows
- **Button Recognition:** Identifies conference control buttons (microphone, camera, chat)
- **State Reading:** Determines current microphone state from interface buttons
- **Filtering:** Excludes non-conference windows (like "Join" dialogs)

### 🎤 State Synchronization
- **"Включить микрофон" button** → Microphone is OFF → Blue icon, no strikethrough
- **"Выключить микрофон" button** → Microphone is ON → Red strikethrough icon
- **Automatic Updates:** State updates when conference window is found
- **Visual Feedback:** Status bar icon and floating notification reflect current state

### ⌨️ Hotkey Integration
- **Global Hotkey:** `Cmd+Shift+Z` works from anywhere
- **Smart Toggle:** Sends M key to Ktalk conference window
- **State Sync:** Updates interface state after toggle

## ⚙️ Configuration

### Hotkey Customization

To change the hotkey, modify the `registerGlobalHotkey()` function in `KeyboardMute.swift`:

```swift
let keyCode: UInt32 = 6 // Change this to your preferred key (6 = Z)
let modifiers: UInt32 = UInt32(cmdKey | shiftKey) // Modify modifier keys
```

### Visual Feedback Customization

The floating notification appearance can be customized in the `createPanelPlate()` function:

```swift
let plateSize = minDimension * 0.15 // Adjust size (15% of screen)
let iconSize = plateSize * 0.6 // Adjust icon size (60% of plate)
```

## 🔧 System Requirements

- **macOS:** 13.0 (Ventura) or later
- **Xcode:** 15.0 or later (for building from source)
- **Swift:** 5.0 or later
- **Permissions:** Microphone access required

## 🛠️ Troubleshooting

### App doesn't toggle microphone
1. Check System Preferences > Security & Privacy > Microphone
2. Ensure KeyboardMute is in the allowed applications list
3. Restart the application after granting permissions

### Hotkeys not working
1. Verify the app is running (check menu bar for microphone icon)
2. Check for conflicts with other applications using the same hotkey
3. Try restarting the application

### App won't start
1. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```
2. Verify macOS version is 13.0 or later
3. Check console logs for error messages

### Ktalk integration not working
1. Ensure Ktalk is running and has an active conference window
2. Check that the conference window has visible microphone/camera control buttons
3. Verify accessibility permissions are granted to KeyboardMute

## 🔒 Permissions Required

KeyboardMute requires the following permissions:

- **Microphone Access:** To detect and toggle microphone state
- **Accessibility Access:** To send keyboard events to other applications
- **Notification Access:** To show status notifications

Grant these permissions when prompted, or manually enable them in System Preferences.

## 🏗️ Development

### Project Structure

```
ktalk-keyboard-mute/
├── KeyboardMute.swift          # Main application code
├── KeyboardMute.xcodeproj/     # Xcode project file
├── KeyboardMute.entitlements   # App sandbox entitlements
├── build_app_bundle.sh         # Build script for app bundle
├── create_icon_from_mic.sh     # Icon creation script
├── Assets.xcassets/            # App icons and assets
├── AppIcon.icns                # Main app icon
├── free-icon-mic-772252.png    # Source microphone icon
├── launch_keyboard_mute.sh     # Launch script for .app bundle
├── start_keyboard_mute.sh      # Background launch script
└── README.md                   # This file
```

### Building for Distribution

1. **Archive in Xcode:**
   - Select "Any Mac" as destination
   - Product > Archive
   - Export as macOS App

2. **Code Signing:**
   - Update bundle identifier in project settings
   - Configure signing certificate
   - Update entitlements as needed

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Test thoroughly on macOS
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

- **Issues:** Report bugs and request features on [GitHub Issues](https://github.com/yourusername/ktalk-keyboard-mute/issues)
- **Discussions:** Join the conversation in [GitHub Discussions](https://github.com/yourusername/ktalk-keyboard-mute/discussions)
- **Email:** Contact the maintainer directly

## 🙏 Acknowledgments

- Built with Swift and Cocoa frameworks
- Inspired by the need for quick microphone control during remote work
- Special thanks to the macOS development community

## 📊 Version History

### v1.5.0 (Current)
- ✅ **New microphone icon** - Beautiful modern icon designed for macOS
- ✅ **App bundle support** - Full .app bundle with proper icon integration
- ✅ **Assets.xcassets integration** - Professional icon support for all contexts
- ✅ **Icon creation tools** - Automated scripts for icon generation
- ✅ **Enhanced visual polish** - Professional appearance in Finder, Dock, and Launchpad

### v1.4.0
- ✅ Cleaned and optimized codebase
- ✅ Improved visual feedback system
- ✅ Enhanced Ktalk integration
- ✅ Better error handling and logging
- ✅ Updated documentation

### v1.1.0
- Added floating notification system
- Implemented Ktalk conference integration
- Improved hotkey registration
- Enhanced visual feedback

### v1.0.0
- Initial release
- Basic microphone toggle functionality
- Global hotkey support
- Menu bar integration

---

**Made with ❤️ for the macOS community**