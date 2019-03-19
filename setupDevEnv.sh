source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Dev Env..."

echo
echo "Setup Dev Env... Installing Python3"
brew reinstall python3 --force #guard against pre-installed version

refreshBash
echo
echo "n is a node version manager, it's easy to change to a different node version, see: https://github.com/tj/n"
if [ $(n --version && true) ]; then
  greenColor
  echo "n is already installed!"
  resetColor
else
  echo
  echo "Setup Dev Env... Installing Node LTS via n"
  rm -rf ~/n || true #Remove any remnants
  curl -L https://git.io/n-install | bash -s -- -y lts
fi

refreshBash
echo
echo "SDK Man allow easy version management and installation of things like OpenJDK, Gradle, ..."
if [ -d ~/.sdkman ]; then
  greenColor
  echo "SDK Man is already installed!"
  resetColor
else
  echo
  echo "Setup Dev Env... Installing SDK Man"
  curl -s "https://get.sdkman.io" | bash
  echo "sdkman_auto_answer=true" > ~/.sdkman/etc/config
  echo "sdkman_auto_selfupdate=true" >> ~/.sdkman/etc/config
  echo "sdkman_insecure_ssl=false" >> ~/.sdkman/etc/config
  sleep 5
  refreshBash
fi
source ~/.sdkman/bin/sdkman-init.sh || sdk version
refreshBash

sdkman_java_version=$(sdk list java | tr " " "\n" | grep -o "^11.*open" | head -1)
echo "Setup Dev Env... Installing java $sdkman_java_version"
sdk install java "$sdkman_java_version"

sdkman_gradle_version=$(sdk list gradle | tr " " "\n" | grep -o "^5.2.*" | head -1)
echo "Setup Dev Env... Installing gradle $sdkman_gradle_version"
sdk install gradle "$sdkman_gradle_version"

sdkman_springboot_version=$(sdk list springboot | tr " " "\n" | grep -o "^2.1.*" | head -1)
echo "Setup Dev Env... Installing SpringBoot $sdkman_springboot_version"
sdk install springboot "$sdkman_springboot_version"

echo
echo "Setup Dev Env... Installing VS Code"
brew cask reinstall visual-studio-code 
addTextIfKeywordNotExistToFile ~/.bash_profile 'export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"' 'export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"'
refreshBash
echo "Setup Dev Env... Configuring VS Code"
code --install-extension Compulim.indent4to2
code --install-extension oderwat.indent-rainbow
code --install-extension ms-python.python
code --install-extension ms-vscode.go
code --install-extension peterjausovec.vscode-docker
code --install-extension k--kato.intellij-idea-keybindings
mkdir -p ~/"Library/Application Support/Code/User/"
cp -rf "$LOCAL_SETUP_LABS_MAC_GIT_REPO/vscode/." ~/"Library/Application Support/Code/User"
  
echo
echo "Setup Dev Env... Installing JetBrains toolbox"
brew cask reinstall jetbrains-toolbox --force #guard against pre-installed jetbrains-toolbox

echo
echo "Setup Dev Env... Installing IntelliJ"
brew cask reinstall intellij-idea --force #guard against pre-installed intellij
refreshBash
installPivotalIdePrefs intellij

echo
echo "Setup Dev Env... Installing WebStorm"
brew cask reinstall webstorm --force #guard against pre-installed webstorm
refreshBash
installPivotalIdePrefs webstorm

if didRequest "pycharm"; then
  echo
  echo "Setup Dev Env... Installing PyCharm (Python IDE)"
  brew cask reinstall pycharm --force #guard against pre-installed pycharm
  refreshBash
  installPivotalIdePrefs pycharm
fi

if didRequest "go"; then
  echo
  echo "Setup Dev Env... Installing Go"
  mkdir -p ~/go/src
  brew reinstall go --force #guard against pre-installed version
  brew reinstall dep --force #guard against pre-installed version
  echo
  echo "Setup Dev Env... Installing GoLand (Go IDE)"
  brew cask reinstall goland --force #guard against pre-installed goland
  refreshBash
  installPivotalIdePrefs goland
fi

greenColor
echo
echo "Setup Dev Env... Done"
resetColor
