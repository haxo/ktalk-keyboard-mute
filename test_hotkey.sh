#!/bin/bash

echo "Testing KeyboardMute hotkey..."

# Send Cmd+Shift+Z using osascript
osascript -e 'tell application "System Events" to keystroke "z" using {command down, shift down}'

echo "Hotkey sent. Check KeyboardMute output for debug messages."
