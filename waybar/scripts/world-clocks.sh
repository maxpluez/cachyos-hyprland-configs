#!/bin/bash
# Get current time in target zones
LA=$(TZ='America/Los_Angeles' date +'%H:%M')
SH=$(TZ='Asia/Shanghai' date +'%H:%M')
LOCAL=$(TZ='America/Los_Angeles' date +'%H:%M:%S')

# Construct the tooltip with explicit newline characters for jq
TOOLTIP="<big><b>World Clocks</b></big>\n\n"
TOOLTIP+="<tt><b>City</b>            <b>Time</b>\n"
TOOLTIP+="----------------------\n"
TOOLTIP+="<span color='#cba6f7'>󰖟</span> Los Angeles   $LA\n"
TOOLTIP+="<span color='#89b4fa'>󰖟</span> Shanghai      $SH</tt>"

# Output COMPACT JSON to avoid parsing issues with leading spaces/newlines
jq -nc --arg text "$LOCAL" --arg tooltip "$(echo -e "$TOOLTIP")" '{text: $text, tooltip: $tooltip}'
