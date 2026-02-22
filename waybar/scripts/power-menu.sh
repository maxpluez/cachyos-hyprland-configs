#!/bin/bash

# Define entries with Nerd Font icons
lock="  Lock"
logout="󰍃  Logout"
reboot="󰑐  Reboot"
shutdown="  Shutdown"

entries="$lock
$logout
$reboot
$shutdown"

selected=$(echo -e "$entries" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Power Menu" -click-to-exit)

case $selected in
  "$lock")
    hyprlock ;;
  "$logout")
    hyprctl dispatch exit ;;
  "$reboot")
    systemctl reboot ;;
  "$shutdown")
    systemctl poweroff ;;
esac
