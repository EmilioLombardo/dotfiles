#!/bin/bash

# Hyprland event socket path
SOCKET="/run/user/1000/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock"

# Hook to run on workspace change
hook="$HOME/.config/hypr/scripts/setwallpaper.sh"

# Connect to the socket and filter for workspace events
socat - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    if [[ "$line" == "workspace>>"* ]]; then
        "$hook" #"$line"
    fi
done
