# zshell config 
export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
ZSH_DISABLE_COMPFIX="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export VISUAL=vim
export EDITOR="$VISUAL"

export PLAN9=/usr/local/plan9
export PATH=$PATH:$PLAN9/bin

export PG_OF_PATH=/home/cristobal/dev/of_v0.11.2

export PATH="$PATH:/home/cristobal/dev/MONO-REPO/dev-scripts"
export PATH="$PATH:/home/cristobal/.local/bin"

alias ls="tree -L 1"
alias clear='printf "\033[H\033[2J"'

alias emacs="emacs -nw"
alias textedit="open -a TextEdit"

alias ack="ack -i -B 1 -A 2"
alias cfmt="clang-format -i --style=Mozilla *.cpp *.h"

alias gs='git status -sb'
alias gb='git branch --sort=-committerdate'
alias gl='git log --all --graph --pretty=format:"%C(auto)%h %C(blue)%aN %C(magenta)%ad%C(auto)%d %Creset%s" --date=format:"%Y-%m-%d %H:%M"'
alias gll='git log --first-parent --pretty=format:"%C(auto)%h %C(magenta)%ad%C(auto)%d %C(blue)%aN %Creset%s" --date=format:"%Y-%m-%d %H:%M"'

function cd {
    builtin cd $@
    pwd > ~/.last_dir
}
if [ -f ~/.last_dir ]; then
    cd "`cat ~/.last_dir`"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOOGLE_APPLICATION_CREDENTIALS=/home/cristobal/.reduct-secrets/cristobal-dev.json

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/cristobal/dev/MONO-REPO/google-cloud-sdk/path.zsh.inc' ]; then . '/home/cristobal/dev/MONO-REPO/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/cristobal/dev/MONO-REPO/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/cristobal/dev/MONO-REPO/google-cloud-sdk/completion.zsh.inc'; fi
