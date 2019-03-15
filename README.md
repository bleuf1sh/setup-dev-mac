# setup-labs-mac
## Simple one-liner auto magic setup for programming on a Mac in under 15min
copy/paste this line into terminal (bash) and run
```
curl -sL "https://raw.githubusercontent.com/bleuf1sh/setup-labs-mac/master/setupLabsMac.sh?$(date +%s)" > setupLabsMac.sh && bash setupLabsMac.sh#
```

## What makes this different than other auto magical setups out there
After using the others, it was difficult to switch to a different version of what was installed. For example, switching between different versions of node or switching from using OracleJDK to OpenJDK was extremely challenging.

Therefore, this scripts primary differentiator is it tries to use an already available version manager when installing different tools or languages to ease transitioning to a different version later, if desired.

It also configures and installs some additional things to make development easier.

### Dev langs + tooling
- OpenJDK 11.x [via sdk man](https://sdkman.io/)
- Gradle 5.2.x [via sdk man](https://sdkman.io/)
- SpringBoot 2.1.x [via sdk man](https://sdkman.io/)
- Node LTS [via n](https://github.com/tj/n)
- Python3

### IDE's
- VS Code
- IntelliJ w/ Pivotal IDE Prefs
- *PyCharm w/ Pivotal IDE Prefs
- *goland w/ Pivotal IDE Prefs

### CLI's
- Brew
- Git
- SDK Man
- Cloud Foundry

### Browsers
- Firefox
- Google Chrome
- Google Chrome Canary

### Misc
- iTerm2
- Slack
- Docker
- Postman
- Go2Shell
- FlyCut
- ShiftIt
- The Unarchiver

### Notes
- all hidden files are made visible in Finder
- ability to open a terminal from Finder
- default Mac dock is scrubbed of all distractions
- custom Peppermint color in terminals for better readability


*indicates optional

</br>

## Inspired by
- https://github.com/pivotal/workstation-setup
- https://github.com/ghaiklor/iterm-fish-fisher-osx
</br></br></br></br></br></br>



```
# MIT License

# Copyright (c) 2019 Aaron

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
```