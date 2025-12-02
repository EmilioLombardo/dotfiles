#!/bin/zsh

current_workspace="$(hyprctl activeworkspace -j | jq .id)"
current_monitor="$(hyprctl monitors -j | jq -r '.[] | select(.focused).name')"
# echo $current_workspace
# echo $current_monitor

# wallpapers=( # important to use $HOME instead of ~
#     "$HOME/Pictures/metroid_wallpapers/1_zeromission.jpg"
#     "$HOME/Pictures/metroid_wallpapers/2_samusreturns.jpg"
#     "$HOME/Pictures/metroid_wallpapers/3_supermetroid.jpg"
#     "$HOME/Pictures/metroid_wallpapers/4_fusion.jpg"
#     "$HOME/Pictures/metroid_wallpapers/5_otherm.jpg"
#     "$HOME/Pictures/metroid_wallpapers/6_dread.jpg"
#     "$HOME/Pictures/metroid_wallpapers/0_zerosuit.jpg"
# )

wallpapers=( # important to use $HOME instead of ~
    "/home/emilio/Pictures/Metroid/compressed_1080p/boss room 2.jpg"
    "$HOME/Pictures/metroid_wallpapers/2_samusreturns.jpg"
    "$HOME/Pictures/metroid_wallpapers/3_supermetroid.jpg"
    "$HOME/Pictures/metroid_wallpapers/4_fusion.jpg"
    "$HOME/Pictures/metroid_wallpapers/5_otherm.jpg"
    "$HOME/Pictures/metroid_wallpapers/6_dread.jpg"
    "$HOME/Pictures/metroid_wallpapers/0_zerosuit.jpg"
)

fallback_wallpaper="$HOME/Pictures/metroid_wallpapers/0_variasuit.jpg"
# Loop through all monitors
for monitor in ${(f)"$(hyprctl monitors -j | jq -r '.[].name')"}; do
    ws_id="$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$monitor\") | .activeWorkspace.id")"

    if [ "$ws_id" -le "${#wallpapers}" ]; then
        image_path="${wallpapers[$ws_id]}"
    else
        image_path="$fallback_wallpaper"
    fi

    # Get current image for this monitor
    current_image="$(hyprctl hyprpaper listactive | grep -Po "^${monitor}\s*=\s*\K.*")"

    if [ "$current_image" != "$image_path" ]; then
        hyprctl hyprpaper preload "$image_path"
        hyprctl hyprpaper wallpaper "$monitor,$image_path"
        # hyprctl hyprpaper unload "$image_path"
    fi
done




# if [ $current_workspace -le $#wallpapers ]; then
#     image_path=$wallpapers[$current_workspace]
# else
#     image_path=$fallback_wallpaper
# fi
#
# active_image="$(hyprctl hyprpaper listactive | grep -Po "^${current_monitor}\s*=\s*\K.*")"
# echo $active_image
#
# if [ $active_image != $image_path ]; then
# hyprctl hyprpaper preload $image_path
# hyprctl hyprpaper wallpaper $current_monitor,$image_path
# fi
# # hyprctl hyprpaper unload $image_path

