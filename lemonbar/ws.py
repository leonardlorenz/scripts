import json
import sys

ws_list = json.loads(sys.argv[1])

string = ""
for i,t in enumerate(ws_list):
    if t['visible']:
        string = string + t['name'][2:] + ' '
    else:
        string = string + t['name'][2:] + ' '

print(string)
