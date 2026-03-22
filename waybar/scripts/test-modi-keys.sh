#!/bin/bash
if [ -n "$ROFI_RETV" ]; then
    echo "RETV: $ROFI_RETV, ARG: $1, INFO: $ROFI_INFO" >> /tmp/rofi-modi-keys.log
fi
if [ "$ROFI_RETV" = "10" ]; then
    echo "Custom 1 pressed!" >> /tmp/rofi-modi-keys.log
    exit 0
fi
echo -en "Item 1\0info\x1ftest\n"
