#!/usr/bin/env python3

"""
Forked and modified from pukkandan/ytdlp_nest_comments.py:
https://gist.github.com/pukkandan/ee737fec64822f2552caf3ca4cbf5db7
which included this license and copyright information:
"SPDX-License-Identifier: MIT https://opensource.org/licenses/MIT
Copyright © 2021 pukkandan.ytdlp@gmail.com"

Convert YouTube comments from an info.json file (acquired via
`yt-dlp --write-comments`) to HTML.
"""

import os.path
import json
import argparse
import logging
from datetime import datetime, timezone
import html

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')


def get_fields(dct, arr):
    for name, fn in arr.items():
        val = fn(dct, name)
        if val is not None:
            yield name, val


def filter_comments(comments):
    return [dict(get_fields(c, COMMENT_FIELDS)) for c in comments]


def get_video_data(video):
    return dict(get_fields(video, VIDEO_FIELDS))


COMMENT_FIELDS = {
    'text': dict.get,
    'author': dict.get,
    'author_id': dict.get,
    'author_thumbnail': dict.get,
    'timestamp': lambda dct, name: dct.get(name) and datetime.fromtimestamp(dct.get(name), timezone.utc).strftime('%Y-%m-%d'),
    'like_count': lambda dct, name: str(dct.get(name)),
    'is_favorited': lambda dct, name: "♥️" if dct.get(name) else "",
    'is_pinned': lambda dct, name: "🧷" if dct.get(name) else "",
    'author_is_uploader': lambda dct, name: "(author is uploader)" if dct.get(name) else "",
    # Add more fields here
    'replies': lambda dct, name: filter_comments(dct.get(name, [])) or None
}


VIDEO_FIELDS = {
    'title': dict.get,
    'id': dict.get,
    'uploader': dict.get,
    'uploader_id': dict.get,
    'view_count': lambda dct, name: str(dct.get(name)),
    'like_count': lambda dct, name: str(dct.get(name)),
    'timestamp': lambda dct, name: dct.get('timestamp') and datetime.fromtimestamp(dct.get('timestamp'), timezone.utc).strftime('%Y-%m-%d %H:%M:%S')
}


parser = argparse.ArgumentParser()
parser.add_argument(
    '--comment-input-file', '-c',
    dest='commentfile', metavar='FILE', required=True,
    help='File to read comments from (comments.json)')
parser.add_argument(
    '--info-input-file', '-i',
    dest='infofile', metavar='FILE', required=True,
    help='File to read video metadata from (info.json)')
parser.add_argument(
    '--output-file', '-o',
    dest='outputfile', metavar='FILE', required=True,
    help='File to write comments to (html)')
args = parser.parse_args()

ext = os.path.splitext(args.outputfile)[1][1:]
if ext != 'html':
    raise SystemExit(f'ERROR: Only html format is supported, not {ext}')

logging.info('Reading comments file')
try:
    with open(args.commentfile, encoding='utf-8') as f:
        comments_dict = json.load(f)
except FileNotFoundError:
    logging.error(f'File {args.commentfile} not found')
    raise
except json.JSONDecodeError:
    logging.error(f'Error decoding JSON from file {args.commentfile}')
    raise
logging.info('Reading info file')
try:
    with open(args.infofile, encoding='utf-8') as f:
        info_dict = json.load(f)
except FileNotFoundError:
    logging.error(f'File {args.infofile} not found')
    raise
except json.JSONDecodeError:
    logging.error(f'Error decoding JSON from file {args.infofile}')
    raise

comment_data = {c['id']: c for c in sorted(
    comments_dict, key=lambda c: c.get('timestamp') or 0)}
count = len(comments_dict)
nested_comments = []
for i, (cid, c) in enumerate(comment_data.items(), 1):
    logging.info(f'Processing comment {i}/{count}')
    parent = nested_comments if c['parent'] == 'root' else comment_data[c['parent']].setdefault('replies', [])
    parent.append(c)

nested_comments = filter_comments(nested_comments)
video = get_video_data(info_dict)

logging.info('Converting to html')


