#!/bin/bash

# to_image.sh - convert X to Y using imagemagick
# Created by svngms 2024-2025
# This script is under the UNLICENSE (https://unlicense.org/)

if [ ! "$#" = 2 ]; then
    echo "usage: to_image.sh [EXT FROM] [EXT TO]"
    echo "Convert X image format to Y image format in the current directory"
    echo
    echo "example: to_image.sh jpeg png # Convert all jpeg files to png files"
    exit -1
fi

for file in *."$1"; do
    if [ -f "$file" ]; then
        new_file="${file%.*}.$2"
        magick "$file" "$new_file"
        printf "%s\t > \t%s\n" "$file" "$new_file"
    fi
done
