WSJSON=$(i3-msg -t get_workspaces)
PARSED=$(python ~/Scripts/lemonbar/ws.py "$WSJSON")
echo "$PARSED"
