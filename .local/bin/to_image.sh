#!/bin/bash

if [ ! "$#" = 2 ]; then
    echo "I need two arguments!"
    exit
fi

for file in *."$1"; do
    if [ -f "$file" ]; then
        new_extension="$2"
        filename="${file%.*}"
        new_filename="$filename"
        new_file="$new_filename.$new_extension"
        magick "$file" "$new_file"
        echo "$file > $new_file"
    fi
done
