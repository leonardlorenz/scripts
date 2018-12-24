#!/bin/bash

xrandroutput=$(xrandr | grep "DP2")
echo $xrandroutput

if [ -z "$xrandroutput" ]
then
    source /home/$USER/.screenlayout/laptopscreenonly.sh
else
    source /home/$USER/.screenlayout/desktopscreenonly.sh
fi
