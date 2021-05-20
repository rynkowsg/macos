#!/usr/bin/env bash

# Applies system and application defaults.
# Inspirations:
# - https://github.com/bkuhlmann/mac_os-config/blob/main/bin/apply_default_settings
# - https://gist.github.com/Tristor/d3c699d16f6c1bbeec8f4c9d647a1f24
# - https://www.cultofmac.com/646404/secret-mac-settings/
# - https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# - https://gist.github.com/cmdoptesc/506a3017bc8acdf9787ddc2fcead0688
# - https://gist.github.com/llimllib/aa4420cac617774ee2a54d8603d862e4
# - https://github.com/driesvints/dotfiles/blob/main/.macos

# Websites:
# - https://macos-defaults.com
# - https://www.defaults-write.com

###############################################################################
# Prepare script                                                              #
###############################################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Computer Name                                                               #
###############################################################################

read -p "What is this machine's label (Example: \"Alchemist\")? " mac_os_label
if [[ -z "$mac_os_label" ]]; then
  printf "ERROR: Invalid MacOS label.\n"
  exit 1
fi

read -p "What is this machine's name (Example: \"alchemist\")? " mac_os_name
if [[ -z "$mac_os_name" ]]; then
  printf "ERROR: Invalid MacOS name.\n"
  exit 1
fi

sudo scutil --set ComputerName "$mac_os_label"
sudo scutil --set HostName "$mac_os_name"
sudo scutil --set LocalHostName "$mac_os_name"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$mac_os_name"

###############################################################################
# General UI/UX                                                               #
###############################################################################

#############
### LOGIN ###
#############

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Reveal IP address, hostname, OS version, etc. when clicking login window clock
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable window resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
# More: https://discussions.apple.com/thread/4074116z

# Disable relaunching apps (TODO: read about this option later)
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
# More: https://apple.stackexchange.com/a/29343
#       https://apple.stackexchange.com/a/44903

###############
### WINDOWS ###
###############

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

###################
### PERFORMANCE ###
###################

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

################
### SECURITY ###
################

# Turn off the 'Application Downloaded from Internet' quarantine warning
# Warning: doesn't work on Big Sur
# https://macos-defaults.com/misc/LSQuarantine.html
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# KEYBOARD

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
# More: https://apple.stackexchange.com/a/60496

# LANGUAGES

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "pl"
# previously I had "en-GB" "pl-GB"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=GBP"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/London"# > /dev/null

###############################################################################
# Energy saving                                                               #
###############################################################################


###############################################################################
# Screen                                                                      #
###############################################################################


###############################################################################
# Finder                                                                      #
###############################################################################

# Add a quit option to the Finder.
# Allows quitting via ⌘ + Q; doing so will also hide desktop icons
# https://macos-defaults.com/finder/QuitMenuItem.html
defaults write com.apple.finder QuitMenuItem -bool true

# Show hidden files by default
# https://macos-defaults.com/finder/AppleShowAllFiles.html
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all file extensions in the Finder.
# https://macos-defaults.com/finder/AppleShowAllExtensions.html
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
# https://macos-defaults.com/finder/FXEnableExtensionChangeWarning.html
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Save to disk (not to iCloud) by default
# https://macos-defaults.com/finder/NSDocumentSaveNewDocumentsToCloud.html
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Remove the delay when hovering the toolbar title
# https://macos-defaults.com/finder/NSToolbarTitleViewRolloverDelay.html
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Set sidebar icon size to medium
# https://macos-defaults.com/finder/NSTableViewDefaultSizeMode.html
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
#defaults write com.apple.frameworks.diskimages skip-verify -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# More:
# - https://forums.macrumors.com/threads/disable-dmg-verification-in-el-capitan-gm.1915693/

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

## Increase grid spacing for icons on the desktop and in other icon views
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#
## Increase the size of icons on the desktop and in other icon views
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Expand/collapse following File Info panes
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	MetaData -bool true \
	OpenWith -bool true \
	Preview -bool false \
	Privileges -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
