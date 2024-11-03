#!/bin/bash

yt-dlp --download-archive history.log \
       --write-description \
       --write-thumbnail \
       --embed-chapters \
       --remux-video "mp4" \
       --convert-thumbnails "jpg" \
       -a "urls.txt" \
       -o "%(title)s - %(uploader)s [%(id)s]/%(title)s.%(ext)s"

for D in *; do
    if [ -d "${D}" ]; then
        cd "${D}"
        thumbnail="$(find . -iname "*.jpg")"
        gio set . metadata::custom-icon file://"$(pwd)"/"$thumbnail"
        cd ..
    fi
done
