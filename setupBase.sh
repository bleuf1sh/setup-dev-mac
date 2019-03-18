#!/bin/bash
# License located at https://github.com/bleuf1sh/setup-labs-mac

LOCAL_SETUP_LABS_MAC_GIT_REPO=~/setup-labs-mac
AVAILABLE_TEMP_DIR=~/setup-labs-mac-temp
mkdir -p $AVAILABLE_TEMP_DIR

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
  if [[ -e ~/.bash_profile ]]; then
    echo "sourcing ~/.bash_profile"
    source ~/.bash_profile
  fi
}

# usage: addTextIfKeywordNotExistToFile ~/path/to/file 'keyword' 'some string to append' 
function addTextIfKeywordNotExistToFile() {
  local file=$1
  local keyword=$2
  local line_to_add=$3

  if [ ! -e $file ]; then
    echo "Creating $file because did not exist"
    touch $file
  fi

  if grep -q "$keyword" $file; then
    echo "$keyword already exists in $file: $line_to_add"
  else
    echo "adding to $file: $line_to_add"
    echo "$line_to_add" | sudo tee -a $file
  fi
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

function printScriptDuration() {
  SCRIPT_ELAPSED_TIME=$(($SECONDS - $SCRIPT_START_TIME))
  echo "we took $(($SCRIPT_ELAPSED_TIME/60)) min $(($SCRIPT_ELAPSED_TIME%60)) sec"
}

# usage: dl_file_path=$(downloadFile "https://www.websitewithstuff.com/git-v21231.dmg" "git-latest.dmg")
function downloadFile() {
  local url=$1
  local filename=$2
  local full_file_path=$AVAILABLE_TEMP_DIR/$filename
  curl -C - -L $url --output $full_file_path
  echo "$full_file_path"
}

# usage: installDmg /Users/username/dev/setup-labs-mac/temp/git-latest.dmg
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
    sudo installer -pkg "$mounted_volume"/"$package" -target /
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

function cloneSetupLabsMacGitRepo() {
  echo
  echo "Clone Setup Labs Mac Git Repo..."
  
  if [ ! -d "$LOCAL_SETUP_LABS_MAC_GIT_REPO" ]; then
    mkdir -p "$LOCAL_SETUP_LABS_MAC_GIT_REPO"
    echo
    echo "Downloading Setup Labs Mac Git Repo"
    git clone https://github.com/bleuf1sh/setup-labs-mac.git "$LOCAL_SETUP_LABS_MAC_GIT_REPO"
  else
    echo
    echo "Syncing Setup Labs Mac Git Repo..."
    pushd "$LOCAL_SETUP_LABS_MAC_GIT_REPO"
    git pull -r
    popd
  fi

  greenColor
  echo 
  echo "Clone Setup Labs Mac Git Repo... Done"
  resetColor
}

function intro() {
  greenColor

  printBleuf1sh

  resetColor
  echo "This script will guide you through the setup of your Labs Mac (:"
  
  greenColor
  echo
  read -p "----- PRESS ANY KEY TO CONTINUE -----" throw_away
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
  echo "    pycharm - Python IDE"
  echo "    go - this will also install goland (a 'go' IDE)"
  echo
  sleep 1
  greenColor
  read -p "Additionally Install [pycharm go]: " REQUESTED_ADDITIONAL_INSTALLS
  echo
  resetColor
}

function setupDone() {
  enableMacSecurity

  echo "Cleaning up your Brew installation..."
  brew cleanup
  brew doctor

  greenColor
  printBleuf1sh
  
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
  printScriptDuration
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
  brew tap caskroom/cask
  brew tap caskroom/versions

  # echo
  # echo "Installing Brew... Upgrading any existing brews"
  # brew upgrade

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
  git config --global core.editor /usr/bin/nano #nano comes built in Mac
  git config --global transfer.fsckobjects true

  echo
  echo "Installing Git... Setting up Git aliases"
  git config --global alias.s git status

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

  printSpacer && installCommandLineUtils

  printSpacer && installBrew

  printSpacer && installGit

  printSpacer && cloneSetupLabsMacGitRepo

  printSpacer
  printSpacer
  echo "Stage 2: Transitioning to $LOCAL_SETUP_LABS_MAC_GIT_REPO"
  cd "$LOCAL_SETUP_LABS_MAC_GIT_REPO"
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