#!/usr/bin/env bash

# Applies system and application defaults.
# Inspirations:
# - https://github.com/bkuhlmann/mac_os-config/blob/main/bin/apply_default_settings
# - https://gist.github.com/Tristor/d3c699d16f6c1bbeec8f4c9d647a1f24
# - https://www.cultofmac.com/646404/secret-mac-settings/
# - https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# - https://gist.github.com/cmdoptesc/506a3017bc8acdf9787ddc2fcead0688

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

#TODO: unset ComputerName

###############################################################################
# General UI/UX                                                               #
###############################################################################

#############
### LOGIN ###
#############

# Restore the sound effects on boot
sudo nvram SystemAudioVolume="_"

# Revert "Reveal IP address, hostname, OS version, etc. when clicking login window clock"
sudo defaults delete /Library/Preferences/com.apple.loginwindow AdminHostInfo

# Revert "Disable window resume system-wide"
defaults delete NSGlobalDomain NSQuitAlwaysKeepsWindows

# Revert "isable relaunching apps"
defaults delete com.apple.loginwindow LoginwindowLaunchesRelaunchApps

###############
### WINDOWS ###
###############

# Revert "Always show scrollbars"
defaults delete NSGlobalDomain AppleShowScrollBars

# Revert "Disable smooth scrolling"
defaults delete NSGlobalDomain NSScrollAnimationEnabled

# Revert "Increase window resize speed for Cocoa applications"
defaults delete NSGlobalDomain NSWindowResizeTime -float 0.001

# Revert "Expand save panel by default"
defaults delete NSGlobalDomain NSNavPanelExpandedStateForSaveMode
defaults delete NSGlobalDomain NSNavPanelExpandedStateForSaveMode2

# Revert "Expand print panel by default"
defaults delete NSGlobalDomain PMPrintingExpandedStateForPrint
defaults delete NSGlobalDomain PMPrintingExpandedStateForPrint2

###################
### PERFORMANCE ###
###################

# Revert "Disable automatic termination of inactive apps"
defaults delete NSGlobalDomain NSDisableAutomaticTermination

################
### SECURITY ###
################

# Revert "Turn off the 'Application Downloaded from Internet' quarantine warning"
defaults delete com.apple.LaunchServices LSQuarantine

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# KEYBOARD

# Revert "Set a blazingly fast keyboard repeat rate"
defaults delete NSGlobalDomain KeyRepeat
defaults delete NSGlobalDomain InitialKeyRepeat

# Revert "Disable press-and-hold for keys in favor of key repeat"
defaults delete NSGlobalDomain ApplePressAndHoldEnabled

# Revert "Disable press-and-hold for keys in favor of key repeat"
defaults delete NSGlobalDomain com.apple.keyboard.fnState

# LANGUAGES

# Revert "Set language and text formats"
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_GB"
defaults delete NSGlobalDomain AppleMeasurementUnits
defaults delete NSGlobalDomain AppleMetricUnits

# Revert "Show language menu in the top right corner of the boot screen"
sudo defaults delete /Library/Preferences/com.apple.loginwindow showInputMenu

# Set the timezone
sudo systemsetup -settimezone "Europe/London"

###############################################################################
# Energy saving                                                               #
###############################################################################


###############################################################################
# Screen                                                                      #
###############################################################################


###############################################################################
# Finder                                                                      #
###############################################################################

# Revert "Allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults delete com.apple.finder QuitMenuItem

# Revert "Disable window animations and Get Info animations"
defaults delete com.apple.finder DisableAllAnimations

# Revert "Set Desktop as the default location for new Finder windows"
defaults delete com.apple.finder NewWindowTarget
defaults delete com.apple.finder NewWindowTargetPath
# Defaults from mac mini, on fresh BigSur on MBP there were no values
#defaults write com.apple.finder NewWindowTarget -string "PfAF"
#defaults write com.apple.finder NewWindowTargetPath -string "file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch"

# Show icons for servers, and removable media on the desktop, but not hard drives (default setting)
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults delete com.apple.finder ShowMountedServersOnDesktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Revert "Show hidden files by default"
defaults delete com.apple.finder AppleShowAllFiles -bool true

# Revert "Show all filename extensions"
defaults delete NSGlobalDomain AppleShowAllExtensions -bool true

# Revert "Show status bar"
defaults delete com.apple.finder ShowStatusBar

# Revert "Show path bar"
defaults delete com.apple.finder ShowPathbar

# Revert "Display full POSIX path as Finder window title"
defaults delete com.apple.finder _FXShowPosixPathInTitle

# Revert "Keep folders on top when sorting by name"
defaults delete com.apple.finder _FXSortFoldersFirst

# Revert "When performing a search, search the current folder by default"
defaults delete com.apple.finder FXDefaultSearchScope

# Revert "Disable the warning when changing a file extension"
defaults delete com.apple.finder FXEnableExtensionChangeWarning

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Revert "Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0.5

# Revert "Avoid creating .DS_Store files on network or USB volumes"
defaults delete com.apple.desktopservices DSDontWriteNetworkStores
defaults delete com.apple.desktopservices DSDontWriteUSBStores

# Revert "Disable disk image verification"
defaults delete com.apple.frameworks.diskimages skip-verify
defaults delete com.apple.frameworks.diskimages skip-verify-locked
defaults delete com.apple.frameworks.diskimages skip-verify-remote

