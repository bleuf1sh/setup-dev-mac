source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Shells..."

echo
echo "Setup Shells... Installing Fish shell"
brew install fish
refreshBash

echo "Setup Shells... Adding Fish to shells"
addLineIfNotExistToFile '/usr/local/bin/fish' /etc/shells
refreshBash

echo "Setup Shells... Adding Fish configs"
mkdir -p ~/.config/fish
cp "$LOCAL_SETUP_LABS_MAC_GIT_REPO/fish/*" ~/.config/fish

echo "Setup Shells... Installing fisher for fish"
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
refreshBash

echo "Setup Shells... Installing bobthefish"
fish -c "fisher add oh-my-fish/theme-bobthefish"

echo "Setup Shells... Installing sdkman-for-fish"
fish -c "fisher add reitzig/sdkman-for-fish"


greenColor
echo 
echo "Setup Shells... Done"
resetColor