#!/bin/bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr_last_normal_ws"

# Save focused workspace of window
win_ws="$(hyprctl -j activewindow 2>/dev/null | jq -r '.workspace.name // empty')"

# If not in special workspace, send it
if [[ "$win_ws" != special* ]]; then
	curr_id="$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.id')"
	[[ -n "$curr_id" ]] && printf '%s\n' "$curr_id" >"$STATE_FILE"
	hyprctl dispatch movetoworkspacesilent special
	exit 0
fi

# Window is on special, move it back
target_ws="1"
if [[ -f "$STATE_FILE" ]]; then
	read -r target_ws <"$STATE_FILE"
fi

hyprctl dispatch movetoworkspace "$target_ws"

exit 0
