source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Shells..."

echo
echo "Setup Shells... Installing Powerline shell for bash"
pip3 install powerline-shell
# Add Powerline Shell config
addLineIfNotExistToFile '
{
  "segments": [
    "virtual_env",
    "aws_profile",
    "ssh",
    "cwd",
    "git",
    "git_stash",
    "jobs",
    "set_term_title",
    "svn",
    "newline",
    "root"
  ],
  "mode": "flat",
  "cwd": {
    "mode": "plain",
    "max_depth": 5
  },
  "vcs": {
    "show_symbol": false
  }
  "theme": "gruvbox"
}
' ~/.config/powerline-shell/config.json

# Add Powerline Shell to bash profile
addLineIfNotExistToFile '
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
' ~/.bash_profile


echo
echo "Setup Shells... Installing Fish shell"
brew install fish
refreshBash

echo "Setup Shells... Adding Fish to shells"
addLineIfNotExistToFile '/usr/local/bin/fish' /etc/shells
refreshBash

echo "Setup Shells... Adding Fish configs"
mkdir -p ~/.config/fish
cp -r "$LOCAL_SETUP_LABS_MAC_GIT_REPO/fish/." ~/.config/fish

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