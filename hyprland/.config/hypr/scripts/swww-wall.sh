#!/bin/zsh

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
TRANSITION_TYPE="wipe"
TRANSITION_ANGLE=135
FPS=144
STEP=60

# If no argument → pick random
if [ $# -eq 0 ]; then
  img=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
else
  img="$1"
fi

rm $HOME/.current_wallpaper
ln -s "$img" $HOME/.current_wallpaper

wal -i "$img"

swww img "$img" \
  -t "$TRANSITION_TYPE" \
  --transition-angle "$TRANSITION_ANGLE" \
  --transition-step "$STEP" \
  --transition-fps "$FPS" \
  --transition-duration 2 \
  --invert-y # sometimes helps on multi-monitor
  # --resize stretch \
