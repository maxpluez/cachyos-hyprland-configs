#!/bin/bash
echo "$1" >> /tmp/rofi-test.log
if [ -n "$2" ]; then
    echo "$2" >> /tmp/rofi-test.log
else
    echo "Option 1"
    echo "Option 2"
fi
