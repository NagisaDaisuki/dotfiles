#!/usr/bin/env bash

state=$(swaync-client -D)

if [[ "$state" == "true" ]]; then
  exit 0
fi

play -v 0.5 /home/Nagisa/.config/swaync/sound/normal.oga
