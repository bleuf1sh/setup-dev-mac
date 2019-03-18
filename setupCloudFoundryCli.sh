source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Cloud Foundry CLI..."

brew tap cloudfoundry/tap
brew install cf-cli --force #guard against pre-installed version

greenColor
echo 
echo "Setup Cloud Foundry CLI... Done"
resetColor