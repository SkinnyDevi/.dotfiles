#!/usr/bin/env bash

pkill hypridle || hypridle &
kill -SIGRTMIN+10 "$(pgrep waybar)"
pid=$(pgrep hypridle)
if [[ -z "$pid" ]]; then
  notify-send -i $HOME/.config/swaync/icons/lock_icon.svg -a "Hypridle" "Hypridle" "Idling has paused."
else
  notify-send -i $HOME/.config/swaync/icons/lock_icon.svg -a "Hypridle" "Hypridle" "Idling has resumed."
fi
