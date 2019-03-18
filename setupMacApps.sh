source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Mac Apps..."

set +e

# Misc
brew cask install the-unarchiver
brew cask install postman

echo "Setup Mac Apps... Installing Go2Shell"
brew cask install go2shell
open "/Applications/Go2Shell.app"

brew cask install flycut
echo "Setup Mac Apps... Opening Flycut for Manual Config"
open "/Applications/Flycut.app"

brew cask install shiftit
echo
echo "Setup Mac Apps... Configuring shiftit to select 1/3 screen width, 1/2 screen width and 2/3 screen width:"
echo "`defaults write org.shiftitapp.ShiftIt multipleActionsCycleWindowSizes YES`"
echo
echo "Setup Mac Apps... Opening ShiftIt for Manual Config"
open "/Applications/ShiftIt.app"


brew cask install slack --force #guard against pre-installed version
brew cask install docker --force #guard against pre-installed version

# Browsers
brew cask install firefox --force #guard against pre-installed version
brew cask install google-chrome --force #guard against pre-installed version
brew cask install google-chrome-canary --force #guard against pre-installed version
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