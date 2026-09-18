#!/bin/bash

# to_image.sh - download a song from the internet
# Created by svngms 2024-2025
# This script is under the UNLICENSE (https://unlicense.org/)

if [ ! "$#" = 1 ]; then
    echo "usage: to_image.sh [URL]"
    echo "Turn YouTube videos into mp3 files"
    exit -1
fi

yt-dlp -x \
    --audio-format mp3 \
    -f "bestaudio" \
    --embed-thumbnail \
    --js-runtimes node \
    --cookies-from-browser firefox \
    --convert-thumbnail jpg \
    --exec-before-download "ffmpeg -i %(thumbnails.-1.filepath)q -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\" _%(thumbnails.-1.filepath)q" \
    --exec-before-download "rm %(thumbnails.-1.filepath)q" \
    --exec-before-download "mv _%(thumbnails.-1.filepath)q %(thumbnails.-1.filepath)q" \
    --parse-metadata "title:%(title)s" \
    --embed-metadata \
    --output "%(artist)s - %(title)s.%(ext)s" \
    "$1"
