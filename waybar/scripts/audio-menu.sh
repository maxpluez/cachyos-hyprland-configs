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
    content: "   Vol - ";
    action: "kb-custom-1";
    background-color: #333333;
    text-color: white;
    padding: 10px;
    border-radius: 5px;
    cursor: pointer;
}
button2 {
    expand: true;
    content: "   Mute ";
    action: "kb-custom-2";
    background-color: #333333;
    text-color: white;
    padding: 10px;
    border-radius: 5px;
    cursor: pointer;
}
button3 {
    expand: true;
    content: "   Vol + ";
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
        rofi -modi "Output:$0 output,Input:$0 input" \
             -show Output \
             -theme "$THEME_PATH" \
             -theme-str "listview { lines: 6; } window { width: 600px; } ${BUTTONS_THEME}" \
             -kb-custom-1 "alt+1" -kb-custom-2 "alt+2" -kb-custom-3 "alt+3"
    else
        rofi -modi "Output:$0 output,Input:$0 input" \
             -show Output \
             -theme-str "mode-switcher { enabled: true; } listview { lines: 6; } window { width: 600px; } ${BUTTONS_THEME}" \
             -kb-custom-1 "alt+1" -kb-custom-2 "alt+2" -kb-custom-3 "alt+3"
    fi
    exit 0
fi

# Handle actions from ROFI_INFO
if [ -n "$ROFI_INFO" ]; then
    ACTION=$(echo "$ROFI_INFO" | awk '{print $1}')
    DEVICE_NAME=$(echo "$ROFI_INFO" | awk '{print $2}')
    
    # User pressed Enter to select the device
    if [ "$ROFI_RETV" = "1" ] || [ -z "$ROFI_RETV" ]; then
        case "$ACTION" in
            SET_SINK)
                pactl set-default-sink "$DEVICE_NAME"
                for input in $(pactl list short sink-inputs | cut -f1); do
                    pactl move-sink-input "$input" "$DEVICE_NAME" 2>/dev/null
                done
                notify-send "Audio Output" "Changed to $(pactl list sinks | grep -A1 "Name: $DEVICE_NAME" | grep Description | cut -d: -f2- | xargs)" -i audio-speakers
                exit 0
                ;;
            SET_SOURCE)
                pactl set-default-source "$DEVICE_NAME"
                for output in $(pactl list short source-outputs | cut -f1); do
                    pactl move-source-output "$output" "$DEVICE_NAME" 2>/dev/null
                done
                notify-send "Audio Input" "Changed to $(pactl list sources | grep -A1 "Name: $DEVICE_NAME" | grep Description | cut -d: -f2- | xargs)" -i audio-input-microphone
                exit 0
                ;;
        esac
    fi

    # User pressed a custom button
    if [ "$ROFI_RETV" = "10" ]; then # Vol -
        case "$ACTION" in
            SET_SINK) pactl set-sink-volume "$DEVICE_NAME" -5% ;;
            SET_SOURCE) pactl set-source-volume "$DEVICE_NAME" -5% ;;
        esac
    elif [ "$ROFI_RETV" = "11" ]; then # Mute
        case "$ACTION" in
            SET_SINK) pactl set-sink-mute "$DEVICE_NAME" toggle ;;
            SET_SOURCE) pactl set-source-mute "$DEVICE_NAME" toggle ;;
        esac
    elif [ "$ROFI_RETV" = "12" ]; then # Vol +
        case "$ACTION" in
            SET_SINK) pactl set-sink-volume "$DEVICE_NAME" +5% ;;
            SET_SOURCE) pactl set-source-volume "$DEVICE_NAME" +5% ;;
        esac
    fi
fi

# Print Items for Rofi
if [ "$MODE" == "output" ]; then
    DEFAULT_SINK=$(pactl get-default-sink)
    pactl list sinks | awk -v default_sink="$DEFAULT_SINK" '
    /^Sink #/ { in_sink=1; name=""; desc=""; mute=""; vol="" }
    /^[[:space:]]+Name: / { if (in_sink) name=$2 }
    /^[[:space:]]+Description: / { if (in_sink) { $1=""; desc=substr($0,2); sub(/^[[:space:]]+/, "", desc) } }
    /^[[:space:]]+Mute: / { if (in_sink) mute=$2 }
    /^[[:space:]]+Volume: / && !/Base Volume/ {
        if (in_sink) {
            match($0, /[0-9]+%/)
            vol=substr($0, RSTART, RLENGTH)
            
            prefix = (name == default_sink) ? "🔊" : "  "
            printf "%s %s (%s, %s)\0icon\x1faudio-speakers\x1finfo\x1fSET_SINK %s\n", prefix, desc, vol, (mute == "yes" ? "Muted" : "Unmuted"), name
            
            in_sink=0
        }
    }'
elif [ "$MODE" == "input" ]; then
    DEFAULT_SOURCE=$(pactl get-default-source)
    pactl list sources | awk -v default_source="$DEFAULT_SOURCE" '
    /^Source #/ { in_source=1; name=""; desc=""; mute=""; vol=""; is_monitor=0 }
    /^[[:space:]]+Name: / { if (in_source) { name=$2; if(name ~ /\.monitor$/) is_monitor=1 } }
    /^[[:space:]]+Description: / { if (in_source) { $1=""; desc=substr($0,2); sub(/^[[:space:]]+/, "", desc) } }
    /^[[:space:]]+Mute: / { if (in_source) mute=$2 }
    /^[[:space:]]+Volume: / && !/Base Volume/ {
        if (in_source && !is_monitor) {
            match($0, /[0-9]+%/)
            vol=substr($0, RSTART, RLENGTH)
            
            prefix = (name == default_source) ? "🎙️" : "  "
            printf "%s %s (%s, %s)\0icon\x1faudio-input-microphone\x1finfo\x1fSET_SOURCE %s\n", prefix, desc, vol, (mute == "yes" ? "Muted" : "Unmuted"), name
            
            in_source=0
        }
    }'
fi
