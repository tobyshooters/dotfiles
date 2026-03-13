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

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/dev/MONO-REPO/dev-scripts"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/gs-venv/bin"
export PATH="$PATH:$HOME/ideaspace/bin"
export PATH="$PATH:$HOME/dev/localhost"
export PATH="$PATH:$HOME/dev/shaderc/build/glslc"
export PATH="$PATH:/usr/local/texlive/2024/bin/x86_64-linux"
export PATH="$PATH:/usr/local/go/bin"

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
alias vim='/usr/local/bin/nvim'
alias clear='printf "\033[H\033[2J"'
alias ack="ack -i -B 1 -A 2"
alias emacs="emacs -nw"
alias flake8="flake8 --extend-ignore E501"
alias cfmt="clang-format -i --style=Mozilla *.cpp *.h"
alias scrot="scrot ~/ideaspace/inbox/screenshot"

# Git
alias ga='git add -p'
alias gc='git commit -m'
alias gs='git status -sb'
alias gb='git branch --sort=-committerdate'
alias gl='git log --all --graph --pretty=format:"%C(auto)%h %C(blue)%aN %C(magenta)%ad%C(auto)%d %Creset%s" --date=format:"%Y-%m-%d %H:%M"'
alias gll='git log --first-parent --pretty=format:"%C(auto)%h %C(magenta)%ad%C(auto)%d %C(blue)%aN %Creset%s" --date=format:"%Y-%m-%d %H:%M"'

# ZSH_THEME_GIT_PROMPT_PREFIX="%F{red}⎇  "
# ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
# ZSH_THEME_GIT_PROMPT_DIRTY=""
# ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%1~ %F{082}➜ %f '
PROMPT='%~ %F{082}➜ %f '

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

export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=reduct-dev
export DISABLE_PROMPT_CACHING=1

# Random-ass stuff that libraries inject into here:

# NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
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
# NB: zsh uses 1-indexed arrays. Beware!
CREDS=(
  "/home/cristobal/.reduct-secrets/cristobal-dev.json"
  "/home/cristobal/.config/gcloud/application_default_credentials.json"
)
export GOOGLE_APPLICATION_CREDENTIALS="${CREDS[1]}"

function gac() {
  echo "Using $GOOGLE_APPLICATION_CREDENTIALS"
  local i=0
  for cred in "${CREDS[@]}"; do
      echo "[$((i+1))] $cred"
    i=$((i+1))
  done
  
  echo -n "\nChoose credentials [n]: "
  read -r choice
  export GOOGLE_APPLICATION_CREDENTIALS="${CREDS[$choice]}"
  echo "Using $GOOGLE_APPLICATION_CREDENTIALS"
}

function preview() {
  if [ -z "$1" ]; then
    echo "Usage: preview [.md or .txt]"
    return 1
  fi

  local f=$(mktemp).md
  printf '%s\n'                                                   \
    '---'                                                         \
    'documentclass: article'                                      \
    'fontsize: 11pt'                                              \
    'papersize: a5'                                               \
    'header-includes: |'                                          \
    '  \usepackage{geometry}'                                     \
    '  \geometry{top=1.5cm, bottom=2cm, left=1.5cm, right=1.5cm}' \
    '  \usepackage{float}'                                        \
    '  \floatplacement{figure}{H}'                                \
    '---' > "$f"
  cat "$1" >> "$f"

  local output="$HOME/$(basename "${1%.*}").pdf"
  pandoc --pdf-engine=xelatex "$f" -o "$output"
  firefox "$output"

  rm "$f"
}

if [ -f '/home/cristobal/dev/deps/google-cloud-sdk/path.zsh.inc' ]; then \
    . '/home/cristobal/dev/deps/google-cloud-sdk/path.zsh.inc'; \
fi

if [ -f '/home/cristobal/dev/deps/google-cloud-sdk/completion.zsh.inc' ]; then \
    . '/home/cristobal/dev/deps/google-cloud-sdk/completion.zsh.inc'; \
fi

