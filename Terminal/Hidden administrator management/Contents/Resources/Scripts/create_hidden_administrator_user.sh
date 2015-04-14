#!/bin/bash
# Reference: http://hints.macworld.com/article.php?story=20080127172157404

USERNAME=$1
PASSWORD=$2

/usr/bin/dscl . create /Users/$USERNAME                         # Unix name, no whitespaces
/usr/bin/dscl . create /Users/$USERNAME PrimaryGroupID 20       # Staff
/usr/bin/dscl . create /Users/$USERNAME UniqueID 499            # Below 500
/usr/bin/dscl . create /Users/$USERNAME UserShell /bin/bash
/usr/bin/dscl . passwd /Users/$USERNAME $PASSWORD
/usr/bin/dscl . append /Groups/admin GroupMembership $USERNAME  # Add to admin group

# Hide just created user and disable login for other users not listed on the login screen
defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool TRUE
defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array $USERNAME
defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool TRUE
