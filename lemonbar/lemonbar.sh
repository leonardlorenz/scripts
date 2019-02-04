#!/bin/bash

isDesktop="$(acpi 2>&1 | grep power_supply)"

icon() {
    echo -n -e "%{T2}\u$1%{T-}%{T1}"
}

# Show Time
dateD() {
    day=$(date +"%d.%m.%Y")
    echo -n "$day"
}

dateC() {
    clock=$(date +"%I:%M%P")
    echo -n "$clock"
}

# Battery Percentage
battery() {
    if [ -n "$isDesktop" ]
    then
        echo -n "BAT: Power Supply"
    else
        PLUGGED=$(acpi -a | tail -c 8 | grep 'on-line')
        if [ "$PLUGGED" ]
	    then
            charging=" (charging)"
	    else
	    	charging=""
	    fi
        batperc="$(acpi --battery | awk -F ',' '{print $2}')"
        echo -n "BAT: $batperc$charging"
    fi
}

# CPU Usage
cpuP() {
    cpuperc=$(top -bn1 | grep "Cpu(s)" | \
       sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
       awk '{print 100 - $1"%"}')
    echo -n "CPU: $cpuperc"
}

# CPU temperature
cpuT() {
    if [ -n "$isDesktop" ]
    then
        cputemp=$(sensors | grep "Tdie" | awk '{ print $2 }' | sed 's/\+/CPUT:\ /g')
        echo -n "$cputemp"
    else
        cputemp=$(sensors | grep "Core 0" | awk '{ print $3 }' | sed 's/\+/CPUT:\ /g')
        echo -n "$cputemp"
    fi
}

# GPU temperature
gpuT() {
    gputemp=$(sensors | grep temp1 | awk '{ print $2 }' | sed 's/\+/GPUT:\ /g')
    echo -n "$gputemp"
}

updates() {
    updates=$(checkupdates | wc -l)

    if [ "$updates" -eq 1 ]; then
        echo -n "$updates update"
    elif [ "$updates" -gt 1 ]; then
        echo -n "$updates updates"
    else
        echo -n "no updates"
    fi
}

network() {
    network=$(iwgetid --scheme)
    if [ -z "$network" ]
    then
        echo -n "Wired"
    else
        echo -n "$network"
    fi
}

memory() {
    memory=$(free | grep Mem | awk '{print int($3/$2 * 100.0)}')
    echo -n "%{A:xinput reattach "AT Translated Set 2 keyboard" 3:}RAM: $memory% %{A}"
}

keyboard() {
    layout=$(setxkbmap -query | grep --color=never layout | awk '{ print $2}')
    variant=$(setxkbmap -query | grep --color=never variant | awk '{ print $2}')
    echo -n "%{A:~/Scripts/lemonbar/toggleKeyboard.sh:}$layout($variant)%{A}"
}

i3() {
    workspaces=$(~/Scripts/lemonbar/ws.sh)
    echo -n "%{A4:i3-msg workspace next:}%{A5:i3-msg workspace prev:} $workspaces%{A}%{A}"
}

monitors() {
    monitors=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")
    echo "$monitors"
}

primary="#FD7980"
secondary="#95aec7"
white="#ffffff"
transparent="#00000000"
alert="#FF0000"
dark="#2f343f"

barbg="%{B$transparent}"
doset="%{T1}"
reset="%{F-}%{B-}%{T-}$barbg"
underline="%{+u 4 U$secondary}"

while true; do
#    %{c} $(i3)\
    leftbar="%{l} $(cpuP) $(icon e0be)%{R} $(memory) $(icon e0be)%{R} $(cpuT) $(icon e0be)%{R} $(gpuT) $(icon e0be)%{R} $(battery) $(icon e0be)"
    rightbar="%{r}$(icon e0bc) $(updates) $(icon e0ba)%{R} $(keyboard) $(icon e0ba)%{R} $(network) $(icon e0ba)%{R} $(dateD) $(icon e0ba)%{R} $(dateC) "
    bar="$doset%{B$white}%{F$dark}$leftbar%{B$white}$rightbar$reset$barbg"
    echo $bar
    sleep 5
done
