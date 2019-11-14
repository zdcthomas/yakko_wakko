# System prefs can't be open
osascript -e 'tell application "System Preferences" to quit'

# Ask for the password first
sudo -v

echo " === Keep-alive: update existing `sudo` time stamp until `.macos` has finished"
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo " === Install xcode tools"
xcode-select --install

echo " === Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

echo " === Reveal IP address, hostname, OS version, etc. when clicking the clock
in the login window "
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo " === Show icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo " === Finder: show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo " === Show the ~/Library folder"
chflags nohidden ~/Library

echo " === Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo " === Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo " === Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo " === Reduce the standard key repeat rate"
defaults write -g InitialKeyRepeat -int 5 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
