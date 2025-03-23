#!/bin/sh

dir="$HOME/hyprland-config/Pictures/wallpapers/"
wallpaper=""
wallpaperPath=""
current=""

theme="$HOME/.config/rofi/configs/applets-list.rasi"

set_wallpaper() {
  swww img "$wallpaperPath" --transition-type grow

  sed -i "s#$current#$wallpaperPath#g" $HOME/.config/rofi/themes/tokyonight.rasi
  sed -i "s#$current#$wallpaperPath#g" $HOME/.config/hypr/hyprlock.conf
}

list_wallpapers() {
  wallpaper=$(find $dir -type f | sed 's:.*/::' | rofi -dmenu -p "select a wallpaper" -theme ${theme})

  wallpaperPath=$(find $dir -type f | grep $wallpaper)

  set_wallpaper
}

get_current() {
  current=$(swww query | awk '{print $8}' | head -n 1)

  list_wallpapers
}

get_current
