#!/bin/bash

# archive_video.sh - a simple video archiving tool
# Created by svngms 2024-2025
# This script is under the UNLICENSE (https://unlicense.org/)

if [ "$#" -lt 1 ]; then
    echo "usage: archive_video.sh [OPTION...] [URL]"
    echo "Archive YouTube videos in a sane format"
    echo
    echo -e " -i\tRe-download info file/comments"
    exit -1
fi

yt_dlp_args=(
    --write-comments
    --print-to-file "after_filter:%(comments)j" "%(title)s_(%(uploader)s)_[%(id)s]/%(title)s.comments.json"
    --parse-meta "video::(?P<comments>)"
    -f "bestvideo[height<=1080]+bestaudio/best"
    --write-description
    --write-thumbnail
    --convert-thumbnails "jpg"
    --write-info-json
    --restrict-filenames
    -o "%(title)s_(%(uploader)s)_[%(id)s]/%(title)s.%(ext)s"
)

if [ "$1" == "-i" ]; then
    echo "[ARCVID] Downloading data..."
    yt-dlp "${yt_dlp_args[@]}" \
     --skip-download \
     "$2"
else
    echo "[ARCVID] Downloading video and data..."
    yt-dlp "${yt_dlp_args[@]}" \
     --embed-chapters \
     --remux-video "mkv" \
     --embed-subs \
     --write-subs \
     "$1"
fi

echo "[ARCVID] Finished downloading video!"
echo "[ARCVID] Creating comments file(s) for videos..."

for D in *; do
    if [ -d "${D}" ]; then
        cd "${D}"
        comments_file="$(find . -iname "*.comments.html")"
        if [ "$1" == "-i" ] || [ ! -f "$comments_file" ]; then
            comments_file="$(find . -iname "*.comments.json")"
            info_file="$(find . -iname "*.info.json")"
            file_name="$(echo "$comments_file" | sed 's/\.comments\.json//').comments.html"
            ytdlp_nest_comments.py -c "$comments_file" -i "$info_file" -o "$file_name"
        fi
        cd ..
    fi
done

echo "[ARCVID] Finished creating comments file(s) for videos!"
echo "[ARCVID] All done! Enjoy the vid!"
