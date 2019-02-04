#!/bin/bash

isDesktop="$(acpi 2>&1 | grep power_supply)"

icon() {
    echo -e "%{T2}\u$1%{T-}%{T1}"
}

# Show Time
dateD() {
    day=$(date +"%d.%m.%Y")
    echo "$day"
}

dateC() {
    clock=$(date +"%I:%M%P")
    echo "$clock"
}

# Battery Percentage
battery() {
    if [ -n "$isDesktop" ]
    then
        echo "BAT: Power Supply"
    else
        PLUGGED=$(acpi -a | tail -c 8 | grep 'on-line')
        if [ "$PLUGGED" ]
	    then
            charging=" (charging)"
	    else
	    	charging=""
	    fi
        batperc="$(acpi --battery | awk -F ',' '{print $2}')"
        echo "BAT: $batperc$charging"
    fi
}

# CPU Usage
cpuP() {
    cpuperc=$(top -bn1 | grep "Cpu(s)" | \
       sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
       awk '{print 100 - $1"%"}')
    echo "CPU: $cpuperc"
}

# CPU temperature
cpuT() {
    if [ -n "$isDesktop" ]
    then
        cputemp=$(sensors | grep "Tdie" | awk '{ print $2 }' | sed 's/\+/CPUT:\ /g')
        echo "$cputemp"
    else
        cputemp=$(sensors | grep "Core 0" | awk '{ print $3 }' | sed 's/\+/CPUT:\ /g')
        echo "$cputemp"
    fi
}

# GPU temperature
gpuT() {
    gputemp=$(sensors | grep temp1 | awk '{ print $2 }' | sed 's/\+/GPUT:\ /g')
    echo "$gputemp"
}

updates() {
    updates=$(checkupdates | wc -l)

    if [ "$updates" -eq 1 ]; then
        echo "$updates update"
    elif [ "$updates" -gt 1 ]; then
        echo "$updates updates"
    else
        echo "no updates"
    fi
}

network() {
    network=$(iwgetid --scheme)
    if [ -z "$network" ]
    then
        echo "Wired"
    else
        echo "$network"
    fi
}

memory() {
    memory=$(free | grep Mem | awk '{print int($3/$2 * 100.0)}')
    echo "RAM: $memory%"
}

keyboard() {
    layout=$(setxkbmap -query | grep --color=never layout | awk '{ print $2}')
    variant=$(setxkbmap -query | grep --color=never variant | awk '{ print $2}')
    echo "$layout($variant)"
}

i3() {
    workspaces=$(~/Scripts/lemonbar/ws.sh)
    echo "%{A4:i3-msg workspace next:}%{A5:i3-msg workspace prev:} $workspaces%{A}%{A}"
}

monitors() {
    monitors=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")
    echo "$monitors"
}

notify-send "\
$(dateD)
$(dateC)
$(cpuP)
$(memory)
$(cpuT)
$(gpuT)
$(network)
$(battery)
$(updates)
$(keyboard)"
