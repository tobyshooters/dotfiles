# zshell config
export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git)

ZSH_DISABLE_COMPFIX="true"

export VISUAL=vim
export EDITOR="$VISUAL"

source $ZSH/oh-my-zsh.sh

alias ls="tree -L 1"
alias emacs="emacs -nw"
alias textedit="open -a TextEdit"

alias gl='git log --all --graph --pretty=format:"%C(auto)%h %C(blue)%aN %C(magenta)%ad%C(auto)%d %Creset%s" --date=format:"%Y-%m-%d %H:%M"'
