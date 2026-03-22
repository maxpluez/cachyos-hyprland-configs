#!/usr/bin/env bash

if [ -n "$ROFI_INFO" ]; then
    echo "Action: $ROFI_INFO" >> /tmp/rofi-info.log
    # Do not exit, just fall through
fi

echo -en "Test Item\0info\x1fACTION_1\n"
echo -en "Exit\0info\x1fEXIT\n"

if [ "$ROFI_INFO" == "EXIT" ]; then
    exit 0
fi