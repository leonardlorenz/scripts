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

###################
##### POLYBAR #####
###################

~/Scripts/polybarlaunch.sh &

############################
##### background image #####
############################

# wait for the screen layout to finish
sleep 1
feh --bg-fill ~/.config/ranger/wall.png
