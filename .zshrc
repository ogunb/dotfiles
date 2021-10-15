export ZSH="/Users/ogun.babacan/.oh-my-zsh"

ZSH_THEME="cobalt2"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

function git_clean_local_branches {
  OPTION="-d";
  if [[ "$1" == "-f" ]]; then
    echo "WARNING! Removing with force";
    OPTION="-D";
  fi;

  TO_REMOVE_LINES=`git branch -r | awk "{print \\$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \\$1}" | wc -l`;

  if [ "$TO_REMOVE_LINES" -ne "0" ]; then
    TO_REMOVE=`git branch -r | awk "{print \\$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \\$1}"`;

    echo "Removing branches...";
    echo "";
    printf "\n$TO_REMOVE\n\n";
    echo "Proceed?";

    select result in Yes No; do
      if [[ "$result" == "Yes" ]]; then
        echo "Removing in progress...";
        echo "$TO_REMOVE" | xargs git branch "$OPTION";
        if [ $? -ne 0 ]; then
          echo ""
          echo "Some branches were not removed, you have to do it manually!";
        else
          echo "All branches removed!";
        fi
      fi

      break;
    done;
  else
    echo "You have nothing to clean";
  fi
}

showPort() {
    lsof -i tcp:$1
}

killPort() {
    lsof -i tcp:$1 | awk 'NR!=1 {print $2}' | xargs kill
}

startwork () {
    cd ~/repos/micro-frontend-initializer;
    bash start.sh;
}

startlahmacun () {
    cd ~/repos/lahmacun;
    npm run serve;
}

# ALIASES
# Git
alias gi="git init && gac 'Initial commit'"
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
alias gpublish="git push --set-upstream origin $(gcurrentbranch)"
alias gclean="git_clean_local_branches"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias dl="~/Downloads"
alias repos="~/repos"

# Apps
alias apps='open /Applications'
alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

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
