# mac-defaults.sh: set reasonable macOS defaults
# Original idea: https://github.com/mathiasbynens/dotfiles/blob/master/.macos

set_finder_icon_grid() {
  local view_settings="$1"
  local finder_plist="$HOME/Library/Preferences/com.apple.finder.plist"

  /usr/libexec/PlistBuddy -c "Add :$view_settings dict" "$finder_plist" 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Add :$view_settings:IconViewSettings dict" "$finder_plist" 2>/dev/null || true

  if ! /usr/libexec/PlistBuddy \
    -c "Set :$view_settings:IconViewSettings:arrangeBy grid" "$finder_plist" 2>/dev/null; then
    /usr/libexec/PlistBuddy \
      -c "Add :$view_settings:IconViewSettings:arrangeBy string grid" "$finder_plist"
  fi
}

# --- General UI/UX ---

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -r -domain local -domain system -domain user

# Disable text substitutions that fight coding:
# capitalization, smart dashes/quotes, double-space periods, and autocorrect
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


# --- Trackpad, mouse, keyboard, Bluetooth accessories, and input ---

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable press-and-hold for keys in favor of key repeat (also helps VS Code)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 20


# --- Finder ---

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show extension names in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable snap-to-grid for icons on the desktop and in other icon views
set_finder_icon_grid DesktopViewSettings
set_finder_icon_grid FK_StandardViewSettings
set_finder_icon_grid StandardViewSettings

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `Nlsv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Use AirDrop over every interface, not just wifi and bluetooth
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Hide files on the Desktop
defaults write com.apple.finder CreateDesktop -bool false


# --- Dock and Spaces ---

# Place dock on the right
defaults write com.apple.dock orientation -string "right"

# Auto-hide the dock
defaults write com.apple.dock autohide -bool true

# Set the delay before the dock shows
defaults write com.apple.dock autohide-delay -float 0

# Set dock tile size
defaults write com.apple.dock tilesize -int 24

# Show recents in dock
defaults write com.apple.dock show-recents -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false


# --- Browser development, Messages, menu bar ---

# Safari's sandbox blocks command-line writes to its preferences on modern macOS.
# Enable its Develop menu and hide its favorites bar from Safari's Settings UI.
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Set clock to military time
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm:ss"

# Messages: disable automatic emoji substitution
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Restart Finder and Dock so changes take effect. Explicitly ask launchd to
# relaunch Dock because Spaces gestures do not work while Dock is absent.
launchctl kickstart -k "gui/$(id -u)/com.apple.Dock.agent"
killall Finder 2>/dev/null || true
