#/bin/bash

# CPU usage
# https://stackoverflow.com/questions/9229333/how-to-get-overall-cpu-sage-e-g-57-on-linux
# author: netcoder
# modified
top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1"%"}' | \
           sed "s/^/CPU%:\ /g"

# CPU temperature
# check `sensors` output for the right grep identifier. your temp sensor might not be called Tdie
sensors | grep Tdie | awk '{ print $2 }' | sed 's/\+/CPUT:\ /g'

# GPU usage
# check `sensors` output for the right grep identifier. your temp sensor might not be called temp1
sensors | grep temp1 | awk '{ print $2 }' | sed 's/\+/GPUT:\ /g'

# GPU temperature
# yet to be found

# output should look something like this
# CPU%: 2.7%
# CPUT: 36.0°C
# GPUT: 36.0°C