chflags nohidden ~/Library
xattr -d com.apple.FinderInfo  ~/Library
# To print flags:      ls -lO ~/
# To preview attr:     xattr -l ~/Library
# More: https://apple.stackexchange.com/a/378380

# Show the /Volumes folder
sudo chflags nohidden /Volumes

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Place Dock on the right
# https://macos-defaults.com/dock/orientation.html#set-to-right
# Default: "bottom", other values: "left", "right"
defaults write com.apple.dock orientation -string right

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding delay
defaults write com.apple.Dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
# https://macos-defaults.com/dock/autohide-time-modifier.html#set-to-0
defaults write com.apple.dock autohide-time-modifier -float 0

# Set the icon size of Dock items to 48 pixels
# https://macos-defaults.com/dock/tilesize.html#set-to-48-default-value
defaults write com.apple.dock tilesize -int 48

# Change minimize/maximize window effect
# Available options: "genie", "scale", "suck"
# https://macos-defaults.com/dock/mineffect.html#set-to-scale
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
# https://macos-defaults.com/misc/enable-spring-load-actions-on-all-items.html
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults rename com.apple.dock persistent-apps persistent-apps-backup
defaults write com.apple.dock persistent-apps -array
# TODO: make backups more sophisticated
#  - test is there were already some backup (to avoid overriding)
#  - implement adding number at the end (use recursion to increase numbers if backup exists)

# Show only open applications in the Dock
# This setting is similar to just clearing persistent-apps. Similar but different.
# It works in a way that if true, Dock always clear persistent-apps on launch.
defaults write com.apple.dock static-only -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Speed up Mission Control animations
# Warning: doesn't work on Sierra
# https://github.com/mathiasbynens/dotfiles/issues/711
defaults write com.apple.dock expose-animation-duration -float 0.1

# Show one application at a time
# https://www.defaults-write.com/show-one-application-at-a-time/
# Same behaviour can be achived by using:
# - command-alt click a dock item to switch while hiding others
# - command-alt-h to hide all other apps but the front facing one
#defaults write com.apple.dock single-app -bool true

### MISSION CONTROL

# Enable mission control
# https://www.defaults-write.com/mac-os-x-disable-mission-control-and-spaces/
defaults write com.apple.dock mcx-expose-disabled -bool false

# Don’t automatically rearrange Spaces based on most recent use
# https://macos-defaults.com/mission-control/mru-spaces.html
defaults write com.apple.dock mru-spaces -bool true

# When switching to an application, switch to a Space with open windows for the application
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool true

# Don't group windows by application
defaults write com.apple.dock expose-group-apps -bool false

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################


###############################################################################
# Mail                                                                        #
###############################################################################


###############################################################################
# Spotlight                                                                   #
###############################################################################


###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################


###############################################################################
# Time Machine                                                                #
###############################################################################

# Don't offer new disks for Time Machine backup
# https://macos-defaults.com/timemachine/DoNotOfferNewDisksForBackup.html#set-to-true
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disable

###############################################################################
# Activity Monitor                                                            #
###############################################################################


###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################


###############################################################################
# Software Updates / Mac App Store                                            #
###############################################################################

# Enable software updates
sudo softwareupdate --schedule on

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Don't allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool false
# TODO: check what is better, allow or disallow

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################


###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################


###############################################################################
# Spectacle.app                                                               #
###############################################################################


###############################################################################
# Other to consider                                                           #
###############################################################################

# Printer - Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable Game Center
defaults write com.apple.gamed Disabled -bool true

# Enable the MacBook Air SuperDrive on any Mac
#sudo nvram boot-args="mbasd=1"

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome" \
	"Messages" \
	"Photos" \
	"Safari" \
	"Spectacle" \
	"SystemUIServer" \
	"Terminal" \
	"iCal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
