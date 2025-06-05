#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# [[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec Hyprland
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - venv)"

alias py="python"
alias venv="py -m venv"

alias ga="git add"
alias gcm="git commit -m "
alias gc="git commit"
alias gst="git status"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias gb="git branch"

alias waybar-reload="pkill waybar && hyprctl dispatch exec waybar"
