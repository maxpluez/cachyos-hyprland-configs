#!/bin/bash

# Define entries with Nerd Font icons
lock="  Lock"
logout="󰍃  Logout"
reboot="󰑐  Reboot"
shutdown="  Shutdown"

confirm_reboot="󰑐  Confirm"
confirm_shutdown="  Confirm"
cancel="󰅖  Cancel"

entries="$lock
$logout
$reboot
$shutdown"

while true; do
  selected=$(echo -e "$entries" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Power Menu" -click-to-exit)

  case $selected in
    "$lock")
      hyprlock; break ;;
    "$logout")
      niri msg action quit; break ;;
    "$reboot")
      confirm=$(echo -e "$confirm_reboot\n$cancel" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Are you sure?" -click-to-exit)
      if [[ "$confirm" == "$confirm_reboot" ]]; then
          systemctl reboot; break
      elif [[ "$confirm" == "$cancel" ]]; then
          continue
      fi
      break ;;
    "$shutdown")
      confirm=$(echo -e "$confirm_shutdown\n$cancel" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Are you sure?" -click-to-exit)
      if [[ "$confirm" == "$confirm_shutdown" ]]; then
          systemctl poweroff; break
      elif [[ "$confirm" == "$cancel" ]]; then
          continue
      fi
      break ;;
    *)
      break ;;
  esac
done
