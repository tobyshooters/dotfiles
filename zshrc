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
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/gs-venv/bin"
export PATH="$PATH:/usr/local/texlive/2024/bin/x86_64-linux"
export PATH="$PATH:$HOME/ideaspace/bin"
export PATH="$PATH:$HOME/dev/localhost"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Load in API key
if [[ -f ~/dotfiles/anthropic ]]; then
  export ANTHROPIC_API_KEY=$(cat ~/dotfiles/anthropic | tr -d '\n')
fi

# General
alias tree="tree -I 'node_modules'"
alias ls="tree -L 1"
alias vi='nvim'
alias vim='nvim'
alias clear='printf "\033[H\033[2J"'
alias ack="ack -i -B 1 -A 2"
alias emacs="emacs -nw"
alias flake8="flake8 --extend-ignore E501"
alias cfmt="clang-format -i --style=Mozilla *.cpp *.h"
alias scrot="scrot ~/ideaspace/inbox/screenshot"

# Git
alias gs='git status -sb'
alias gb='git branch --sort=-committerdate'
alias gl='git log --all --graph --pretty=format:"%C(auto)%h %C(blue)%aN %C(magenta)%ad%C(auto)%d %Creset%s" --date=format:"%Y-%m-%d %H:%M"'
alias gll='git log --first-parent --pretty=format:"%C(auto)%h %C(magenta)%ad%C(auto)%d %C(blue)%aN %Creset%s" --date=format:"%Y-%m-%d %H:%M"'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{red}⎇  "
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

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

# Random-ass stuff that libraries inject into here:

# NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use 22.11.0

# deno
. "/home/cristobal/.deno/env"

# pnpm
export PNPM_HOME="/home/cristobal/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# GCP
export GOOGLE_APPLICATION_CREDENTIALS=/home/cristobal/.reduct-secrets/cristobal-dev.json
# export GOOGLE_APPLICATION_CREDENTIALS=/home/cristobal/.config/gcloud/application_default_credentials.json

if [ -f '/home/cristobal/dev/google-cloud-sdk/path.zsh.inc' ]; then \
    . '/home/cristobal/dev/google-cloud-sdk/path.zsh.inc'; \
fi

if [ -f '/home/cristobal/dev/google-cloud-sdk/completion.zsh.inc' ]; then \
    . '/home/cristobal/dev/google-cloud-sdk/completion.zsh.inc'; \
fi

