#!/bin/bash
rofi -e "Test Textbox" -theme-str '
window {
    children: [ mainbox ];
}
mainbox {
    children: [ inputbar, message, listview, mybuttons ];
}
mybuttons {
    orientation: horizontal;
    expand: false;
    children: [ button1, button2 ];
}
button1 {
    expand: true;
    content: " Vol + ";
    action: "kb-custom-1";
    background-color: #333333;
    padding: 10px;
    border-radius: 5px;
}
button2 {
    expand: true;
    content: " Vol - ";
    action: "kb-custom-2";
    background-color: #333333;
    padding: 10px;
    border-radius: 5px;
}
' -kb-custom-1 "alt+1" -kb-custom-2 "alt+2"
