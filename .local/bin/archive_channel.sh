#!/bin/bash

# archive_channel.sh - a simple channel archiving tool
# Created by svngms 2024-2025
# This script is under the UNLICENSE (https://unlicense.org/)

INVIDIOUS_INSTANCE="https://invidious.pi.lan"

if [ "$#" -ne 1 ]; then
    echo "usage: archive_video.sh [URL]"
    echo "Archive YouTube channels in a sane format"
    exit -1
fi

function conv_comments() {
    for D in *; do
        if [ -d "${D}" ]; then
            cd "${D}"
            comments_file="$(find . -iname "*.comments.html")"
            if [ ! -f "$comments_file" ]; then
                comments_file="$(find . -iname "*.comments.json")"
                info_file="$(find . -iname "*.info.json")"
                file_name="$(echo "$comments_file" | sed 's/\.comments\.json//').comments.html"
                ytdlp_nest_comments.py -c "$comments_file" -i "$info_file" -o "$file_name"
            fi
            cd ..
        fi
    done
}

echo "[ARCCAN] Getting channel name and id..."

channel_name="$(yt-dlp --max-downloads 1 --print '%(channel|Unknown)s' "$1")"
channel_id="$(yt-dlp --max-downloads 1 --print '%(channel_id|Unknown)s' "$1")"
channel_dir="$(echo $channel_name | sed 's/ /_/g')"_"$channel_id"

echo "[ARCCAN] Ah it's \"$channel_dir\"."
echo "[ARCCAN] Downloading video..."

yt-dlp -f "bestvideo[height<=1080]+bestaudio/best" \
       --write-description \
       --write-thumbnail \
       --no-write-playlist-metafiles \
       --embed-chapters \
       --remux-video "mkv" \
       --convert-thumbnails "jpg" \
       --embed-subs \
       --write-subs \
       --write-comments \
       --print-to-file "after_filter:%(comments)j" "%(title)s_(%(uploader)s)_[%(id)s]/%(title)s.comments.json" \
       --parse-meta "video::(?P<comments>)" \
       --no-sponsorblock \
       --write-info-json \
       --restrict-filenames \
       --download-archive "$channel_dir/archive.log" \
       "$1" \
       -o "%(channel)s_%(channel_id)s/videos/%(upload_date)s_%(title)s_[%(id)s]/%(title)s.%(ext)s"

echo "[ARCCAN] Finished downloading video!"
echo "[ARCCAN] Creating comments file(s) for videos..."

cd "$channel_dir/videos"
conv_comments

echo "[ARCCAN] Creating comments file(s) for shorts..."

if [ -d "../shorts" ]; then
    cd "../shorts"
    conv_comments
else
    echo "[ARCCAN] Not needed..."
fi

echo "[ARCCAN] Finished creating comments!"
echo "[ARCCAN] Downloading channel metadata..."

mkdir -p "../channel"
cd "../channel"
curl "$INVIDIOUS_INSTANCE/api/v1/channels/$channel_id" -sko channel.json

echo "[ARCCAN] Downloading channel profile picture and banner (downloading as png but may be different)"

author_pfp="$(jq -r '.authorThumbnails[0].url' channel.json | sed 's/=s32-c-k-c0x00ffffff-no-rj//')"
author_banner="$(jq -r '.authorBanners[0].url' channel.json)"
curl "$author_pfp" -sko profile.png

if [ ! "$author_banner" == "null" ]; then
    curl "$author_banner" -sko banner.png
else
    echo "[ARCCAN] No channel banner..."
fi

echo "[ARCCAN] Finished getting channel metadata!"
echo
echo "[ARCCAN] All done! Enjoy the vids!"
