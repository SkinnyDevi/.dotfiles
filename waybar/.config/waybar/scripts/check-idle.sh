#!/usr/bin/env bash

pid=$(pgrep hypridle)
kill -SIGRTMIN+10 "$(pgrep waybar)"
if [[ -z "$pid" ]]; then
  printf '{"text": "[☕]"}'
else
  printf '{"text": "[💤]"}'
fi
