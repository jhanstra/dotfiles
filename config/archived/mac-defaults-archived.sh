# Mac defaults to keep around for reference but I don't use anymore

# Creates hot corners, but I've found in practice they annoy me more than help

# Bottom left hot corner: mission control
# defaults write com.apple.dock wvous-bl-corner -int 2
# defaults write com.apple.dock wvous-bl-modifier -int 0

# Bottom right hot corner: launchpad (application drawer)
# defaults write com.apple.dock wvous-br-corner -int 11
# defaults write com.apple.dock wvous-br-modifier -int 0

# Top left hot corner: lock screen
# defaults write com.apple.dock wvous-tl-corner -int 13
# defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right hot corner: show desktop
# defaults write com.apple.dock wvous-tr-corner -int 4
# defaults write com.apple.dock wvous-tr-modifier -int 0

# Quick Look text selection: no-op on modern macOS (selection is built in)
# defaults write com.apple.finder QLEnableTextSelection -bool true

# Safari internal debug menu: Develop menu covers day-to-day needs
# defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Legacy WebKit2 preference key; replaced by WebKitDeveloperExtras above
# defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
