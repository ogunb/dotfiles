export ZSH="/Users/ogun.babacan/.oh-my-zsh"

ZSH_THEME="cobalt2"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# ALIASES
# Git
alias gi="git init && gac 'Initial commit'"
alias gstat="git status"
alias ga="git add"
alias gcm="git commit -m"
alias gac="git add . && git commit -m"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gpo="git push origin"
alias glog="git log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"
alias gp="git push"
alias gs="git stash --include-untracked"
alias gsp="git stash pop"
alias gpublish="git push --set-upstream origin \"$(git rev-parse --abbrev-ref HEAD)\""

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias dl="~/Downloads"
alias repos="~/repos"

# Apps
alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Other
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'
alias reinstall="rm -rf node_modules && npm i"
