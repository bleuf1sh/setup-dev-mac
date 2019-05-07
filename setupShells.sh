source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Shells..."

addTextIfKeywordNotExistToFile ~/.bash_profile "alias l='ls -al'" "alias l='ls -al'" 

echo
echo "Setup Shells... Installing Powerline shell for bash"
pip3 install powerline-shell
# Add Powerline Shell config
mkdir -p ~/.config/powerline-shell
cp -rf "$LOCAL_SETUP_DEV_MAC_GIT_REPO/powerline-shell/." ~/.config/powerline-shell

# Add Powerline Shell to bash profile
addTextIfKeywordNotExistToFile ~/.bash_profile 'powerline-shell' '
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
' 
refreshBash


echo
echo "Setup Shells... Installing Fish shell"
brew reinstall fish
refreshBash

echo "Setup Shells... Adding Fish to shells"
addTextIfKeywordNotExistToFile /etc/shells '/usr/local/bin/fish' '/usr/local/bin/fish'
refreshBash

echo "Setup Shells... Adding Fish configs"
mkdir -p ~/.config/fish
cp -rf "$LOCAL_SETUP_DEV_MAC_GIT_REPO/fish/." ~/.config/fish

echo "Setup Shells... Installing fisher for fish"
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
refreshBash

echo "Setup Shells... Installing bobthefish"
fish -c "fisher add oh-my-fish/theme-bobthefish"

echo "Setup Shells... Installing sdkman-for-fish"
fish -c "fisher add reitzig/sdkman-for-fish"

echo "Setup Shells... Updating fish completions"
fish -c "fish_update_completions"


greenColor
echo 
echo "Setup Shells... Done"
resetColor
