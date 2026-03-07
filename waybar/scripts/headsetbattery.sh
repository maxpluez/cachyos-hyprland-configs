#!/bin/bash

# Check if headsetcontrol is installed
if ! command -v headsetcontrol &> /dev/null; then
    printf '{"text": "󰋋 !", "class": "error", "alt": "headsetcontrol not installed"}\n'
    exit 0
fi

# Get info
STRING=$(headsetcontrol -o json 2>/dev/null)

# Get device count
COUNT=$(echo "$STRING" | jq '.device_count' 2>/dev/null)

# Exit if no devices detected or invalid JSON
if [[ -z "$COUNT" || "$COUNT" -eq 0 ]]; then
    printf '{"text": "", "class": "none", "alt": "No headset detected"}\n'
    exit 0
elif [[ "$COUNT" -gt 1 ]]; then
    printf '{"text": "󰋋 +", "class": "warning", "alt": "Multiple headsets detected"}\n'
    exit 0
fi

# Get battery level
LEVEL=$(echo "$STRING" | jq '.devices[0].battery.level' 2>/dev/null)

# If device is off, output off state.
if [[ "$LEVEL" -eq -1 ]]; then
    CLASS=off
    printf '{"text": "%s", "class": "%s", "alt": "%s"}\n' "󱘖 Off" "$CLASS" "Headset offline"
    exit 0
fi

# Else, output battery level states.
if [[ "$LEVEL" -le 0 ]]; then
    CLASS=critical
    ICON=󰂎
elif [[ "$LEVEL" -le 25 ]]; then
    CLASS=low
    ICON=󱊡
elif [[ "$LEVEL" -le 50 ]]; then
    ICON=󱊢
else
    ICON=󱊣
fi

printf '{"text": "%s", "class": "%s", "alt": "%s"}\n' "$ICON $LEVEL%" "$CLASS" "Headset Power Level"
