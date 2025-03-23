#!/bin/sh

keybinds="
Super+Enter     - Open Terminal
Super+Q         - Kill Active Window
Super+Shift+Q   - Exit Hyprland
Super+E         - Open Yazi
Super+Shift+E   - Open Aerc
Super+F         - Toggle Floating
Super+D         - App Launcher
Super+X         - Power Menu
Super+I         - Keybind Menu
Super+B         - Firefox
Super+Shift+B   - Bluetooth Menu
Alt+L           - Lock Screen
Super+S         - Screenshot Menu
Super+N         - Notification Center
Super+A         - AI Prompt
Super+W         - Wallpaper Select
Super+Shift+W   - Wifi Menu
Super+H         - Move Focus Left
Super+L         - Move Focus Right
Super+K         - Move Focus Up
Super+J         - Move Focus Down
Super+Shift+H   - Move Window Left
Super+Shift+L   - Move Window Right
Super+Shift+K   - Move Window Up
Super+Shift+J   - Move Window Down
Super+1-0       - Workspace 1-10
Super+Shift+1-0 - Move Win to Workspace 1-10
Super+V         - Window Vertical Split
Super+C         - Window Horizontal Split
Super+T         - Window Tabbed Mode
Super+Ctrl+K    - Raise Focus
Super+Ctrl+J    - Lower Focus
Super+M         - Move Win to Next Monitor
Super+Shift+M   - Move Win to Prev Monitor
"

theme="$HOME/.config/rofi/configs/keybinds.rasi"

list_col="2"
list_row="16"

rofi -dmenu \
  -theme-str "listview {columns: $list_col; lines: $list_row;}" \
  -markup-rows \
  -theme "${theme}" \
  -mesg "${keybinds}"
