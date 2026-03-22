#!/usr/bin/env bash

MODE="$1"

# If no arguments are passed, act as the launcher
if [ -z "$MODE" ]; then
    # Look for a theme from rofi launchers if available, otherwise use a generic theme string
    THEME_PATH="$HOME/.config/rofi/launchers/type-1/style-7.rasi"
    
    BUTTONS_THEME='
mybuttons {
    orientation: horizontal;
    expand: false;
    padding: 5px;
    spacing: 10px;
    children: [ button1, button2, button3 ];
}
button1 {
    expand: true;
    content: " 󰤨  Enable ";
    action: "kb-custom-1";
    background-color: #333333;
    text-color: white;
    padding: 10px;
    border-radius: 5px;
    cursor: pointer;
}
button2 {
    expand: true;
    content: " 󰑐  Rescan ";
    action: "kb-custom-2";
    background-color: #333333;
    text-color: white;
    padding: 10px;
    border-radius: 5px;
    cursor: pointer;
}
button3 {
    expand: true;
    content: " 󰤭  Disable ";
    action: "kb-custom-3";
    background-color: #333333;
    text-color: white;
    padding: 10px;
    border-radius: 5px;
    cursor: pointer;
}
window { children: [ mainbox ]; }
mainbox { children: [ inputbar, message, mode-switcher, listview, mybuttons ]; }
'

    if [ -f "$THEME_PATH" ]; then
        rofi -modi "WiFi:$0 wifi" \
             -show WiFi \
             -theme "$THEME_PATH" \
             -theme-str "listview { lines: 6; } window { width: 600px; } ${BUTTONS_THEME}" \
             -kb-custom-1 "alt+1" -kb-custom-2 "alt+2" -kb-custom-3 "alt+3"
    else
        rofi -modi "WiFi:$0 wifi" \
             -show WiFi \
             -theme-str "mode-switcher { enabled: false; } listview { lines: 6; } window { width: 600px; } ${BUTTONS_THEME}" \
             -kb-custom-1 "alt+1" -kb-custom-2 "alt+2" -kb-custom-3 "alt+3"
    fi
    exit 0
fi

# Handle actions from ROFI_INFO
if [ -n "$ROFI_INFO" ]; then
    ACTION=$(echo "$ROFI_INFO" | cut -d'|' -f1)
    SSID=$(echo "$ROFI_INFO" | cut -d'|' -f2-)
    
    # User pressed Enter to select the device
    if [ "$ROFI_RETV" = "1" ] || [ -z "$ROFI_RETV" ]; then
        if [ "$ACTION" = "CONNECT" ]; then
            # Run connection logic in the background so Rofi closes immediately
            (
                sleep 0.2 # Give main Rofi a moment to fully close
                
                # Check if it's a known connection
                if nmcli -t -f NAME connection show | grep -Fqx "$SSID"; then
                    notify-send "WiFi" "Connecting to $SSID..." -i network-wireless
                    OUTPUT=$(nmcli connection up id "$SSID" 2>&1)
                    RES=$?
                    if [ $RES -eq 0 ]; then
                        notify-send "WiFi" "Connected to $SSID" -i network-wireless
                    else
                        notify-send "WiFi" "Failed to connect to $SSID" "$OUTPUT" -i network-wireless-disconnected
                    fi
                else
                    # Ask for password
                    PASSWORD=$(echo "" | rofi -dmenu -password -p "Password for $SSID: " -theme-str "listview { lines: 0; } window { width: 400px; }")
                    ROFI_EXIT=$?
                    
                    if [ $ROFI_EXIT -eq 0 ]; then
                        notify-send "WiFi" "Connecting to $SSID..." -i network-wireless
                        if [ -n "$PASSWORD" ]; then
                            OUTPUT=$(nmcli device wifi connect "$SSID" password "$PASSWORD" 2>&1)
                        else
                            OUTPUT=$(nmcli device wifi connect "$SSID" 2>&1)
                        fi
                        RES=$?
                        
                        if [ $RES -eq 0 ]; then
                            notify-send "WiFi" "Connected to $SSID" -i network-wireless
                        else
                            notify-send "WiFi" "Failed to connect to $SSID" "$OUTPUT" -i network-wireless-disconnected
                        fi
                    else
                        notify-send "WiFi" "Connection cancelled" -i network-wireless
                    fi
                fi
            ) </dev/null >/dev/null 2>&1 &
            exit 0
        fi
    fi

    # User pressed a custom button
    if [ "$ROFI_RETV" = "10" ]; then # Enable
        nmcli radio wifi on
        notify-send "WiFi" "Enabled" -i network-wireless
    elif [ "$ROFI_RETV" = "11" ]; then # Rescan
        notify-send "WiFi" "Rescanning..." -i network-wireless
        nmcli device wifi rescan
    elif [ "$ROFI_RETV" = "12" ]; then # Disable
        nmcli radio wifi off
        notify-send "WiFi" "Disabled" -i network-wireless-disconnected
    fi
    exit 0
fi

# Print Items for Rofi
if [ "$MODE" == "wifi" ]; then
    declare -A SEEN
    nmcli -t -e yes -f SSID,SECURITY,SIGNAL,ACTIVE dev wifi list --rescan no | while IFS= read -r line; do
        active="${line##*:}"
        line="${line%:*}"
        signal="${line##*:}"
        line="${line%:*}"
        security="${line##*:}"
        ssid="${line%:*}"
        
        # Unescape colons
        ssid="${ssid//\\:/:}"

        if [ -n "$ssid" ]; then
            prefix="  "
            if [ "$active" = "yes" ]; then
                prefix=" "
            fi
            
            if [ "$signal" -gt 80 ]; then
                icon="network-wireless-signal-excellent"
            elif [ "$signal" -gt 60 ]; then
                icon="network-wireless-signal-good"
            elif [ "$signal" -gt 40 ]; then
                icon="network-wireless-signal-ok"
            elif [ "$signal" -gt 20 ]; then
                icon="network-wireless-signal-weak"
            else
                icon="network-wireless-signal-none"
            fi
            
            if [ -z "${SEEN["$ssid"]}" ]; then
                SEEN["$ssid"]=1
                printf "%s %s (%s%%, %s)\0icon\x1f%s\x1finfo\x1fCONNECT|%s\n" "$prefix" "$ssid" "$signal" "$security" "$icon" "$ssid"
            fi
        fi
    done
fi

