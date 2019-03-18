source setupBase.sh loadFuncs

echo
echo "Setup Dev Langs..."

echo
echo "Setup Dev Langs... Installing Go"
mkdir -p ~/go/src
brew install go --force #guard against pre-installed version
brew install dep --force #guard against pre-installed version

echo
echo "Setup Dev Langs... Installing Python3"
brew install python3 --force #guard against pre-installed version

refreshBash
echo
echo "n is a node version manager, it's easy to change to a different node version, see: https://github.com/tj/n"
if [ $(n --version && true) ]; then
  greenColor
  echo "n is already installed!"
  resetColor
else
  echo
  echo "Setup Dev Langs... Installing Node LTS via n"
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
  echo "Setup Dev Langs... Installing SDK Man"
  curl -s "https://get.sdkman.io" | bash
  echo "sdkman_auto_answer=true" > ~/.sdkman/etc/config
  echo "sdkman_auto_selfupdate=true" >> ~/.sdkman/etc/config
  echo "sdkman_insecure_ssl=false" >> ~/.sdkman/etc/config
  sleep 5
  refreshBash
  source ~/.sdkman/bin/sdkman-init.sh || sdk version
fi
refreshBash

local sdkman_java_version=sdk list java | tr " " "\n" | grep -o "^11.*open" | head -1
echo "Setup Dev Langs... Installing java $sdkman_java_version"
sdk install java "$sdkman_java_version"

local sdkman_gradle_version=sdk list gradle | tr " " "\n" | grep -o "^5.2.*" | head -1
echo "Setup Dev Langs... Installing gradle $sdkman_gradle_version"
sdk install gradle "$sdkman_gradle_version"

local sdkman_springboot_version=sdk list springboot | tr " " "\n" | grep -o "^2.1.*" | head -1
echo "Setup Dev Langs... Installing SpringBoot $sdkman_springboot_version"
sdk install springboot "$sdkman_springboot_version"

greenColor
echo
echo "Setup Dev Langs... Done"
resetColor
