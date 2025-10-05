# Ktalk KeyboardMute - Security Policy

## Supported Versions

Use this section to tell people about which versions of your project are currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.2.x   | :white_check_mark: |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :x:                |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### 1. Do NOT create a public issue

Security vulnerabilities should be reported privately to avoid potential harm to users.

### 2. Email us directly

Send an email to: security@keyboardmute.app

Include the following information:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### 3. What to expect

- We will acknowledge receipt within 48 hours
- We will investigate and provide updates within 7 days
- We will work with you to resolve the issue
- We will credit you in our security advisories (if desired)

### 4. Responsible Disclosure

We follow responsible disclosure practices:
- We will not publicly disclose the vulnerability until it's fixed
- We will work with you to coordinate the disclosure timeline
- We will provide credit for your contribution

## Security Best Practices

### For Users

- Keep KeyboardMute updated to the latest version
- Only download from official sources (GitHub releases, App Store)
- Verify code signatures when possible
- Report suspicious behavior immediately

### For Developers

- Follow secure coding practices
- Keep dependencies updated
- Use proper input validation
- Implement proper error handling
- Follow the principle of least privilege

## Security Features

### Current Security Measures

- **Sandboxing**: App runs in macOS sandbox
- **Code Signing**: All releases are code signed
- **Notarization**: DMG files are notarized by Apple
- **Minimal Permissions**: Only requests necessary permissions
- **No Data Collection**: No personal data is collected or transmitted

### Permissions Required

- **Microphone Access**: Required for microphone toggle functionality
- **Accessibility Access**: Required for sending keyboard events to other apps
- **Notification Access**: Required for showing status notifications

## Vulnerability Disclosure Timeline

- **Day 0**: Vulnerability reported
- **Day 1**: Acknowledgment and initial assessment
- **Day 7**: Investigation complete, fix in development
- **Day 14**: Fix released in patch version
- **Day 21**: Public disclosure (if coordinated)

## Security Advisories

Security advisories will be published in:
- GitHub Security Advisories
- Project README
- Release notes

## Contact

For security-related questions or concerns:
- Email: security@keyboardmute.app
- GitHub: Create a private security advisory
- Response time: Within 48 hours

## Acknowledgments

We thank all security researchers who responsibly disclose vulnerabilities to help keep our users safe.

---

**Note**: This security policy is subject to change. Please check back regularly for updates.
