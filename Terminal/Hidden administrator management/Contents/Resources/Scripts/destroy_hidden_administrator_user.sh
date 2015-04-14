#!/bin/bash
# Reference: http://hints.macworld.com/article.php?story=20080127172157404

USERNAME=$1

# Show hidden users and enable login for other users not listed on the login screen
defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool FALSE
defaults delete /Library/Preferences/com.apple.loginwindow HiddenUsersList
defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool TRUE

/usr/bin/dscl . delete /Users/$USERNAME                         # Unix name, no whitespaces
/usr/bin/dscl . delete /Groups/admin GroupMembership $USERNAME  # Remove from admin group
