#!/bin/bash

if [ ! "$#" = 2 ]; then
    echo "I need two arguments!"
    exit
fi

FFARGS=""

for file in *."$1"; do
    if [ -f "$file" ]; then
        new_file="${file%.*}.$2"

	if [ "$2" = "mp4" ]; then
	    FFARGS="-c:v libx264 -c:a libopus"
	fi
	
        ffmpeg -i "$file" $FFARGS "$new_file"
        echo "$file > $new_file"
    fi
done
