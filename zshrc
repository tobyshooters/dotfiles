# zshell config 
export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
ZSH_DISABLE_COMPFIX="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export VISUAL=nvim
export EDITOR="$VISUAL"

export PLAN9=/usr/local/plan9
export PATH=$PATH:$PLAN9/bin

export PG_OF_PATH=/home/cristobal/dev/of_v0.11.2

export PATH="$PATH:/home/cristobal/dev/MONO-REPO/dev-scripts"
export PATH="$PATH:/home/cristobal/.local/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/gs-venv/bin"
export PATH="$PATH:/usr/local/texlive/2024/bin/x86_64-linux"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

# General
alias ls="tree -L 1"
alias vi='nvim'
alias vim='nvim'
alias clear='printf "\033[H\033[2J"'
alias ack="ack -i -B 1 -A 2"
alias emacs="emacs -nw"
alias flake8="flake8 --extend-ignore E501"
alias cfmt="clang-format -i --style=Mozilla *.cpp *.h"
alias scrot="scrot ~/ideaspace/inbox/screenshot"

alias gs='git status -sb'
alias gb='git branch --sort=-committerdate'
alias gl='git log --all --graph --pretty=format:"%C(auto)%h %C(blue)%aN %C(magenta)%ad%C(auto)%d %Creset%s" --date=format:"%Y-%m-%d %H:%M"'
alias gll='git log --first-parent --pretty=format:"%C(auto)%h %C(magenta)%ad%C(auto)%d %C(blue)%aN %Creset%s" --date=format:"%Y-%m-%d %H:%M"'

function gcscp { 
    if [ -z "$1" ]; then
        echo "Google Cloud Storage Copy"
        echo "> gcscp (--dev) path dest"
        return 1
    elif [ "$1" = "--dev" ]; then
        echo "Downloading $2 to ${3:-.}"
        gsutil cp gs://reduct-dev-storage/$2 ${3:-.}
    else
        echo "Downloading $1 to ${2:-.}"
        gsutil cp gs://reduct-prod-storage/$1 ${2:-.}
    fi
}

function cd {
    builtin cd $@
    pwd > ~/.last_dir
}
if [ -f ~/.last_dir ]; then
    cd "`cat ~/.last_dir`"
fi

# OS-specific
if [[ "$(uname)" == "Darwin" ]]; then
    alias textedit="open -a TextEdit"
fi

if [[ "$(uname)" == "Linux" ]]; then
    alias pbcopy="xclip -selection clipboard"
    setxkbmap -option "compose:ralt"
fi


# Random-ass stuff that libraries inject into here:
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOOGLE_APPLICATION_CREDENTIALS=/home/cristobal/.reduct-secrets/cristobal-dev.json

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/cristobal/dev/MONO-REPO/google-cloud-sdk/path.zsh.inc' ]; then . '/home/cristobal/dev/MONO-REPO/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/cristobal/dev/MONO-REPO/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/cristobal/dev/MONO-REPO/google-cloud-sdk/completion.zsh.inc'; fi
. "/home/cristobal/.deno/env"
