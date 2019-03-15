#!/bin/bash
# License located at the bottom of this file.

# Fail fast if something goes wrong
set -e
trap onSigterm SIGKILL SIGTERM

MY_BASE_DIR="$(pwd)"
TEMP_DIR="$MY_BASE_DIR/temp"

function printBleuf1sh() {
  echo
  echo '               __   __'
  echo '              __ \ / __'
  echo '             /  \ | /  \'
  echo '                 \|/'
  echo '            _,.---v---._'
  echo '   /\__/\  /            \'
  echo '   \_  _/ /              \'
  echo '     \ \_|           @ __|'
  echo '  hjw \                \_'
  echo '  `97  \     ,__/       /'
  echo '    ~~~~`~~~~~~~~~~~~~~/~~~~~'
  echo '            bleuf1sh        '
  echo 
}

function resetColor() {
  echo -e "\033[0m\c"
}

function redColor() {
  echo -e "\033[0;31m\c"
}

function greenColor() {
  echo -e "\033[0;32m\c"
}

function blueColor() {
  echo -e "\033[0;34m\c"
}

function printSpacer() {
  blueColor
  echo "#==========================================================#"
  resetColor
  sleep 1
}

function refreshBash() {
  source ~/.bash_profile
}

function enableMacSecurity() {
  defaults write com.apple.LaunchServices LSQuarantine -bool true
  killall Finder
}

function disableMacSecurity() {
  defaults write com.apple.LaunchServices LSQuarantine -bool false
  killall Finder
}

function onSigterm() {
  enableMacSecurity
  redColor
  echo
  echo -e "Oops... something erred ):"
  resetColor
  exit 1
}

function setupDone() {
  enableMacSecurity

  echo "Cleaning up your Brew installation..."
  brew cleanup

  greenColor
  printBleuf1sh
  echo
  # echo "Do not forgot to make two simple, but manual things:"
  # echo
  # echo "1) Open iTerm -> Preferences -> Profiles -> Colors -> Presets and apply color preset"
  # echo "2) Open iTerm -> Preferences -> Profiles -> Text -> Font and apply font (for non-ASCII as well)"
  echo
  echo "Done :D Please restart the computer to ensure all is well"
  echo
  resetColor
  exit 0
}

# usage: dl_file_path=$(downloadFile "https://www.websitewithstuff.com/git-v21231.dmg" "git-latest.dmg")
function downloadFile() {
  local url=$1
  local filename=$2
  local full_file_path=$TEMP_DIR/$filename
  curl -C - -L $url --output $full_file_path
  echo "$full_file_path"
}

