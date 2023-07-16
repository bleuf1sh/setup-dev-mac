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
if [ $(node --version && true) ]; then
  blueColor
  message="node is already installed, sorry! skipping n install for node version management."
  echo "$message"
  appendToEndOfScriptOutput "$message"
  resetColor
elif [ $(n --version && true) ]; then
  greenColor
  message="n node version management is already installed."
  echo "$message"
  appendToEndOfScriptOutput "$message"
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

sdkman_java_version=$(sdk list java | tr ' ' '\n' | sort -r | grep -o '^11.0.*zulu.*' | head -1)
echo "Setup Dev Env... Installing java $sdkman_java_version"
sdk install java "$sdkman_java_version"

source ~/.sdkman/bin/sdkman-init.sh || sdk version
refreshBash
# addToLaunchCtlEnv "JDK_HOME" "$JAVA_HOME"
# addToLaunchCtlEnv "JAVA_HOME" "$JAVA_HOME"
sdkman_parent_dir=$(dirname $JAVA_HOME)
createDesktopShortcut "SDKMAN JAVA_HOME's" "$sdkman_parent_dir"

sdkman_gradle_version=$(sdk list gradle | tr ' ' '\n' | sort -r | grep -o '^5.2.*' | head -1)
echo "Setup Dev Env... Installing gradle $sdkman_gradle_version"
sdk install gradle "$sdkman_gradle_version"

source ~/.sdkman/bin/sdkman-init.sh || sdk version
refreshBash
# addToLaunchCtlEnv "GRADLE_HOME" "$GRADLE_HOME"
sdkman_parent_dir=$(dirname $GRADLE_HOME)
createDesktopShortcut "SDKMAN GRADLE_HOME's" "$sdkman_parent_dir"

echo
echo "Setup Dev Env... Installing VS Code"
brew reinstall --cask visual-studio-code 
addTextIfKeywordNotExistToFile ~/.bash_profile 'export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"' 'export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"'
refreshBash
set +e
echo "Setup Dev Env... Configuring VS Code"
code --install-extension Compulim.indent4to2
code --install-extension oderwat.indent-rainbow
code --install-extension ms-python.python
code --install-extension ms-vscode.go
code --install-extension ms-azuretools.vscode-docker
code --install-extension k--kato.intellij-idea-keybindings
set -e
mkdir -p ~/"Library/Application Support/Code/User/"
cp -rf "$LOCAL_SETUP_DEV_MAC_GIT_REPO/vscode/." ~/"Library/Application Support/Code/User"
  
echo
echo "Setup Dev Env... Installing JetBrains toolbox"
brew reinstall --cask jetbrains-toolbox --force #guard against pre-installed jetbrains-toolbox


  echo
  echo "Setup Dev Env... Installing IntelliJ Community Edition"
  brew reinstall --cask intellij-idea-ce --force #guard against pre-installed intellij-idea-ce
  refreshBash
  #necessary to force the app to create a prefs file to allow our prefs injection
  openAppSleepThenQuit 'IntelliJ IDEA CE'
  installPivotalIdePrefs intellijcommunity


if didRequest "intellij_pro"; then
  echo
  echo "Setup Dev Env... Installing IntelliJ Professional"
  brew reinstall --cask intellij-idea --force #guard against pre-installed intellij-idea
  refreshBash
  #necessary to force the app to create a prefs file to allow our prefs injection
  openAppSleepThenQuit 'IntelliJ IDEA'
  installPivotalIdePrefs intellij
fi


  echo
  echo "Setup Dev Env... Installing PyCharm Community Edition (free Python IDE)"
  brew reinstall --cask pycharm-ce --force #guard against pre-installed pycharm-ce
  refreshBash
  #necessary to force the app to create a prefs file to allow our prefs injection
  openAppSleepThenQuit 'PyCharm CE'
  installPivotalIdePrefs pycharm


if didRequest "pycharm_pro"; then
  echo
  echo "Setup Dev Env... Installing PyCharm Professional (paid Python IDE)"
  brew reinstall --cask pycharm --force #guard against pre-installed pycharm
  refreshBash
  #necessary to force the app to create a prefs file to allow our prefs injection
  openAppSleepThenQuit 'PyCharm'
  installPivotalIdePrefs pycharm
fi

if didRequest "webstorm"; then
  echo
  echo "Setup Dev Env... Installing WebStorm (paid JavaScript IDE)"
  brew reinstall --cask webstorm --force #guard against pre-installed webstorm
  refreshBash
  #necessary to force the app to create a prefs file to allow our prefs injection
  openAppSleepThenQuit 'WebStorm'
  installPivotalIdePrefs webstorm
fi

if didRequest "golang"; then
  echo
  echo "Setup Dev Env... Installing Go"
  mkdir -p ~/go/src
  brew reinstall go --force #guard against pre-installed version
  brew reinstall dep --force #guard against pre-installed version
fi

if didRequest "goland_ide"; then
  echo
  echo "Setup Dev Env... Installing GoLand (paid Go IDE)"
  brew reinstall --cask goland --force #guard against pre-installed goland
  refreshBash
  #necessary to force the app to create a prefs file to allow our prefs injection
  openAppSleepThenQuit 'GoLand'
  installPivotalIdePrefs goland
fi

greenColor
echo
echo "Setup Dev Env... Done"
resetColor
