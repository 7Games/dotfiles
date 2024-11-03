#!/bin/bash

# Check if an argument is provided for the length of the checksum
if [ $# -eq 1 ]; then
    length=$1
else
    length=32  # Default length for MD5 checksum
fi

# Validate that the length is a positive integer
if ! [[ "$length" =~ ^[0-9]+$ ]] || [ "$length" -le 0 ]; then
    echo "Error: Length must be a positive integer."
    exit 1
fi

for file in *; do
    if [ -f "$file" ]; then
        extension="${file##*.}"
        filename=$(basename "$file" ".$extension")
        md5sum=$(md5sum "$file" | cut -d ' ' -f 1)

        # Get the specified length of the checksum
        short_checksum=${md5sum:0:length}

        new_filename="$short_checksum.$extension"
        mv "$file" "$new_filename"
    fi
done
