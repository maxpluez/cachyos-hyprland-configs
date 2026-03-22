#!/bin/bash
MODE=$1
SELECTION=$2

echo "Mode: $MODE, Selection: $SELECTION, Info: $ROFI_INFO" >> /tmp/rofi-info.log

if [ -n "$ROFI_INFO" ]; then
    echo "Done"
    exit 0
fi

echo -en "Item 1\0info\x1fitem_1_value\n"
echo -en "Item 2\0info\x1fitem_2_value\n"
