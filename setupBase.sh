#!/bin/bash
# License located at https://github.com/bleuf1sh/setup-dev-mac

LOCAL_SETUP_DEV_MAC_GIT_REPO=~/setup-dev-mac
AVAILABLE_TEMP_DIR=/tmp/setup-dev-mac_TEMP
mkdir -p "$AVAILABLE_TEMP_DIR"

END_OF_SCRIPT_OUTPUT_TXT_PATH="$AVAILABLE_TEMP_DIR/END_OF_SCRIPT_OUTPUT_TXT.txt"

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

function printSitBackWatchAndEnjoy() {
  echo
  echo
  echo "                      o"
  echo "             o       /"
  echo "              \     /"
  echo "               \   /"
  echo "                \ /"
  echo "  +--------------v-------------+"
  echo "  |  __________________      @ |"
  echo "  | /                  \       |"
  echo "  | |     Sit Back     |  (\)  |"
  echo "  | |   Relax & Watch  |       |"
  echo "  | |  as I tune this  |  (-)  |"
  echo "  | |       ~BOX~      |       |"
  echo "  | \                  / :|||: |"
  echo "  |  -ooo--------------  :|||: |"
  echo "  +----------------------------+"
  echo "     []                    []"
  echo
  echo
}

function printTheEndCredits() {
  echo
  echo
  echo "                      o"
  echo "             o       /"
  echo "              \     /"
  echo "               \   /"
  echo "                \ /"
  echo "  +--------------v-------------+"
  echo "  |  __________________      @ |"
  echo "  | /                  \       |"
  echo "  | |     ~the end~    |  (\)  |"
  echo "  | |                  |       |"
  echo "  | |      credits:    |  (-)  |"
  echo "  | |      bleuf1sh    |       |"
  echo "  | \                  / :|||: |"
  echo "  |  -ooo--------------  :|||: |"
  echo "  +----------------------------+"
  echo "     []                    []"
  echo
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
  if [[ -e ~/.bash_profile ]]; then
    echo "sourcing ~/.bash_profile"
    source ~/.bash_profile
  fi
}

# usage: resetEndOfScriptOutput
function resetEndOfScriptOutput() {
  echo "$(date)" > "$END_OF_SCRIPT_OUTPUT_TXT_PATH"
}

# usage: appendToEndOfScriptOutput 'XXX could not be installed.'
function appendToEndOfScriptOutput() {
  local text=$1
  echo "$text" >> "$END_OF_SCRIPT_OUTPUT_TXT_PATH"
}

# usage: openAppSleepThenQuit 'Calendar'
function openAppSleepThenQuit() {
  local app_name=$1
  echo "openAppSleepThenQuit: $app_name"
  sleep 3
  open -a "$app_name"
  sleep 5
  osascript -e "quit app \"$app_name\""
}

# usage: addTextIfKeywordNotExistToFile ~/path/to/file 'keyword' 'some string to append' 
function addTextIfKeywordNotExistToFile() {
  local file=$1
  local keyword=$2
  local line_to_add=$3

  if [ ! -e "$file" ]; then
    echo "Creating $file because did not exist"
    touch "$file"
  fi

  if grep -q "$keyword" "$file"; then
    echo "$keyword already exists in $file: $line_to_add"
  else
    echo "adding to $file: $line_to_add"
    ( echo "$line_to_add" | tee -a "$file" ) || \
    ( echo "$line_to_add" | sudo tee -a "$file" )
  fi
}
# usage: createDesktopShortcut() shortcut_name orig_path
function createDesktopShortcut() {
  # Allow non-blocking failures
  set +e
  local shortcut_name=$1
  local orig_path=$2
  echo "$orig_path"
  pushd ~/Desktop
  ln -s "$orig_path" "$shortcut_name"
  popd
  set -e
}

