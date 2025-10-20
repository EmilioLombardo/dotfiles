#!/bin/bash

direction="$1"
temp_ws=99

# Get current workspace ID
current_ws=$(hyprctl activeworkspace -j | jq .id)

# Decide next workspace
if [[ "$direction" == "right" ]]; then
    target_ws=$((current_ws + 1))
elif [[ "$direction" == "left" ]]; then
    target_ws=$((current_ws - 1))
else
    echo "Usage: $0 [left|right]"
    exit 1
fi

# Prevent negative workspace IDs
if [[ "$target_ws" -lt 1 ]]; then
    echo "Already at the lowest workspace."
    exit 1
fi

# Move current workspace windows to temp
for win in $(hyprctl clients -j | jq -r ".[] | select(.workspace.id==$current_ws) | .address"); do
    hyprctl dispatch movetoworkspace $temp_ws,address:$win
done

# Move target workspace windows to current
for win in $(hyprctl clients -j | jq -r ".[] | select(.workspace.id==$target_ws) | .address"); do
    hyprctl dispatch movetoworkspace $current_ws,address:$win
done

# Move temp workspace windows to target
for win in $(hyprctl clients -j | jq -r ".[] | select(.workspace.id==$temp_ws) | .address"); do
    hyprctl dispatch movetoworkspace $target_ws,address:$win
done

# Focus the target workspace
hyprctl dispatch workspace $target_ws


