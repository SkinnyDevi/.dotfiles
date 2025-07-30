#!/bin/zsh

WALLPAPER_DIR="$HOME/animated_wallpapers/"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "Directory '$WALLPAPER_DIR' does not exist."
  echo "Creating directory at $WALLPAPER_DIR"
  mkdir $WALLPAPER_DIR
  exit 1
fi

wallpapers=(${WALLPAPER_DIR}/*(/))

if [[ ${#wallpapers[@]} -eq 0 ]]; then
  echo "No wallpapers added to display."
  exit 1
fi

random_dir=$wallpapers[$((RANDOM % ${#wallpapers[@]} + 1))]
wp_id=${random_dir:t}

linux-wallpaperengine --silent --scaling fill --screen-root DP-1 --screen-root DP-2 --fps 20 "${wp_id}"
