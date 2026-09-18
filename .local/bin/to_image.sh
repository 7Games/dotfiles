#!/bin/bash

# to_image.sh - convert X to Y using imagemagick
# Created by svngms 2024-2025
# This script is under the UNLICENSE (https://unlicense.org/)

if [ "$#" -lt 2 ]; then
    echo "usage: to_image.sh [EXT FROM] [EXT TO] &optional [OUT PATH] [MAGICK ARGS]"
    echo "Convert X image format to Y image format in the current directory"
    echo
    echo "example: to_image.sh jpeg png # Convert all jpeg files to png files"
    exit -1
fi

OUT_PATH="."
MAGICK_ARGS=""

if [ "$3" ]; then
    OUT_PATH="$3"
fi

if [ "$4" ]; then
    MAGICK_ARGS="$4"
fi

for file in *."$1"; do
    if [ -f "$file" ]; then
        new_file="$OUT_PATH/${file%.*}.$2"
        magick "$file" $MAGICK_ARGS "$new_file"
        printf "%s\t > \t%s\n" "$file" "$new_file"
    fi
done
