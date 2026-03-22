#!/bin/bash
if [ -n "$ROFI_RETV" ]; then echo "RETV: $ROFI_RETV ARG: $1 INFO: $ROFI_INFO" > /tmp/rofi-test.log; fi
if [ "$ROFI_RETV" = "10" ]; then exit 0; fi
echo -en "Item 1\0info\x1fMY_INFO\n"
