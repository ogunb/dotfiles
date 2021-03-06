export ZSH="/Users/ogun.babacan/.oh-my-zsh"
export PATH=/opt/local/lib/postgresql90/bin/:$PATH

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

// wsl
dnsfix () { /mnt/c/Windows/system32/ipconfig.exe /all | grep --color=auto "DNS Servers" | cut -d ":" -f 2 | grep --color=auto -e '^ [0-9]' | sed 's/^/nameserver/' | sudo tee /etc/resolv.conf > /dev/null }

startwork () {
    reposDirectory='~/repos';
    workingDirectory=$1;
    startCommand=$2;

    cd $reposDirectory;
    cd $workingDirectory;

    eval $startCommand;
}

startapp () {
    startCommand='npm start';
    startwork 'micro-frontend-initializer' $startCommand
}

startroot () {
    startCommand='nvm use 13; npm run start:root';
    dnsfix;
    startwork 'micro-frontend-initializer' $startCommand
}

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
alias glog="git log --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"
alias gp="git push"
alias gs="git stash --include-untracked"
alias gsp="git stash pop"
alias gcer="git cherry-pick"
alias gfixcom="git commit --amend --no-edit"
alias gpublish="git push --set-upstream origin $(current_branch)"
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

# Other
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g;'
alias reinstall="sudo rm -rf node_modules && npm i"
