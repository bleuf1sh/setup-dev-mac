source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Dev IDEs..."

echo
echo "Setup Dev IDEs... Installing VS Code"
brew cask install visual-studio-code 
addLineIfNotExistToFile 'export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"' ~/.bash_profile
  
echo
echo "Setup Dev IDEs... Installing JetBrains toolbox"
brew cask install jetbrains-toolbox --force #guard against pre-installed jetbrains-toolbox

echo
echo "Setup Dev IDEs... Installing IntelliJ"
brew cask install intellij-idea --force #guard against pre-installed intellij
installPivotalIdePrefs intellij

if didRequest "pycharm"; then
  echo
  echo "Setup Dev IDEs... Installing PyCharm"
  brew cask install pycharm --force #guard against pre-installed pycharm
  installPivotalIdePrefs pycharm
fi

if didRequest "goland"; then
  echo
  echo "Setup Dev IDEs... Installing GoLand"
  brew cask install goland --force #guard against pre-installed goland
  installPivotalIdePrefs goland
fi

greenColor
echo
echo "Setup Dev IDEs... Done"
resetColor
