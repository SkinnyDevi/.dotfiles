#!/bin/bash
CONFIG_DIR="$HOME/.config/hypr"
MODE="$1"

case "$MODE" in
"de" | "floating")
	ln -sf "$CONFIG_DIR/desktop-mode-conf/desktop.hyprland.conf" "$CONFIG_DIR/hyprland.conf"
	notify-send "Hyprland" "Switched to Desktop mode" -u normal -t 2000
	ACTION="setfloating"
	;;
"tiled" | "tiling")
	ln -sf "$CONFIG_DIR/dev-mode-conf/dev.hyprland.conf" "$CONFIG_DIR/hyprland.conf"
	notify-send "Hyprland" "Switched to Tiling mode" -u normal -t 2000
	ACTION="settiled"
	;;
*)
	notify-send "Hyprland" "Usage: hypr-mode.sh [de|tiled]" -u critical
	exit 1
	;;
esac

hyprctl reload
sleep 0.3 # tiny delay so Hyprland updates the client list

hyprctl clients -j | jq -r '.[] .address' | while read -r addr; do
	hyprctl dispatch "$ACTION" "address:$addr" >/dev/null 2>&1
done

exit 0