# usage: addToLaunchCtlEnv env_key env_value 
function addToLaunchCtlEnv() {
  # Allow non-blocking failures
  set +e
  local env_key=$1
  local env_value=$2

  local launchctl_tmp_dir=/tmp/com.bleuf1sh.setup_dev_mac.env
  mkdir -p "$launchctl_tmp_dir"

  local launch_agents_env_folder=~/Library/LaunchAgents
  mkdir -p "$launch_agents_env_folder"

  local plist_name="com.bleuf1sh.setup_dev_mac.env.$env_key"
  local env_full_file_name="$launch_agents_env_folder/$plist_name.plist"

  local launchctl_command="launchctl setenv $env_key \$$env_key"

  local plist_env_file="
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
  <key>Label</key>
  <string>$plist_name</string>
  
  <key>ProgramArguments</key>
  <array>
    <string>bash</string>
    <string>-c</string>
    <string>
    source ~/.bash_profile
    $launchctl_command
    find $launchctl_tmp_dir -type f -size +1M -delete
    echo \"\$(date): [$launchctl_command]... DONE\" >> $launchctl_tmp_dir/log.log
    </string>
  </array>
  
  <key>RunAtLoad</key>
  <true/>
  
  <key>StartInterval</key>
  <integer>10</integer>

  <key>StandardErrorPath</key>
  <string>$launchctl_tmp_dir/log.err</string>

  <key>StandardOutPath</key>
  <string>$launchctl_tmp_dir/log.out</string>
  
</dict>
</plist>
"
  echo "$plist_env_file" > "$env_full_file_name"

  command launchctl unload "$env_full_file_name"
  command launchctl load "$env_full_file_name"
  set -e
}

# usage: didRequest pycharm
function didRequest() {
  local keyword=$1
  case "$REQUESTED_ADDITIONAL_INSTALLS" in
    *$keyword*) echo "didRequest $1 TRUE"  && return 0;;
    *)    echo "didRequest $1 FALSE" && return 1;;
  esac
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

function startScriptTimer() {
  SCRIPT_START_TIME=$SECONDS
}

function appendScriptDurationToOutpu() {
  SCRIPT_ELAPSED_TIME=$(($SECONDS - $SCRIPT_START_TIME))
  appendToEndOfScriptOutput "we took $(($SCRIPT_ELAPSED_TIME/60)) min $(($SCRIPT_ELAPSED_TIME%60)) sec"
}

# usage: dl_file_path=$(downloadFile "https://www.websitewithstuff.com/git-v21231.dmg" "git-latest.dmg")
function downloadFile() {
  local url=$1
  local filename=$2
  local full_file_path="$AVAILABLE_TEMP_DIR/$filename"
  curl -C - -L "$url" --output "$full_file_path"
  echo "$full_file_path"
}

