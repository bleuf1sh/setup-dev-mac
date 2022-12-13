source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Mac Apps..."

set +e

# Misc
brew reinstall --cask zoomus
brew reinstall --cask vlc
brew reinstall --cask sequel-pro
brew reinstall --cask flux
brew reinstall --cask the-unarchiver
brew reinstall --cask postman

echo "Setup Mac Apps... Installing Go2Shell"
brew reinstall --cask go2shell --force
open "/Applications/Go2Shell.app/Contents/MacOS/"

brew reinstall --cask flycut --force
echo "Setup Mac Apps... Removing Security Quarantine Flag"
sudo xattr -rd com.apple.quarantine "/Applications/Flycut.app"
echo "Setup Mac Apps... Opening Flycut for Manual Config"
open "/Applications/Flycut.app"

brew reinstall --cask shiftit --force
echo "Setup Mac Apps... Removing Security Quarantine Flag"
sudo xattr -rd com.apple.quarantine "/Applications/ShiftIt.app"
echo
echo "Setup Mac Apps... Configuring shiftit to select 1/3 screen width, 1/2 screen width and 2/3 screen width:"
echo "`defaults write org.shiftitapp.ShiftIt multipleActionsCycleWindowSizes YES`"
echo
echo "Setup Mac Apps... Opening ShiftIt for Manual Config"
open "/Applications/ShiftIt.app"


brew reinstall --cask slack --force #guard against pre-installed version
brew reinstall --cask docker --force #guard against pre-installed version

# Browsers
brew reinstall --cask firefox --force #guard against pre-installed version
brew reinstall --cask google-chrome --force #guard against pre-installed version
brew reinstall --cask google-chrome-canary --force #guard against pre-installed version
echo "Setup Mac Apps... Configuring Google Chrome and Canary"
# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

set -e

greenColor
echo 
echo "Setup Mac Apps... Done"
resetColor
