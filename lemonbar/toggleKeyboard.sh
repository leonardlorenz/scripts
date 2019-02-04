#!/bin/bash

isDisabled="$(xinput list "AT Translated Set 2 keyboard" | grep "floating slave")"
if [ -z "$isDisabled" ]
then
    xinput float "AT Translated Set 2 keyboard"
    notify-send "disabled laptop keyboard"
else
    xinput reattach "AT Translated Set 2 keyboard" 3
    notify-send "reenabled laptop keyboard"
fi

