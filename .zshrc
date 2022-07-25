export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="spaceship"

source $ZSH/oh-my-zsh.sh

plugins=(git)

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=/${PATH}:/Library/PostgreSQL/14/bin

function git_clean_local_branches {
  OPTION="-d"
  if [[ "$1" == "-f" ]]; then
    echo "WARNING! Removing with force"
    OPTION="-D"
  fi

  TO_REMOVE_LINES=$(git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | wc -l)

  if [ "$TO_REMOVE_LINES" -ne "0" ]; then
    TO_REMOVE=$(git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}")

    echo "Removing branches..."
    echo ""
    printf "\n$TO_REMOVE\n\n"
    echo "Proceed?"

    select result in Yes No; do
      if [[ "$result" == "Yes" ]]; then
        echo "Removing in progress..."
        echo "$TO_REMOVE" | xargs git branch "$OPTION"
        if [ $? -ne 0 ]; then
          echo ""
          echo "Some branches were not removed, you have to do it manually!"
        else
          echo "All branches removed!"
        fi
      fi

      break
    done
  else
    echo "You have nothing to clean"
  fi
}

showPort() {
  lsof -i tcp:$1
}

killPort() {
  showPort | awk 'NR!=1 {print $2}' | xargs kill
}

startwork() {
  cd ~/repos/micro-frontend-initializer
  bash start.sh $1
}

startmeal() {
  startwork meal
  code ./seller-meal-web
}

startgrocery() {
  startwork grocery
  code ./seller-center-grocery
}

startlahmacun() {
  cd ~/repos/lahmacun
  code .
  npm run serve
}

# ALIASES
# Git
alias gi="git init && gac 'initial commit'"
alias gstat="git status"
alias ga="git add"
alias gcm="git commit -m"
alias gac="git add . && git commit -m"
alias gaz="git add . && git cz"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gpo="git push origin"
alias glog="git log --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"
alias gp="git push"
alias gs="git stash --include-untracked"
alias gsp="git stash pop"
alias gcer="git cherry-pick"
alias gfixcom="git commit --amend --no-edit"
alias gcurrentbranch="git branch | sed -n -e 's/^\* \(.*\)/\1/p'"
alias gclean="git_clean_local_branches"

gpub() {
  git push --set-upstream origin $(gcurrentbranch)
}

grepo() {
  repo_url=$(echo $(git config --get remote.origin.url) | sed "s/:/\//g" | sed 's/git@/https:\/\//g')
  echo $repo_url
  open -a "Google Chrome" $repo_url
}

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias dl="~/Downloads"
alias repos="~/repos"

# Apps
alias apps='open /Applications'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Python
alias python="python3"
alias pip="/usr/bin/pip3"

# Other
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g;'
alias reinstall="rm -rf node_modules && npm i"
eval $(thefuck --alias)

SPACESHIP_DOCKER_SHOW=false
export PATH="/usr/local/opt/openjdk@8/bin:$PATH"

# bun completions
[ -s "/Users/ogun.babacan/.bun/_bun" ] && source "/Users/ogun.babacan/.bun/_bun"

# bun
export BUN_INSTALL="/Users/ogun.babacan/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
