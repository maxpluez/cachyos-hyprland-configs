#!/bin/bash
echo "$(date) RETV: $ROFI_RETV ARG: $1 INFO: $ROFI_INFO" >> /tmp/rofi-modi-test.log

# If ROFI_RETV is 10, custom-1 was pressed on the current item
if [ "$ROFI_RETV" = "10" ]; then
    echo "kb-custom-1 pressed" >> /tmp/rofi-modi-test.log
    # Do we exit or output items again?
    # If we output items, does it stay open?
fi

if [ "$ROFI_RETV" = "1" ]; then
    # item selected
    echo "Selected $1" >> /tmp/rofi-modi-test.log
    exit 0
fi

echo -en "Test Item\0info\x1ftest_info\n"