# usage: installDmg /Users/username/dev/setup-dev-mac/temp/git-latest.dmg
function installDmg() {
  local full_dmg_file_path=$1

  echo "installDmg..."
  echo "installDmg... $full_dmg_file_path"
  local mounted_volume=$(sudo hdiutil attach $full_dmg_file_path | grep "Volumes" | cut -f 3)
  set -x
  if [ -e "$mounted_volume"/*.app ]; then
    cp -R -f "$mounted_volume"/*.app /Applications
  elif [ -e "$mounted_volume"/*.pkg ]; then
    package=$(ls -1 "$mounted_volume" | grep .pkg | head -1)
    sudo installer -pkg "$mounted_volume/$package" -target /
  fi
  sleep 5
  sudo hdiutil detach "$mounted_volume"
  set +x
  echo "installDmg... Done"
}

# usage: installPivotalIdePrefs intellij
function installPivotalIdePrefs() {
  local ide=$1

  echo
  echo "Pivotal JetBrains IDE Preferences..."
  local full_path_pivotal_ide_prefs="$AVAILABLE_TEMP_DIR/pivotal_ide_prefs"
  if [ ! -d "$full_path_pivotal_ide_prefs" ]; then
    mkdir -p "$full_path_pivotal_ide_prefs"
    echo
    echo "Downloading Pivotal JetBrains IDE Preferences..."
    git clone https://github.com/pivotal/pivotal_ide_prefs.git "$full_path_pivotal_ide_prefs"
  else
    echo
    echo "Syncing Pivotal JetBrains IDE Preferences..."
    pushd "$full_path_pivotal_ide_prefs"
    git pull -r
    popd
  fi

  pushd "$full_path_pivotal_ide_prefs/cli"
  ./bin/ide_prefs install --ide=$ide
  popd
}

function cloneSetupDevMacGitRepo() {
  echo
  echo "Clone Setup Dev Mac Git Repo..."
  
  if [ ! -d "$LOCAL_SETUP_DEV_MAC_GIT_REPO" ]; then
    mkdir -p "$LOCAL_SETUP_DEV_MAC_GIT_REPO"
    echo
    echo "Downloading Setup Dev Mac Git Repo"
    git clone https://github.com/bleuf1sh/setup-dev-mac.git "$LOCAL_SETUP_DEV_MAC_GIT_REPO"
  else
    echo
    echo "Syncing Setup Dev Mac Git Repo..."
    pushd "$LOCAL_SETUP_DEV_MAC_GIT_REPO"
    git pull -r
    popd
  fi

  greenColor
  echo 
  echo "Clone Setup Dev Mac Git Repo... Done"
  resetColor
}

function intro() {
  greenColor

  printBleuf1sh

  resetColor
  echo "This script will guide you through the setup of your Dev Mac (:"
  
  greenColor
  echo
  read -p "----- PRESS ENTER KEY TO CONTINUE -----" throw_away
  echo

  sleep 1
  echo
  read -p "Do you consent to this script agreeing to licenses on your behalf? (y/N) " answer
  echo
  if [ $answer != "y" ]; then
    redColor
    echo "Sorry, I can't automate things for you if you don't agree to other peoples legal stuff ):"
    resetColor
    exit 1
  fi
  resetColor
}

function askForAdditionalRequests() {
  resetColor
  echo "Write, in a single line, any of these additional items available for install:"
  echo "  intellij_ce   - IntelliJ Community Edition (free Java IDE)"
  echo "  intellij_pro  - IntelliJ Professional Edition (paid Java IDE)"
  echo "  pycharm_ce    - PyCharm Community Edition (free Python IDE)"
  echo "  pycharm_pro   - PyCharm Professional Edition (paid Python IDE)"
  echo "  webstorm      - JavaScript IDE (paid)"
  echo "  golang        - Go language (free)"
  echo "  goland_ide    - GoLand (paid Go IDE)"
  echo
  sleep 1
  greenColor
  read -p "Additionally Install [intellij-ce pycharm-ce ... ]: " REQUESTED_ADDITIONAL_INSTALLS
  echo
  resetColor
}

function setupDone() {
  set +e
  enableMacSecurity

  echo "Cleaning up your Brew installation..."
  brew cleanup

  blueColor
  printTheEndCredits
  
  appendScriptDurationToOutput
  cat "$END_OF_SCRIPT_OUTPUT_TXT_PATH"

  greenColor
  echo
  echo "Sorry, there are a few manual steps:"
  echo
  echo "#) Setup ShiftIt"
  echo "   Follow on-screen app instructions"
  echo
  echo "#) Setup Go2Shell"
  echo "   In Finder -> click 'Go2ShellHelper.app' drag & hold CMD -> drop into Finder toolbar (to left of search bar)"
  echo
  echo "#) In Terminal -> Preferences -> Profiles -> Select Peppermint -> Click 'Default' button"
  echo
  echo "Done :D Please restart the computer to ensure all is well"
  echo
  echo
  resetColor
  exit 0
}

function acquireSudo() {
  echo "Let's cache sudo powers until we are done..."
  greenColor
  sudo -K
  blueColor
  sudo echo "Success!"
  resetColor
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
      greenColor
      echo
      read -p "----- PRESS ENTER KEY WHEN DONE INSTALLING -----" throw_away
      echo
      refreshBash
  else
      echo "Great! Seems like you have installed xCode Command Line Tools"
  fi

  greenColor
  echo "Attempting to accept on your behalf the xCodeBuild License"
  ! sudo xcodebuild -license accept
  
  resetColor
}

function installBrew() {
  echo "Installing Brew..."
  if [ $(which brew) ]; then
    echo "Installing Brew... Brew is already installed!"
  else
    yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    refreshBash
  fi

  echo
  echo "Installing Brew... Ensuring you have the latest Brew"
  brew update

  echo
  echo "Installing Brew... Ensuring your Brew directory is writable"
  sudo chown -Rf $(whoami) $(brew --prefix)/*

  echo
  echo "Installing Brew... Tapping cask and versions"
  brew tap homebrew/cask-cask
  brew tap homebrew/cask-versions

  echo
  echo "Installing Brew... Adding Brew's sbin to PATH"
  addTextIfKeywordNotExistToFile ~/.bash_profile 'export PATH="/usr/local/sbin:$PATH"' 'export PATH="/usr/local/sbin:$PATH"' 

  greenColor
  echo 
  echo "Installing Brew... Done"
  resetColor
}

function installGit() {
  echo
  echo "Installing Git..."
  brew reinstall git --force #guard against pre-installed version
  
  echo
  echo "Installing Git... Setting global Git configurations"
  # git config --global core.editor /usr/bin/nano #nano comes built in Mac
  git config --global core.editor /usr/bin/vim #from user testing vim seems more familiar
  git config --global transfer.fsckobjects true

  echo
  echo "Installing Git... Setting up Git aliases"
  git config --global alias.co checkout
  git config --global alias.ci commit
  git config --global alias.s status
  git config --global alias.st status
  
  addTextIfKeywordNotExistToFile ~/.bash_profile "alias s='git status'" "alias s='git status'" 
  addTextIfKeywordNotExistToFile ~/.bash_profile "alias gs='git status'" "alias gs='git status'"
  addTextIfKeywordNotExistToFile ~/.bash_profile "alias gst='git status'" "alias gst='git status'"
  
  addTextIfKeywordNotExistToFile ~/.bash_profile "alias ga='git add '" "alias ga='git add '" 
  
  addTextIfKeywordNotExistToFile ~/.bash_profile "alias co='git checkout '" "alias co='git checkout '" 
  addTextIfKeywordNotExistToFile ~/.bash_profile "alias gco='git checkout '" "alias gco='git checkout '" 

  greenColor
  echo 
  echo "Installing Git... Done"
  resetColor
}

if [ "$1" == "loadFuncs" ]; then
  echo "setupBase loaded"

elif [ "$1" == "start" ]; then
  SCRIPT_START_TIME=$SECONDS

  # Fail fast if something goes wrong
  set -e
  trap onSigterm SIGKILL SIGTERM

  intro && askForAdditionalRequests

  printSpacer && acquireSudo

  printSitBackWatchAndEnjoy && sleep 3

  printSpacer && installCommandLineUtils

  printSpacer && installBrew

  printSpacer && installGit

  printSpacer && cloneSetupDevMacGitRepo

  printSpacer
  printSpacer
  echo "Stage 2: Transitioning to $LOCAL_SETUP_DEV_MAC_GIT_REPO"
  cd "$LOCAL_SETUP_DEV_MAC_GIT_REPO"
  printSpacer
  printSpacer

  source setupCloudFoundryCli.sh
  source setupDevEnv.sh
  source setupShells.sh
  source setupIterm.sh
  source setupMacApps.sh
  source setupMacConfigs.sh
  source setupMacDock.sh

  setupDone
fi
