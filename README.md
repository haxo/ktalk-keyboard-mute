# Ktalk KeyboardMute

A macOS application that provides global hotkey support for toggling microphone in Ktalk conference calls.

## Features

- **Global Hotkey Support** - Toggle microphone with `Cmd+Shift+Z` from anywhere
- **Automatic Ktalk Detection** - Finds and interacts with Ktalk conference windows
- **Real-time State Sync** - Automatically synchronizes with Ktalk microphone state
- **Visual Feedback** - Status bar icon and visual plates show microphone state
- **Accessibility Integration** - Uses macOS Accessibility API for UI automation

## Installation

1. Download the latest release from [Releases](../../releases)
2. Extract `KeyboardMute.app` from the archive
3. Move to `/Applications/` folder
4. Grant Accessibility permissions when prompted

## Usage

### Basic Usage
- Press `Cmd+Shift+Z` to toggle microphone in Ktalk
- Click the status bar icon to toggle microphone
- Right-click for menu options

### Menu Options
- **Toggle Microphone (Cmd+Shift+Z)** - Toggle microphone state
- **Refresh State (Cmd+R)** - Manually refresh microphone state
- **Quit** - Exit application

### Visual Indicators
- **Microphone Icon** - Shows current microphone state
- **Visual Plate** - Temporary overlay showing state change
- **Status Bar** - Always visible microphone status

## Requirements

- macOS 10.15 or later
- Accessibility permissions
- Ktalk application installed

## Permissions

The app requires Accessibility permissions to:
- Detect Ktalk conference windows
- Read button states and text
- Send keyboard events to Ktalk

Grant permissions in: **System Preferences > Security & Privacy > Privacy > Accessibility**

## Technical Details

### Architecture
- **Swift-based** macOS application
- **Accessibility API** for UI automation
- **Carbon framework** for global hotkeys
- **Timer-based** state synchronization

### State Management
- Centralized `AppState` class
- NotificationCenter-based updates
- Real-time Ktalk state monitoring
- Automatic state synchronization

### Ktalk Integration
- Automatic application detection
- Conference window identification
- Button state analysis
- Keyboard event injection

## Development

### Building
```bash
./build_app_bundle.sh
```

### Running
```bash
open KeyboardMute.app
```

### Testing
```bash
./test_hotkey.sh
```

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

For issues and feature requests, please use the [GitHub Issues](../../issues) page.