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

function askForRequests() {
  resetColor
  echo "Write, in a single line, any of these additional IDE's available for install:"
  echo "    pycharm"
  echo "    goland"
  echo "for example: 'pycharm goland'"
  sleep 1
  greenColor
  read -p "Additionally Install: " REQUESTED_INSTALLS
  echo
  resetColor
}

# usage: didRequest pycharm
function didRequest() {
  local keyword=$1
  case "$REQUESTED_INSTALLS" in
    *$keyword*) echo "didRequest $1 TRUE"  && return 0;;
    *)    echo "didRequest $1 FALSE" && return 1;;
  esac
}

function refreshBash() {
  if [[ -e ~/.bash_profile ]]; then
    echo "sourcing ~/.bash_profile"
    source ~/.bash_profile
  fi
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
    sudo cp -rf "$mounted_volume"/*.app /Applications
  elif [ -e "$mounted_volume"/*.pkg ]; then
    package=$(ls -1 "$mounted_volume" | grep .pkg | head -1)
    sudo installer -pkg "$mounted_volume"/"$package" -target /
  fi
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
  
  sleep 1
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

function setupDone() {
  enableMacSecurity

  echo "Cleaning up your Brew installation..."
  brew cleanup

  greenColor
  printBleuf1sh
  
  echo
  echo "Sorry, there are a few manual steps:"
  echo
  echo "1) In Terminal -> Preferences -> Profiles -> Select Peppermint -> Click 'Default' button"
  echo
  echo "Done :D Please restart the computer to ensure all is well"
  echo
  printScriptDuration
  echo
  resetColor
  exit 0
}


if [ "$1" == "start" ]; then
  SCRIPT_START_TIME=$SECONDS

  # Fail fast if something goes wrong
  set -e
  trap onSigterm SIGKILL SIGTERM

  intro
  askForRequests

  printSpacer
  acquireSudo

  printSpacer
  installCommandLineUtils

  printSpacer
  installBrew

  printSpacer
  installGit

  printSpacer
  cloneSetupLabsMacGitRepo

  echo
  echo "Stage 2: Transitioning to $LOCAL_SETUP_LABS_MAC_GIT_REPO"
  cd "$LOCAL_SETUP_LABS_MAC_GIT_REPO"
  source setupCloudFoundryCli.sh
  


else
  echo "setupBase loaded"
fi