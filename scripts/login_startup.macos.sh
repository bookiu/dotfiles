#!/bin/bash
# 1. Copy com.user.login.script.plist to ~/Library/LaunchAgents/com.user.login.script.plist.
# 2. Run `launchctl load ~/Library/LaunchAgents/com.user.login.script.plist` to enable it.
# 3. Run `launchctl list | grep com.user.login.script` to check

/usr/bin/osascript -e 'quit app "BetterMouse.app"' && sleep 1 && /usr/bin/open -a "BetterMouse.app"
