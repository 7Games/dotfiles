#!/bin/bash

# get_yt_playlists.sh
# Created by svngms 2025
# This script is under the UNLICENSE (https://unlicense.org/)

FF_PROFILE="$HOME/.var/app/app.zen_browser.zen/.zen/vscvyo98.Default (beta)/"

if [ "$#" -lt 1 ]; then
    echo "usage: get_yt_playlists.sh [URL]"
    echo "Download yt playlist metadata"
    exit -1
fi

echo "[ARCPLY] Getting every playlist from channel..."

playlist_ids="$(yt-dlp --flat-playlist --get-id --cookies-from-browser "firefox:$FF_PROFILE" "$1/playlists")"

if [ ! "$(echo $playlist_ids | wc -l)" == 0 ]; then
    for id in $playlist_ids; do
	echo "[ARCPLY] Getting playlist name and id..."

	playlist_name="$(yt-dlp --max-downloads 1 --cookies-from-browser "firefox:$FF_PROFILE" --print '%(playlist_title|Unknown)s' "https://www.youtube.com/playlist?list=$id")"
	playlist_id="$(yt-dlp --max-downloads 1 --cookies-from-browser "firefox:$FF_PROFILE" --print '%(playlist_id|Unknown)s' "https://www.youtube.com/playlist?list=$id")"
	playlist_file="$(echo $playlist_name | sed 's/ /_/g')_(${playlist_id}).playlist.tsv"

	echo "[ARCCAN] Ah it's \"$playlist_file\"."
	yt-dlp --flat-playlist --print "%(id|Unknown)s	%(duration_string|00:00)s	%(view_count|0)s views	%(title|Unknown)s" --cookies-from-browser "firefox:$FF_PROFILE" "https://www.youtube.com/playlist?list=$id" > "$playlist_file"
    done
else
    echo "[ARCPLY] No playlists found..."
fi

echo "[ARCPLY] Finished getting playlists!"
echo
echo "[ARCPLY] All done!"
