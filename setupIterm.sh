source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Iterm..."

set +e

echo "Setup Iterm... Installing"
brew cask reinstall iterm2 --force #guard against pre-installed version

echo "Setup Iterm... Configuring"
# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4
# Open the terminal color profile to allow it to be set as default manually
open "$LOCAL_SETUP_LABS_MAC_GIT_REPO/terminal-profiles/Peppermint.terminal"

# Set iTerm Preferences
cp "$LOCAL_SETUP_LABS_MAC_GIT_REPO/terminal-profiles/com.googlecode.iterm2.plist" ~/Library/Preferences

set -e

greenColor
echo 
echo "Setup Iterm... Done"
resetColor