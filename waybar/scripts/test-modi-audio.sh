#!/bin/bash
echo "$(date) RETV=$ROFI_RETV INFO=$ROFI_INFO ARG=$1" >> /tmp/rofi-modi-audio.log

if [ "$ROFI_RETV" = "1" ]; then
    echo "Selected $1" >> /tmp/rofi-modi-audio.log
    exit 0
fi

if [ "$ROFI_RETV" = "10" ]; then
    echo "Vol - on $ROFI_INFO" >> /tmp/rofi-modi-audio.log
fi

echo -en "Test Sink\0info\x1fSET_SINK test\n"
echo -en "Test Source\0info\x1fSET_SOURCE test2\n"
