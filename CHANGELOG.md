# Ktalk KeyboardMute - Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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