#!/bin/bash
rofi -e "Test Clickable" -theme-str '
window { children: [ "mainbox" ]; }
mainbox { children: [ "my-buttons", "message" ]; }
my-buttons {
    orientation: horizontal;
    children: [ "button-up", "button-down" ];
}
button-up {
    expand: false;
    content: "Vol Up";
    action: "kb-custom-1";
}
button-down {
    expand: false;
    content: "Vol Down";
    action: "kb-custom-2";
}
' & sleep 1; killall rofi
