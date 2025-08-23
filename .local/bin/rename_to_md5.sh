#!/bin/bash

# rename_to_md5.sh - rename every file in pwd to their md5 checksum
# Created by svngms 2024-2025
# This script is under the UNLICENSE (https://unlicense.org/)

# Default length for MD5 checksum
if [ $# -eq 1 ]; then
    length=$1
else
    length=32
fi

if ! [[ "$length" =~ ^[0-9]+$ ]] || [ "$length" -le 0 ]; then
    echo "usage: rename_to_md5.sh [LENGTH]"
    echo "Rename files to their md5sum"
    echo
    echo "Length MUST be a positive integer"
    exit 1
fi

for file in *; do
    if [ -f "$file" ]; then
        extension="${file##*.}"
        filename=$(basename "$file" ".$extension")
        md5sum=$(md5sum "$file" | cut -d ' ' -f 1)
        short_checksum=${md5sum:0:length}
        new_filename="$short_checksum.$extension"
        printf "$file\t > \t$new_filename\n"
        mv "$file" "$new_filename"
    fi
done
