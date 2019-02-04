#!/bin/bash

domain="upload.nixne.st"
maimoutput="/tmp/upload.png"

# -s = select area to screenshot
maim -s $maimoutput

# generate random 32 char long alphanumeric string
filename=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#upload to domain
url=$(curl -s -X POST https://$domain/image -H "Upload-Key: 67449a5e5c0f5aa29dd31faa5ffdc5c7" -F "uploadFile=@$maimoutput" | jq '.link' | sed 's/\"//g')

# primary (middle click)
echo $url | xclip -i
notify-send "Screenshot taken. URL has been copied to clipboard"
