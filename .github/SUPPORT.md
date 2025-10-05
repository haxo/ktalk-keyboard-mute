# Ktalk KeyboardMute - Support

## Getting Help

### 📚 Documentation

- **[README](README.md)** - Quick start guide and basic usage
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute to the project
- **[Deployment Guide](DEPLOYMENT.md)** - Building and distribution information
- **[Changelog](CHANGELOG.md)** - Version history and changes

### 🐛 Bug Reports

If you found a bug, please:

1. **Check existing issues** - Search [GitHub Issues](https://github.com/yourusername/ktalk-keyboard-mute/issues) first
2. **Use the bug report template** - This helps us understand the problem
3. **Include system information** - macOS version, KeyboardMute version, etc.
4. **Provide steps to reproduce** - Detailed steps to reproduce the issue

### 💡 Feature Requests

Have an idea for a new feature? Please:

1. **Check existing feature requests** - Avoid duplicates
2. **Use the feature request template** - Explain the use case and benefits
3. **Be specific** - Describe exactly what you want and why
4. **Consider implementation** - Think about how it might work

### ❓ General Questions

For general questions:

- **GitHub Discussions** - Community Q&A and general discussion
- **GitHub Issues** - For specific problems or requests
- **Email** - For private or sensitive matters

## Common Issues

### Hotkey Not Working

**Problem**: Cmd+Shift+Z doesn't toggle microphone

**Solutions**:
1. Check if KeyboardMute is running (look for microphone icon in menu bar)
2. Verify no other apps are using the same hotkey
3. Check System Preferences > Security & Privacy > Accessibility
4. Restart the application
5. Try a different hotkey combination

### Microphone Not Toggling

**Problem**: App runs but doesn't actually mute/unmute microphone

**Solutions**:
1. Check System Preferences > Security & Privacy > Microphone
2. Ensure KeyboardMute is in the allowed applications list
3. Grant microphone permissions when prompted
4. Restart the application after granting permissions
5. Check if another app is controlling the microphone

### App Won't Start

**Problem**: KeyboardMute crashes or won't launch

**Solutions**:
1. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```
2. Verify macOS version is 13.0 or later
3. Check console logs for error messages
4. Try building from source
5. Check available disk space

### Ktalk Integration Not Working

**Problem**: M key not sent to Ktalk conference window

**Solutions**:
1. Ensure Ktalk is running with an active conference
2. Check that conference window has visible control buttons
3. Verify accessibility permissions are granted
4. Try focusing the Ktalk window manually
5. Check if Ktalk is in the correct language (Russian/English)

### Visual Feedback Issues

**Problem**: Floating notification doesn't appear or looks wrong

**Solutions**:
1. Check screen resolution and scaling settings
2. Verify no other apps are blocking the notification
3. Try different screen positions
4. Check if notifications are enabled in System Preferences
5. Restart the application

## System Requirements

### Minimum Requirements

- **macOS**: 13.0 (Ventura) or later
- **RAM**: 512 MB available
- **Storage**: 10 MB free space
- **Permissions**: Microphone, Accessibility, Notifications

### Recommended Requirements

- **macOS**: 14.0 (Sonoma) or later
- **RAM**: 1 GB available
- **Storage**: 50 MB free space
- **Display**: Retina display for best visual experience

## Troubleshooting Steps

### 1. Basic Troubleshooting

1. **Restart the application**
2. **Check permissions** in System Preferences
3. **Verify system requirements**
4. **Check for updates**
5. **Restart your Mac**

### 2. Advanced Troubleshooting

1. **Check console logs**:
   ```bash
   log show --predicate 'process == "KeyboardMute"' --last 1h
   ```

2. **Reset permissions**:
   - Remove KeyboardMute from Privacy settings
   - Restart the app and re-grant permissions

3. **Clean installation**:
   - Delete the app
   - Clear preferences
   - Reinstall

4. **Check for conflicts**:
   - Disable other microphone control apps
   - Check for hotkey conflicts
   - Verify no antivirus interference

### 3. Debug Mode

Enable debug logging by running from terminal:

```bash
./KeyboardMute
```

This will show detailed logs in the terminal.

## Contact Information

### GitHub

- **Issues**: [Report bugs and request features](https://github.com/yourusername/ktalk-keyboard-mute/issues)
- **Discussions**: [Community Q&A](https://github.com/yourusername/ktalk-keyboard-mute/discussions)
- **Pull Requests**: [Contribute code](https://github.com/yourusername/ktalk-keyboard-mute/pulls)

### Email

- **General Support**: support@keyboardmute.app
- **Security Issues**: security@keyboardmute.app
- **Business Inquiries**: business@keyboardmute.app

### Response Times

- **GitHub Issues**: 2-3 business days
- **Email Support**: 1-2 business days
- **Security Issues**: 24 hours
- **Critical Bugs**: 4-8 hours

## Community

### Contributing

We welcome contributions! See our [Contributing Guide](CONTRIBUTING.md) for details.

### Code of Conduct

Please read and follow our [Code of Conduct](.github/CODE_OF_CONDUCT.md).

### Recognition

Contributors are recognized in:
- README acknowledgments
- Release notes
- GitHub contributors page

## Feedback

We value your feedback! Please let us know:

- What you like about KeyboardMute
- What could be improved
- New features you'd like to see
- Any other suggestions

## Resources

### External Links

- [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos/)
- [Swift Documentation](https://docs.swift.org/swift-book/)
- [Cocoa Framework Reference](https://developer.apple.com/documentation/cocoa)

### Related Projects

- [MuteDeck](https://github.com/example/mutedeck) - Similar functionality
- [MicMute](https://github.com/example/micmute) - Alternative implementation

---

**Thank you for using KeyboardMute!** 🎉
