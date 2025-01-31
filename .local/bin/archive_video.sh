#!/bin/bash

yt-dlp -f "bestvideo[height<=1080]+bestaudio/best" \
       --write-description \
       --write-thumbnail \
       --embed-chapters \
       --remux-video "mkv" \
       --convert-thumbnails "jpg" \
       --embed-subs \
       --write-subs \
       --write-info-json \
       --write-comments \
       --restrict-filenames \
       "$@" \
       -o "%(title)s_(%(uploader)s)_[%(id)s]/%(title)s.%(ext)s"

for D in *; do
    if [ -d "${D}" ]; then
        cd "${D}"
        comments_file="$(find . -iname "*.comments.html")"
        if [ ! -f "$comments_file" ]; then
            json_file="$(find . -iname "*.info.json")"
            file_name="$(echo "$json_file" | sed 's/\.info\.json//').comments.html"
            ytdlp_nest_comments.py -i "$json_file" -o "$file_name"
        fi
        cd ..
    fi
done
