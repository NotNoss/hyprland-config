#!/bin/zsh

active_class=$(hyprctl activewindow | grep "class:" | awk '{print $2}')

if [[ $active_class == "kitty" ]]; then
  tmux kill-session -t ""
fi

hyprctl dispatch killactive
