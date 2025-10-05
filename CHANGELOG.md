# Ktalk KeyboardMute - Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2024-10-05

### Added
- **New Microphone Icon:** Beautiful modern microphone icon from free-icon-mic-772252.png
- **Icon Creation Tools:** Automated script `create_icon_from_mic.sh` for icon generation
- **App Bundle Support:** Full .app bundle with proper icon integration
- **Assets.xcassets Integration:** Professional icon support for all macOS contexts
- **Visual Polish:** Enhanced app appearance in Finder, Dock, and Launchpad

### Changed
- **Build Process:** Updated to use `build_app_bundle.sh` for proper app bundle creation
- **Icon Management:** Centralized icon creation and management system
- **Documentation:** Updated README with new icon information and build process

### Technical Details
- **Icon Source:** free-icon-mic-772252.png converted to all required macOS sizes
- **Icon Formats:** Generated .icns file and all PNG sizes for Assets.xcassets
- **Build Scripts:** Enhanced build process with proper app bundle structure

## [1.4.0] - 2024-12-19

### Added
- **App Icon:** Modern microphone icon with SF Symbol design
- **Assets.xcassets Integration:** Proper icon support for all macOS contexts
- **Visual Polish:** Professional app appearance in Finder, Dock, and Launchpad

### Changed
- **Code Cleanup:** Removed all debug print statements for cleaner operation
- **Simplified Functions:** Streamlined code structure and removed unnecessary comments
- **Performance:** Reduced console output for better performance
- **User Experience:** Cleaner, more professional application behavior

### Removed
- **Notifications:** Completely removed notification system for silent operation
- **Debug Output:** Eliminated all console logging for production use
- **Verbose Comments:** Removed redundant code comments

## [1.3.0] - 2024-12-19

### Added
- **Smart State Detection:** Automatically reads microphone state from Ktalk interface buttons
- **Intelligent Conference Detection:** Finds conference windows by analyzing control buttons
- **State Synchronization:** Updates status bar icon based on actual microphone state
- **Enhanced Button Recognition:** Detects "Включить микрофон" and "Выключить микрофон" buttons
- **Conference Window Filtering:** Excludes non-conference windows (like "Join" dialogs)

### Changed
- **BREAKING:** Removed periodic synchronization timer for cleaner operation
- **BREAKING:** State detection now based on interface buttons rather than manual toggle
- **BREAKING:** Simplified codebase by removing complex sync logic
- **Improved:** Status bar icon now accurately reflects microphone state
- **Improved:** Floating notification shows correct microphone state

### Fixed
- Status bar icon no longer shows incorrect state
- Microphone state properly synchronized with Ktalk interface
- Removed code complexity and potential race conditions

## [1.2.0] - 2024-12-19

### Added
- Comprehensive README with detailed installation and usage instructions
- MIT License file
- Proper .gitignore for macOS/Xcode projects
- Enhanced error handling and logging
- Better visual feedback system

### Changed
- **BREAKING:** Cleaned up codebase - removed unused functions and commented code
- **BREAKING:** Standardized all comments to English
- **BREAKING:** Simplified hotkey from `Cmd+Shift+M` to `Cmd+Shift+Z` for better compatibility
- Improved floating notification appearance and behavior
- Enhanced Ktalk integration with better window detection
- Optimized visual feedback performance
- Updated menu text to reflect new hotkey

### Fixed
- Removed segmentation fault issues with NSVisualEffectView
- Fixed hotkey registration conflicts
- Improved accessibility permissions handling
- Better error messages and user feedback

### Removed
- Unused NSVisualEffectView implementation (caused crashes)
- Unused Core Animation implementation
- Unused NSStatusBar notification implementation
- Commented-out code and debugging statements
- Russian language comments (standardized to English)

## [1.1.0] - 2024-12-18

### Added
- Floating notification system using NSPanel
- Ktalk conference integration
- Dynamic size calculation based on screen resolution
- Visual feedback with color-coded microphone status
- Enhanced window detection for conference applications

### Changed
- Improved hotkey registration process
- Better error handling for accessibility permissions
- Enhanced visual feedback timing and appearance

### Fixed
- Memory leaks in event handler registration
- Window detection issues with Ktalk
- Visual feedback positioning on different screen sizes

## [1.0.0] - 2024-12-17

### Added
- Initial release
- Basic microphone toggle functionality
- Global hotkey support (`Cmd+Shift+M`)
- Menu bar integration
- System notification support
- Basic accessibility permissions handling

### Technical Details
- Built with Swift 5.0
- Uses Cocoa and Carbon frameworks
- Requires macOS 13.0 or later
- Sandboxed application with proper entitlements