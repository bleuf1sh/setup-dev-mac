echo "in here"
source setupBase.sh loadFuncs

echo
echo "Installing Cloud Foundry CLI..."

brew tap cloudfoundry/tap
brew install cf-cli --force #guard against pre-installed version

greenColor
echo 
echo "Cloud Foundry CLI Done!"
resetColor