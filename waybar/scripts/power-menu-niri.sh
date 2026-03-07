#!/bin/bash

# Define entries with Nerd Font icons
lock="  Lock"
logout="󰍃  Logout"
reboot="󰑐  Reboot"
shutdown="  Shutdown"
cancel="󰅖  Cancel"

confirm_text="󰄬  Confirm"

entries="$lock
$logout
$reboot
$shutdown
$cancel"

while true; do
  selected=$(echo -e "$entries" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Power Menu" -click-to-exit)

  case $selected in
    "$lock")
      confirm=$(echo -e "$confirm_text\n$cancel" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Lock screen?" -click-to-exit)
      if [[ "$confirm" == "$confirm_text" ]]; then
          hyprlock; break
      fi
      continue ;;
    "$logout")
      confirm=$(echo -e "$confirm_text\n$cancel" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Logout?" -click-to-exit)
      if [[ "$confirm" == "$confirm_text" ]]; then
          niri msg action quit; break
      fi
      continue ;;
    "$reboot")
      confirm=$(echo -e "$confirm_text\n$cancel" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Reboot?" -click-to-exit)
      if [[ "$confirm" == "$confirm_text" ]]; then
          systemctl reboot; break
      fi
      continue ;;
    "$shutdown")
      confirm=$(echo -e "$confirm_text\n$cancel" | rofi -dmenu -i -theme "$HOME/.config/waybar/rofi-power.rasi" -p "Shutdown?" -click-to-exit)
      if [[ "$confirm" == "$confirm_text" ]]; then
          systemctl poweroff; break
      fi
      continue ;;
    "$cancel"|*)
      break ;;
  esac
done