# Revert "Automatically open a new Finder window when a volume is mounted"
defaults delete com.apple.frameworks.diskimages auto-open-ro-root
defaults delete com.apple.frameworks.diskimages auto-open-rw-root
defaults delete com.apple.finder OpenWindowForNewRemovableDisk

# Revert "Show item info near icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist

# Revert "Show item info to the right of the icons on the desktop"
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist

# Revert "Increase grid spacing for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist

# Revert "Increase the size of icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

# Revert "Use list view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Revert "Disable the warning before emptying the Trash"
defaults delete com.apple.finder WarnOnEmptyTrash

# Revert "Expand/collapse following File Info panes"
defaults delete com.apple.finder FXInfoPanesExpanded

# Revert "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults delete com.apple.NetworkBrowser BrowseAllInterfaces

# Revert "Show the ~/Library folder"
chflags hidden ~/Library
xattr -wx com.apple.FinderInfo "0000000000000000400000000000000000000000000000000000000000000000" ~/Library
# Revert "Show the /Volumes folder"
chflags hidden /Volumes

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Revert "Place Dock on the right"
defaults delete com.apple.dock orientation

# Revert "Automatically hide and show"
defaults delete com.apple.dock autohide

# Revert "Remove the auto-hiding delay"
defaults delete com.apple.dock autohide-delay

# Remove the animation when hiding/showing the Dock
defaults delete com.apple.dock autohide-time-modifier

# Revert "Set the icon size of Dock items to 48 pixels"
defaults delete com.apple.dock tilesize

# Revert "Change minimize/maximize window effect"
defaults delete com.apple.dock mineffect

# Revert "Minimize windows into their application’s icon"
defaults delete com.apple.dock minimize-to-application

# Revert "Enable spring loading for all Dock items"
defaults delete com.apple.dock enable-spring-load-actions-on-all-items

# Revert "Show indicator lights for open applications in the Dock"
defaults delete com.apple.dock show-process-indicators

# Revert "Wipe all (default) app icons from the Dock"
defaults delete com.apple.dock persistent-apps
defaults rename com.apple.dock persistent-apps-backup persistent-apps

# Revert "Show only open applications in the Dock"
defaults delete com.apple.dock static-only

# defaults "Don’t animate opening applications from the Dock"
defaults delete com.apple.dock launchanim

# Revert "Enable highlight hover effect for the grid view of a stack (Dock)"
defaults delete com.apple.dock mouse-over-hilite-stack

# Revert "Speed up Mission Control animations"
defaults delete com.apple.dock expose-animation-duration

# Revert "Show one application at a time"
defaults delete com.apple.dock single-app

### MISSION CONTROL

# Revert "Enable mission control"
defaults delete com.apple.dock mcx-expose-disabled

# Revert "Don’t automatically rearrange Spaces based on most recent use"
defaults delete com.apple.dock mru-spaces

# Revert "When switching to an application, switch to a Space with open windows for the application"
defaults delete NSGlobalDomain AppleSpacesSwitchOnActivate

# Revert "Don't group windows by application"
defaults delete com.apple.dock expose-group-apps

# Revert "Hot corners"
defaults delete com.apple.dock wvous-tl-corner
defaults delete com.apple.dock wvous-tl-modifier
defaults delete com.apple.dock wvous-tr-corner
defaults delete com.apple.dock wvous-tr-modifier
defaults delete com.apple.dock wvous-bl-corner
defaults delete com.apple.dock wvous-bl-modifier

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

# Revert "Don't offer new disks for Time Machine backup"
defaults delete com.apple.TimeMachine DoNotOfferNewDisksForBackup

# Revert "Disable local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil enable

###############################################################################
# Activity Monitor                                                            #
###############################################################################


###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################


###############################################################################
# Software Updates / Mac App Store                                            #
# #############################################################################

# Enable software updates
sudo softwareupdate --schedule on

# Revert "Enable the automatic update check"
defaults delete com.apple.SoftwareUpdate AutomaticCheckEnabled

# Revert "Check for software updates daily, not just once per week"
defaults delete com.apple.SoftwareUpdate ScheduleFrequency

# Revert "Download newly available updates in background"
defaults delete com.apple.SoftwareUpdate AutomaticDownload

# Revert "Install System data files & security updates"
defaults delete com.apple.SoftwareUpdate CriticalUpdateInstall

# Revert "Automatically download apps purchased on other Macs"
defaults delete com.apple.SoftwareUpdate ConfigDataInstall

# Revert "Turn on app auto-update"
defaults delete com.apple.commerce AutoUpdate

# Revert "Don't allow the App Store to reboot machine on macOS updates"
defaults delete com.apple.commerce AutoUpdateRestartRequired

# Revert "Enable the WebKit Developer Tools in the Mac App Store"
defaults delete com.apple.appstore WebKitDeveloperExtras

# Revert "Enable Debug Menu in the Mac App Store"
defaults delete com.apple.appstore ShowDebugMenu

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost delete com.apple.ImageCapture disableHotPlug

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

# Revert "Printer - Automatically quit printer app once the print jobs complete"
defaults delete com.apple.print.PrintingPrefs "Quit When Finished"

# Revert "Disable Game Center"
defaults delete com.apple.gamed Disabled

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
