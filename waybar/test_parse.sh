#!/bin/bash
nmcli -t -e yes -f SSID,SECURITY,SIGNAL,ACTIVE dev wifi | while IFS= read -r line; do
    active="${line##*:}"
    line="${line%:*}"
    signal="${line##*:}"
    line="${line%:*}"
    security="${line##*:}"
    ssid="${line%:*}"
    ssid="${ssid//\\:/:}"
    if [ -n "$ssid" ]; then
        echo "SSID: $ssid, SEC: $security, SIG: $signal, ACT: $active"
    fi
done | head -n 5
