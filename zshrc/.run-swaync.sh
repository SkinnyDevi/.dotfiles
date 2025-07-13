#!/bin/bash

XDG_CONFIG_HOME="$HOME/.config/swaync-no-gtk"
exec swaync -c "$HOME/.config/swaync/config.json" -s "$HOME/.config/swaync/style.css"
