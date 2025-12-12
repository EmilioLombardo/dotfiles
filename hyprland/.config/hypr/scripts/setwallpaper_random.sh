#!/bin/zsh

wallpapers=( # important to use $HOME instead of ~
    "$HOME/Pictures/Metroid/compressed_1080p/boss_room_2.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/experiment_2.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/experiment_3.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/experiment_staredown.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/kraid_staredown.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/purple_emmi_2.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/raiden_nix.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/red_emmi.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/red_emmi_spooky.jpg"
    "$HOME/Pictures/Metroid/compressed_1080p/save_room_cold.jpg"
)
# fallback_wallpaper="$HOME/Pictures/metroid_wallpapers/0_variasuit.jpg"

# random_numbers=$(shuf -i 1-${#wallpapers} -n 1)

random_numbers=(${(f)"$(shuf -i 1-${#wallpapers})"})

monitors=(${(f)"$(hyprctl monitors -j | jq -r '.[].name')"}) # get currently active displays
# monitors=("eDP-1" "HDMI-A-1") # hp-laptop: internal display and HDMI-connected display

n=$((${#monitors} + 1))
# Indexing the list past its last element gives an empty string for the monitor name.
# When hyprpaper gets an empty monitor name, it sets that wallpaper as a fallback.

# Loop through all active monitors, plus an empty monitor name
for i in {1..$n}; do
    i_mod_n=$(( ( ($i - 1) % $n ) + 1 ))
    monitor="${monitors[$i]}"
    rand="${(f)random_numbers[$i_mod_n]}"
    image_path="${wallpapers[$rand]}"

    # Get currently active image for this monitor
    old_image="$(hyprctl hyprpaper listactive | grep -Po "^${monitor}\s*=\s*\K.*")"
    if [ "$old_image" != "$image_path" ]; then # New image is to be loaded!
        hyprctl hyprpaper preload "$image_path"
        hyprctl hyprpaper wallpaper "$monitor,$image_path"
        hyprctl hyprpaper unload "$old_image" # unload old image
    fi
    # hyprctl hyprpaper preload "$image_path"
    # hyprctl hyprpaper wallpaper "$monitor,$image_path"
done