# usage: installDmg /Users/username/dev/setup-labs-mac/temp/git-latest.dmg
function installDmg() {
  local full_dmg_file_path=$1
  local mounted_volume=$(sudo hdiutil attach $full_dmg_file_path | grep "Volumes" | cut -f 3)
  set -x
  if [ -e "$mounted_volume"/*.app ]; then
    sudo cp -rf "$mounted_volume"/*.app /Applications
  elif [ -e "$mounted_volume"/*.pkg ]; then
    package=$(ls -1 "$mounted_volume" | grep .pkg | head -1)
    sudo installer -pkg "$mounted_volume"/"$package" -target /
  fi
  sudo hdiutil detach "$mounted_volume"
  set +x
}

# usage: installPivotalIdePrefs intellij
function installPivotalIdePrefs() {
  local ide=$1

  local full_path_pivotal_ide_prefs="$TEMP_DIR/pivotal_ide_prefs"

  if [ ! -d "$full_path_pivotal_ide_prefs" ]; then
  mkdir -p "$full_path_pivotal_ide_prefs"
    echo
    echo "Downloading Pivotal JetBrains IDE preferences"
    git clone https://github.com/pivotal/pivotal_ide_prefs.git "$full_path_pivotal_ide_prefs"
  fi

  pushd "$full_path_pivotal_ide_prefs/cli"
  ./bin/ide_prefs install --ide=$ide
  popd
}

function intro() {
  greenColor

  printBleuf1sh

  echo "This script will guide you through the setup of your Labs Mac (:"
  
  resetColor
  echo
  read -p "Do you want to proceed with the setup? (y/N) " -n 1 answer
  echo
  if [ $answer != "y" ]; then
    exit 1
  fi

  echo
  read -p "Do you consent to this script agreeing to some licenses on your behalf? (y/N) " -n 1 answer
  echo
  if [ $answer != "y" ]; then
    redColor
    echo "Sorry, I can't automate things for you if you don't agree to other peoples legal stuff ):"
    resetColor
    exit 1
  fi
}

function acquireSudo() {
  echo "Let's cache sudo powers until we are done..."
  sudo -K
  sudo echo "Success: sudo powers cached"
  disableMacSecurity
  # Keep-alive: update existing `sudo` time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

function installCommandLineUtils() {
  echo "Trying to detect installed xCode Command Line Tools..."

  if ! [ $(xcode-select -p) ]; then
      echo "You don't have Command Line Tools installed"
      echo "They are required to proceed with installation"
      echo
      echo "Installing Command Line Tools..."
      echo "Please, wait until Command Line Tools will be installed, before continue"

      xcode-select --install
      refreshBash
  else
      echo "Great! Seems like you have installed xCode Command Line Tools"
  fi

  greenColor
  echo "Accepting on your behalf the xCodeBuild License"
  sudo xcodebuild -license accept
  
  resetColor
}

function installBrew() {
  if [ $(which brew) ]; then
    echo "Brew is already installed!"
  else
    echo "Installing Brew..."
    yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    refreshBash
  fi

  echo
  echo "Ensuring you have the latest Brew..."
  brew update

  echo
  echo "Ensuring your Brew directory is writable..."
  sudo chown -Rf $(whoami) $(brew --prefix)/*

  echo
  echo "Installing Brew cask..."
  brew tap caskroom/cask
  brew tap caskroom/versions

  echo
  echo "Upgrading any existing brews..."
  brew upgrade

  echo
  echo "Adding Brew's sbin to your PATH..."
  echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.bash_profile

  greenColor
  echo 
  echo "Brew Done!"
  resetColor
}

function installGit() {
  echo
  echo "Installing Git..."
  brew install git --force #guard against pre-installed version
  
  echo
  echo "Setting global Git configurations..."
  git config --global core.editor /usr/bin/nano #nano comes built in Mac
  git config --global transfer.fsckobjects true

  echo
  echo "Setting up Git aliases..."
  git config --global alias.s git status

  greenColor
  echo 
  echo "Git Done!"
  resetColor
}

function installCloudFoundryCli() {
  echo
  echo "Installing Cloud Foundry CLI..."
  brew tap cloudfoundry/tap
  brew install cf-cli --force #guard against pre-installed version

  greenColor
  echo 
  echo "Cloud Foundry CLI Done!"
  resetColor
}

function installDevLanguagesAndIDEs() {
  echo
  echo "Installing Dev Languages and IDEs..."

  echo
  echo "Installing Go..."
  mkdir -p ~/go/src
  brew install go --force #guard against pre-installed version
  brew install dep --force #guard against pre-installed version

  echo
  echo "Installing Python3..."
  brew install python3 --force #guard against pre-installed version

  refreshBash
  echo
  echo "n is a node version manager, it's easy to change to a different node version, see: https://github.com/tj/n"
  if [ $(n --version && true) ]; then
    echo "n is already installed!"
  else
    echo
    echo "Installing Node LTS via n..."
    curl -L https://git.io/n-install | bash -s -- -y lts
  fi
  
  refreshBash
  echo
  echo "SDK Man allow easy version management and installation of things like OpenJDK, Gradle, ..."
  ls -al "~"
  if [ -d "~/.sdkman" ]; then
    echo "sdkman is already installed!"
  else
    echo
    echo "Installing SDK Man..."
    curl -s "https://get.sdkman.io" | bash
    echo "sdkman_auto_answer=true" > ~/.sdkman/etc/config
    echo "sdkman_auto_selfupdate=true" >> ~/.sdkman/etc/config
    echo "sdkman_insecure_ssl=false" >> ~/.sdkman/etc/config
    sleep 5
    refreshBash
    source "~/.sdkman/bin/sdkman-init.sh" || sdk version
  fi
  refreshBash

  local sdkman_java_version=sdk list java | tr " " "\n" | grep -o "^11.*open" | head -1
  sdk install "$sdkman_java_version"

  local sdkman_gradle_version=sdk list gradle | tr " " "\n" | grep -o "^5.2.*" | head -1
  sdk install "$sdkman_gradle_version"

  local sdkman_springboot_version=sdk list springboot | tr " " "\n" | grep -o "^2.1.*" | head -1
  sdk install "$sdkman_springboot_version"


  echo 'Installing IntelliJ Suite...'
  brew cask install jetbrains-toolbox --force #guard against pre-installed jetbrains-toolbox

  brew cask install intellij-idea --force #guard against pre-installed intellij
  installPivotalIdePrefs intellij

  brew cask install pycharm --force #guard against pre-installed pycharm
  installPivotalIdePrefs pycharm

  brew cask install goland --force #guard against pre-installed goland
  installPivotalIdePrefs goland

  greenColor
  echo 
  echo "Dev Languages And IDEs Done!"
  resetColor
}

function installIterm() {
  echo
  echo "Installing Iterm..."
  set +e

  brew cask install iterm2 --force #guard against pre-installed version

  redColor
  echo "Configuring..."
  # Only use UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4

  local term_profiles_base_url="https://raw.githubusercontent.com/bleuf1sh/setup-labs-mac/master/terminal-profiles"
  # Set Terminal Colors
  local term_colors_dl_file_path=$(downloadFile "$term_profiles_base_url/Peppermint.terminal" "Peppermint.terminal")
  open "$term_colors_dl_file_path"
  # Set iTerm Preferences
  local iterm_prefs_dl_file_path=$(downloadFile "$term_profiles_base_url/com.googlecode.iterm2.plist" "com.googlecode.iterm2.plist")
  cp "$iterm_prefs_dl_file_path" ~/Library/Preferences
  # It isn't needed to set the iTerm color because the color is embedded into the prefs above
  # # Set iTerm Colors
  # local iterm_colors_dl_file_path=$(downloadFile "$term_profiles_base_url/custom-pepperment.itermcolors" "custom-pepperment.itermcolors")
  # open "$iterm_colors_dl_file_path"

  set -e
  
  greenColor
  echo 
  echo "Iterm Done!"
  resetColor
}

function installVsCode() {
  echo
  echo "Installing VS Code..."
  set +e

  brew cask install visual-studio-code 
  echo 'export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"' >> ~/.bash_profile
  
  set -e
  
  greenColor
  echo 
  echo "VS Code Done!"
  resetColor
}

function installMacApps() {
  echo "-"
  echo "All these applications are independent, so if one fails to install, we won't stop!"
  echo "-"
  set +e

  echo
  echo "Installing Common Mac Apps..."

  # Utilities
  brew cask install the-unarchiver
  brew cask install postman

  local go2shell_dmg_dl_file_path=$(downloadFile "https://zipzapmac.com/download/Go2Shell" "Go2Shell.dmg")
  installDmg go2shell_dmg_dl_file_path
  open "/Applications/Go2Shell.app" 
  
  brew cask install flycut
  echo "Configuring Flycut..."
  open "/Applications/Flycut.app"
  
  brew cask install shiftit
  echo
  echo "Configuring shiftit to select 1/3 screen width, 1/2 screen width and 2/3 screen width:"
  echo "`defaults write org.shiftitapp.ShiftIt multipleActionsCycleWindowSizes YES`"
  echo
  open "/Applications/ShiftIt.app"

  # Browsers
  brew cask install firefox --force #guard against pre-installed version
  brew cask install google-chrome --force #guard against pre-installed version
  brew cask install google-chrome-canary --force #guard against pre-installed version
  echo "Configuring Google Chrome and Canary..."
  # Disable the all too sensitive backswipe on trackpads
  defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
  defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
  # Disable the all too sensitive backswipe on Magic Mouse
  defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
  defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

  # Misc
  brew cask install slack --force #guard against pre-installed version
  brew cask install docker --force #guard against pre-installed version

  set -e

  greenColor
  echo 
  echo "Common Mac Apps Done!"
  resetColor
}

function installMacConfigs() {
  # Inspired from: https://github.com/kevinSuttle/macOS-Defaults/blob/master/.macos
  echo
  echo 'Installing Mac configuration'

  # Reveal IP address, hostname, OS version, etc. when clicking the clock
  # in the login window
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

  # set menu clock
  # see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
  defaults write com.apple.menuextra.clock "DateFormat" 'EEE MMM d  h:mm:ss a'
  killall SystemUIServer

  # Show all processes in Activity Monitor
  defaults write com.apple.ActivityMonitor ShowCategory -int 0

  ###############################################################################
  # Standby and Screen Saver
  ###############################################################################
  echo "Configuring Standby and Screen Saver..."
  # Set standby delay to 24 hours (default is 1 hour)
  sudo pmset -a standbydelay 86400
  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  ###############################################################################
  # Keyboard
  ###############################################################################
  echo "Configuring Keyboard..."
  # fast key repeat rate, requires reboot to take effect
  defaults write ~/Library/Preferences/.GlobalPreferences KeyRepeat -int 1
  defaults write ~/Library/Preferences/.GlobalPreferences InitialKeyRepeat -int 15
  # Disable automatic capitalization as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  # Disable smart dashes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  # Disable automatic period substitution as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  # Disable smart quotes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

  ###############################################################################
  # Mouse
  ###############################################################################
  echo "Configuring Mouse..."
  # Trackpad: enable tap to click for this user and for the login screen
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  ###############################################################################
  # Finder and Files
  ###############################################################################
  echo "Configuring Finder and Files..."
  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  # set finder to display full path in title bar
  # Set User Home as the default location for new Finder windows
  # For other paths, use `PfLo` and `file:///full/path/here/`
  defaults write com.apple.finder NewWindowTarget -string "PfDe"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
  # Show icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  # Show all hidden files
  defaults write com.apple.finder AppleShowAllFiles -bool true
  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true
  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true
  # Display full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  # Use list view in all Finder windows by default
  # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  killall Finder
  # Enable AirDrop over Ethernet and on unsupported Macs running Lion
  defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
  # Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  # stop Photos from opening automatically
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
  #to revert use defaults -currentHost delete com.apple.ImageCapture disableHotPlug


  ###############################################################################
  # Safari
  ###############################################################################
  echo "Configuring Safari..."
  # Prevent Safari from opening ‘safe’ files automatically after downloading
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
  # Privacy: don’t send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true
  # Show the full URL in the address bar (note: this still hides the scheme)
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
  # Enable the Develop menu and the Web Inspector in Safari
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
  # Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
}

function remodelMacDock() {
  # Inspired from: https://github.com/kevinSuttle/macOS-Defaults/blob/master/.macos
  echo
  echo 'ReModeling Mac Dock...'

  # Don't autohide the dock, people who are unfamiliar with Mac need something familiar
  defaults write com.apple.dock autohide -bool false
  # Set the icon size of Dock items to 50 pixels
  defaults write com.apple.dock tilesize -int 50
  # Minimize windows into their own icon (not application’s icon)
  defaults write com.apple.dock minimize-to-application -bool false
  # Enable spring loading for all Dock items
  defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
  # Show indicator lights for open applications in the Dock
  defaults write com.apple.dock show-process-indicators -bool true
  # Animate opening applications from the Dock
  defaults write com.apple.dock launchanim -bool true
  # Don’t automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false
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
  defaults write com.apple.dock wvous-tl-corner -int 0
  defaults write com.apple.dock wvous-tl-modifier -int 0
  # Top right screen corner → Desktop
  defaults write com.apple.dock wvous-tr-corner -int 4
  defaults write com.apple.dock wvous-tr-modifier -int 0
  # Bottom left screen corner → Mission Control
  defaults write com.apple.dock wvous-bl-corner -int 2
  defaults write com.apple.dock wvous-bl-modifier -int 0
  # Bottom right screen corner → Nothing
  defaults write com.apple.dock wvous-br-corner -int 0
  defaults write com.apple.dock wvous-br-modifier -int 0
  # modify appearance of dock: remove standard icons, add chrome and iTerm
  curl https://raw.githubusercontent.com/kcrawford/dockutil/master/scripts/dockutil > /usr/local/bin/dockutil
  chmod a+rx,go-w /usr/local/bin/dockutil
  dockutil --list | awk -F\t '{print "dockutil --remove \""$1"\" --no-restart"}' | sh
  # dockutil --add '/Applications/Self Service.app' --no-restart
  dockutil --add '/Applications/System Preferences.app' --no-restart
  dockutil --add '/Applications/Launchpad.app' --no-restart
  dockutil --add '/Applications/Docker.app' --no-restart
  dockutil --add '/Applications/Postman.app' --no-restart
  dockutil --add '/Applications/Firefox.app' --no-restart
  dockutil --add '/Applications/Slack.app' --no-restart
  dockutil --add '/Applications/Google Chrome Canary.app' --no-restart
  dockutil --add '/Applications/Google Chrome.app' --no-restart
  dockutil --add '/Applications/Visual Studio Code.app' --no-restart
  dockutil --add '/Applications/IntelliJ IDEA.app' --no-restart
  dockutil --add '/Applications/iTerm.app' --no-restart
  dockutil --add 'Downloads'
}



#
# Here we go!
#
intro

printSpacer
acquireSudo

mkdir -p $TEMP_DIR

printSpacer
installCommandLineUtils

printSpacer
installBrew

printSpacer
installGit

printSpacer
installCloudFoundryCli

printSpacer
installDevLanguagesAndIDEs

printSpacer
installIterm

printSpacer
installVsCode

printSpacer
installMacApps

printSpacer
installMacConfigs

printSpacer
remodelMacDock

printSpacer
setupDone






# MIT License

# Copyright (c) 2019 Aaron

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
