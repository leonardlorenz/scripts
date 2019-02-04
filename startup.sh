#!/bin/bash

######################
##### NETWORKING #####
######################

nm-applet &
blueman-applet &

##################
##### POLKIT #####
##################

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

######################
##### COMPOSITOR #####
######################

# compton -f --blur-method kawase --blur-strength 10 --config ~/.config/compton/compton.conf &
killall compton
compton --config ~/.config/compton/compton.conf &

#####################
##### START MPD #####
#####################

[ ! -s ~/.config/mpd/pid ] && mpd

########################
##### SCREENLAYOUT #####
########################

#sh ~/.screenlayout/desktopscreenonly.sh &

~/Scripts/checkforscreens.sh &

######################
##### STATUS BAR #####
######################

# ~/Scripts/polybarlaunch.sh &

killall lemonbar
width=$(xrandr | grep "current" | awk '{print $8a / 2}')
~/Scripts/lemonbar/lemonbar.sh | lemonbar -p -f Hack\ Nerd\ Font\ Mono:pixelsize=15 -g "x18+0+0" | bash

############################
##### background image #####
############################

# wait for the screen layout to finish
feh --bg-fill ~/.config/ranger/wall.png
