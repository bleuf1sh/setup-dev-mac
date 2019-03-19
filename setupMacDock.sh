source setupBase.sh loadFuncs

printSpacer
echo
echo "Setup Mac Dock..."

set +e

# Don't autohide the dock, people who are unfamiliar with Mac need something familiar
defaults write com.apple.dock autohide -bool false
# Set the icon size of Dock items to 50 pixels
defaults write com.apple.dock tilesize -int 50
# Minimize windows into their own icon (not application’s icon)
defaults write com.apple.dock minimize-to-application -bool false
# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool true
# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Mission Control
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → Nothing
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0
# modify appearance of dock: remove standard icons, add chrome and iTerm
curl https://raw.githubusercontent.com/kcrawford/dockutil/master/scripts/dockutil > /usr/local/bin/dockutil
chmod a+rx,go-w /usr/local/bin/dockutil
dockutil --list | awk -F\t '{print "dockutil --remove \""$1"\" --no-restart"}' | sh
# dockutil --add '/Applications/Self Service.app' --no-restart
dockutil --add '/Applications/System Preferences.app' --no-restart
dockutil --add '/Applications/Launchpad.app' --no-restart
# dockutil --add '/Applications/Go2Shell.app' --no-restart
dockutil --add '/Applications/Docker.app' --no-restart
dockutil --add '/Applications/Postman.app' --no-restart
dockutil --add '/Applications/Firefox.app' --no-restart
dockutil --add '/Applications/Slack.app' --no-restart
dockutil --add '/Applications/Google Chrome Canary.app' --no-restart
dockutil --add '/Applications/Google Chrome.app' --no-restart
dockutil --add '/Applications/Visual Studio Code.app' --no-restart
dockutil --add '/Applications/IntelliJ IDEA.app' --no-restart
if didRequest "intellij-ce"; then
  dockutil --add '/Applications/IntelliJ IDEA CE.app' --no-restart
fi
if didRequest "intellij-pro"; then
  dockutil --add '/Applications/IntelliJ IDEA.app' --no-restart
fi
if didRequest "pycharm-ce"; then
  dockutil --add '/Applications/PyCharm CE.app' --no-restart
fi
if didRequest "pycharm-pro"; then
  dockutil --add '/Applications/PyCharm.app' --no-restart
fi
if didRequest "webstorm"; then
  dockutil --add '/Applications/WebStorm.app' --no-restart
fi
if didRequest "goland-ide"; then
  dockutil --add '/Applications/GoLand.app' --no-restart
fi
dockutil --add '/Applications/iTerm.app' --no-restart
dockutil --add '~/Downloads' --view grid --display folder


set -e

greenColor
echo 
echo "Setup Mac Dock... Done"
resetColor