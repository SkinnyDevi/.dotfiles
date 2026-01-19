######################
# .zshrc - oh-my-zsh #
######################

# if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] [ "$XDG_CURRENT_DESKTOP" != "GNOME" ]; then
#   exec Hyprland
# fi

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  Hyprland
fi


# if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty2" ]; then
#  XDG_CURRENT_DESKTOP=x11 GDK_BACKEND=x11 startx
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="fletcherm"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share/"

export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
export __GL_SHADER_DISK_CACHE_SIZE=100000000000 #100 gb max disk size of cache

if [[ "$XDG_RUNTIME_DIR" ]]; then
  WAYLAND_SOCKET=$(ls $XDG_RUNTIME_DIR | grep '^wayland-[0-9]\+$')

  if [[ "$WAYLAND_SOCKET" ]]; then
    export WAYLAND_DISPLAY="$WAYLAND_SOCKET"
  else
    echo "No valid Wayland socket found in $XDG_RUNTIME_DIR"
  fi
else
  echo "XDG_RUNTIME_DIR is not set."
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - venv)"

# Frequent commands
alias ls="ls --color=auto -latr"
alias py="python"
alias venv="py -m venv"
alias mkdir="mkdir -p"
alias open="xdg-open"

# Git aliases
alias ga="git add"
alias gcm="git commit -m "
alias gc="git commit"
alias gst="git status"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --decorate --oneline --graph"

# Utilities
alias wezterm="WAYLAND_DISPLAY=1 wezterm"
alias waybar-reload="pkill waybar && hyprctl dispatch exec waybar"
alias hyprshell-reload="pkill hyprshell && hyprctl dispatch exec hyprshell run"
alias lwp="linux-wallpaperengine --silent --scaling fill"
alias lwph="linux-wallpaperengine --help"
alias space-explorer="ncdu / --exclude /mnt/TERROBYTE/"
alias davincimp4="$HOME/.mp4-davinci-helper.sh"
alias winboot="$HOME/.winboot.sh"
alias shutdown="sudo systemctl poweroff -f"
alias reboot="sudo systemctl reboot"
alias logout="hyprctl dispatch exit"

alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'

fastfetch