def wrap_html(comment_data, video_data, top_level=True):
    html_content = '<ul>'
    for comment in comment_data:
        author = html.escape(comment.get("author", "Anonymous"))
        author_id = comment.get("author_id", "")
        author_thumbnail = comment.get("author_thumbnail", "").replace('=s88-c-k-c0x00ffffff-no-rj', '')  # Makes the pfp bigger
        author_is_uploader = comment.get("author_is_uploader", False)
        text = html.escape(comment["text"]).replace('\n', '<br>')  # Convert newlines to <br>
        timestamp = html.escape(comment.get("timestamp", ""))
        like_count = html.escape(comment.get("like_count", ""))
        is_favorited = html.escape(comment.get("is_favorited", ""))
        is_pinned = html.escape(comment.get("is_pinned", ""))

        html_content += '<li><div class="comment-box">'
        html_content += f'<p><a href="{author_thumbnail}" title="Link to profile picture">👤</a>'
        html_content += f'{"&nbsp;<abbr title=\"Commenter is the uploader\">✒️</abbr>" if author_is_uploader else ""}'
        html_content += f'&nbsp;<a href="https://youtube.com/channel/{author_id}">{author}</a>'
        html_content += f'&nbsp;<abbr title="Pinned by uploader">{is_pinned}</abbr>'
        html_content += f'<div class="comment-text">{text}</div></p>'  # Wrap text in div with a class for styling
        html_content += f'<p><small>{timestamp}'
        html_content += f'&nbsp;-&nbsp;<abbr title="{like_count} likes">👍 {like_count}</abbr>'
        html_content += f'&nbsp;<abbr title="Favorited by uploader">{is_favorited}</abbr></small></p>'
        if 'replies' in comment and comment['replies']:
            html_content += wrap_html(comment['replies'], video_data, top_level=False)
        html_content += '</div></li>'
    html_content += '</ul>'

    if top_level:
        title = html.escape(video_data.get("title", "Video"))
        video_id = html.escape(video_data.get("id", ""))
        uploader = html.escape(video_data.get("uploader", ""))
        uploader_id = html.escape(video_data.get("uploader_id", ""))
        view_count = html.escape(video_data.get("view_count", ""))
        like_count = html.escape(video_data.get("like_count", ""))
        timestamp = html.escape(video_data.get("timestamp", ""))

        style = '''
        <style>
            body {
                width: 98%;
            }
            .comment-box {
                border: 1px solid #ccc;
                padding: 10px;
            }
            abbr {
                cursor: default;
                text-decoration: none;
            }
            a {
                color: black;
                text-decoration: none;
                font-weight: bold;
            }
            a:hover {
                text-decoration: underline;
            }
            .smol {
                color: #888;
                font-size: 13px;
                font-weight: normal;
            }
            .comments ul {
                list-style-type: none;
                padding-left: 20px;
            }
            .comment-text {
                width: 100%;
                overflow-wrap: break-word;
                white-space: pre-wrap; /* Preserve whitespace and line breaks */
            }
            @media (prefers-color-scheme: dark) {
                body {
                    background-color: #121212;
                    color: #e0e0e0;
                }
                .comment-box {
                    border-color: #444;
                }
            }
        </style>
        '''
        meta = '<meta charset="UTF-8">'
        video_data = ""
        video_data += f'<h2><a href="https://youtu.be/{video_id}">{title}</a></h2>'
        video_data += f'<h3>by <a href="https://youtube.com/channel/{uploader_id}">{uploader}</a></h3>'
        video_data += f'<p>Uploaded <strong>{timestamp}</strong></p>'
        video_data += f'<p><strong>{view_count}</strong> views - <strong>{like_count}</strong> likes</p>'
        video_data += '<hr>'
        video_data += '<h2>Comments:-</h2>'
        return f'{meta}{style}{video_data}<div class="comments">{html_content}</div>'
    return html_content


out = wrap_html(nested_comments, video)

logging.info('Writing file')
try:
    with open(args.outputfile, 'w', encoding='utf-8') as f:
        f.write(out)
    logging.info('Done')
except IOError as e:
    logging.error(f'Error writing to file {args.outputfile}: {e}')
    raise
