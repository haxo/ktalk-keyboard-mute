# Changelog

All notable changes to this project will be documented in this file.

## [1.6.0] - 2025-01-07

### Added
- **Automatic state synchronization** - App now automatically checks microphone state in Ktalk every second
- **Real-time state updates** - State synchronizes when user changes microphone settings directly in Ktalk
- **Manual refresh option** - Added "Refresh State" menu item (Cmd+R) for manual state update
- **Smart state detection** - Only updates state when it actually changes to optimize performance
- **Post-action verification** - Additional state check 0.5 seconds after sending M key

### Improved
- **Performance optimization** - State updates only occur when conference window is present
- **Resource management** - Proper cleanup of timers and event handlers on app termination
- **User experience** - Seamless synchronization between app and Ktalk interface

### Technical Details
- Added `stateUpdateTimer` for periodic state monitoring
- Implemented `updateMicrophoneStateFromKtalk()` method for state synchronization
- Added `refreshMicrophoneState()` method for manual updates
- Enhanced `applicationWillTerminate()` for proper resource cleanup

## [1.5.0] - 2025-01-07

### Added
- **Global state management** - Centralized state container with `AppState` class
- **Reactive state updates** - NotificationCenter-based state synchronization
- **Enhanced debugging** - Comprehensive logging for Ktalk window detection
- **Accessibility permissions** - Automatic request for required permissions

### Fixed
- **Hotkey detection** - Resolved Cmd+Shift+Z hotkey registration issues
- **Ktalk window detection** - Improved search for conference windows
- **Microphone button detection** - Enhanced button text recognition for Russian/English
- **State synchronization** - Fixed microphone state updates

### Technical Details
- Refactored code to use centralized state management
- Added extensive debugging for troubleshooting
- Improved Accessibility API usage
- Enhanced button detection algorithms

## [1.4.0] - 2025-01-07

### Added
- **App bundle creation** - Complete macOS application bundle
- **Icon assets** - Professional app icon with multiple resolutions
- **Info.plist** - Proper application metadata
- **Build scripts** - Automated build and packaging

### Fixed
- **Button responsiveness** - Resolved status bar button click issues
- **Window detection** - Improved Ktalk application and window detection
- **Key sending** - Fixed M key transmission to Ktalk

## [1.0.0] - 2025-01-07

### Added
- **Core functionality** - Microphone toggle via Cmd+Shift+Z hotkey
- **Ktalk integration** - Automatic detection and interaction with Ktalk conference windows
- **Status bar interface** - System tray icon with microphone status
- **Visual feedback** - Microphone state indicators and visual plates
- **Accessibility support** - Full Accessibility API integration for UI automation