#!/bin/bash

yt-dlp -x \
    --audio-format mp3 \
    -f "bestaudio" \
    --embed-thumbnail \
    --convert-thumbnail jpg \
    --exec-before-download "ffmpeg -i %(thumbnails.-1.filepath)q -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\" _%(thumbnails.-1.filepath)q" \
    --exec-before-download "rm %(thumbnails.-1.filepath)q" \
    --exec-before-download "mv _%(thumbnails.-1.filepath)q %(thumbnails.-1.filepath)q" \
    --parse-metadata "title:%(title)s" \
    --embed-metadata \
    --output "%(artist)s - %(title)s.%(ext)s" \
    "$1"
