#!/bin/sh

theme="$HOME/.config/rofi/configs/applets.rasi"
listTheme="$HOME/.config/rofi/configs/applets-list.rasi"
passTheme="$HOME/.config/rofi/configs/ai.rasi"

list_col='6'
list_row='1'
pass_list_col='1'
pass_list_row='1'

powerStatus=""
networks=""
password=""
connections=""

layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1="󰖩 Connect"
  option_2=" Manage"
  option_3="⏻ Power"
  yes=' Yes'
  no=' No'
else
  option_1="󰖩"
  option_2=""
  option_3="⏻"
  yes=''
  no=''
fi

check_power() {
  echo -e "$(nmcli r wifi)"
}

powerStatus="$(check_power)"

toggle_power() {
  if [[ $powerStatus == "enabled" ]]; then
    nmcli r wifi off
    return 0
  else
    nmcli r wifi on
    return 0
  fi
}

prompt="Wifi"
mesg="Wifi is currently $powerStatus"

rofi_cmd() {
  rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "󰖩";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}

}

run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3" | rofi_cmd
}

confirm_cmd() {
  rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
    -theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
    -theme-str 'listview {columns: 2; lines: 1;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -theme-str 'textbox {horizontal-align: 0.5;}' \
    -dmenu \
    -p 'Confirmation' \
    -mesg 'Are you Sure?' \
    -theme ${theme}
}

confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

confirm_run() {
  selected="$(confirm_exit)"
  if [[ "$selected" == "$yes" ]]; then
    ${1} && ${2} && ${3}
  else
    exit
  fi
}

connect_wifi() {
  # Simple connection attempt first
  if nmcli device wifi connect "$networks" password "$password"; then
    notify-send "WiFi" "Successfully connected to $networks"
  else
    # If that fails, try creating a connection with explicit settings
    notify-send "WiFi" "First attempt failed, trying alternative method..."

    # Clean the SSID for connection name (remove spaces and special chars)
    clean_name=$(echo "$networks" | tr ' ' '_' | tr -cd '[:alnum:]_-')

    # Create a new connection with explicit settings
    if nmcli connection add type wifi con-name "$clean_name" ifname "$(nmcli -t -f DEVICE device status | grep wifi | head -n1)" ssid "$networks" \
      wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$password"; then

      # Connect to the newly created connection
      nmcli connection up "$clean_name"
      notify-send "WiFi" "Connected to $networks using alternative method"
    else
      notify-send "WiFi" "Failed to connect to $networks"
    fi
  fi
}

#connect_wifi() {
#  nmcli device wifi connect "$networks" password "$password"
#}

input_password() {
  password=$(rofi -dmenu \
    -password \
    -theme-str "listview {columns: $pass_list_col; lines: $pass_list_row;}" \
    -p "input password" \
    -markup-rows \
    -theme "${passTheme}")

  if [[ -n "$password" ]]; then
    connect_wifi
  fi
}

#input_password() {
#  password=$(rofi -dmenu \
#    -password \
#    -theme-str "listview {columns: $pass_list_col; lines: $pass_list_row;}" \
#    -p "input password" \
#    -markup-rows \
#    -theme "${passTheme}")

#  connect_wifi
#}

list_networks() {
  # Present clean SSIDs to the user
  networks=$(nmcli -f SSID device wifi | sed "s/SSID//g" | sed "s/--//g" | sed "s/ *$//g" | sed "/^[[:space:]]*$/d" | rofi -dmenu -p "select a network" -theme ${listTheme})

  if [[ $networks == "q" || $networks == "" ]]; then
    exit
  else
    input_password
  fi
}

#list_networks() {
#  networks=$(nmcli -f SSID device wifi | sed "s/SSID//g" | sed "s/--//g" | sed "s/ *$//g" | sed "/^[[:space:]]*$/d" | rofi -dmenu -p "select a network" -theme ${listTheme})

#  if [[ $networks == "q" || $networks == "" ]]; then
#    exit
#  else
#    input_password
#  fi
#}

interface_change() {
  echo $connections
  nmcli connection $1 "$connections"
}

edit_connection() {
  options="up\ndown\nreload\ndelete"

  option=$(echo -e $options | rofi -dmenu -p "select a connection" -theme ${listTheme})

  case $option in
  "up")
    interface_change up
    ;;
  "down")
    interface_change down
    ;;
  "reload")
    interface_change reload
    ;;
  "delete")
    interface_change delete
    ;;
  *)
    exit
    ;;
  esac
}

list_connections() {
  connections=$(nmcli connection show | grep "wifi" | sed -E 's/^(.+[^[:space:]])[[:space:]]+[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}.*/\1/' | rofi -dmenu -p "select a connection" -theme ${listTheme})

  if [[ $connections == "q" || $connections == "" ]]; then
    exit
  else
    edit_connection $connections
  fi
}

chosen="$(run_rofi)"
case ${chosen} in
$option_1)
  list_networks
  ;;
$option_2)
  list_connections
  ;;
$option_3)
  confirm_run toggle_power
  ;;
esac
