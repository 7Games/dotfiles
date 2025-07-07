#!/bin/bash

if [ -f "$1" ]; then
    yt-dlp -f "bestvideo[height<=1080]+bestaudio/best" \
       --write-description \
       --write-thumbnail \
       --embed-chapters \
       --remux-video "mkv" \
       --convert-thumbnails "jpg" \
       --embed-subs \
       --write-subs \
       --write-comments \
       --no-sponsorblock \
       --write-info-json \
       --restrict-filenames \
       -a "$1" \
       -o "%(title)s_(%(uploader)s)_[%(id)s]/%(title)s.%(ext)s"
else
    yt-dlp -f "bestvideo[height<=1080]+bestaudio/best" \
       --write-description \
       --write-thumbnail \
       --embed-chapters \
       --remux-video "mkv" \
       --convert-thumbnails "jpg" \
       --embed-subs \
       --write-subs \
       --write-comments \
       --no-sponsorblock \
       --write-info-json \
       --restrict-filenames \
       "$@" \
       -o "%(title)s_(%(uploader)s)_[%(id)s]/%(title)s.%(ext)s"
fi


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
