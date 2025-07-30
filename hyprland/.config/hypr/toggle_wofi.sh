#!/bin/bash
if pgrep -x "wofi" >/dev/null; then
  killall wofi
else
  wofi --insensitive --show drun --normal-window
fi
