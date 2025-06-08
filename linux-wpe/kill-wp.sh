#!/bin/zsh

pids=($(pgrep -fa "linux-wallpaperengine"))

if [[ ${#pids[@]} -eq 0 ]]; then
  echo "Did not find WPE process to kill."
  exit 0
fi

for pid in $pids; do
  kill -9 $pid
done

echo "Killed all WPE processes."
