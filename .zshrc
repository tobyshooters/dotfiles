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
alias ack="ack -i -B 1 -A 2"
alias cfmt="clang-format -i --style=Microsoft *.cpp *.h"

alias gl='git log --all --graph --pretty=format:"%C(auto)%h %C(blue)%aN %C(magenta)%ad%C(auto)%d %Creset%s" --date=format:"%Y-%m-%d %H:%M"'
alias gll='git log --first-parent --pretty=format:"%C(auto)%h %C(magenta)%ad%C(auto)%d %C(blue)%aN %Creset%s" --date=format:"%Y-%m-%d %H:%M"'

function cd {
    builtin cd $@
    pwd > ~/.last_dir
}
if [ -f ~/.last_dir ]; then
    cd "`cat ~/.last_dir`"
fi

export PG_OF_PATH=/home/cristobal/dev/of_v0.11.2
