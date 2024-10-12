#!/bin/bash

for file in *; do
    if [ -f "$file" ]; then
        extension="${file##*.}"
        filename=$(basename "$file" ".$extension")
        md5sum=$(md5sum "$file" | cut -d ' ' -f 1)
        new_filename="$md5sum.$extension"
        mv "$file" "$new_filename"
    fi
done

