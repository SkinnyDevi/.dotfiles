#!/bin/zsh

pids=($(pgrep -fa "linux-wallpaperengine"))

if [[ ${#pids[@]} -eq 0 ]]; then
  echo "Did not find WPE process to kill."
  $HOME/.dotfiles/linux-wpe/random-wp.sh
else
  $HOME/.dotfiles/linux-wpe/kill-wp.sh
fi
