#!/usr/bin/bash

# launch_emacs.sh - launch, create, and kill emacs daemons
# Created by svngms 2024-2025
# This script is under the UNLICENSE (https://unlicense.org/)

server_socket_path="/run/user/$(id -u)/emacs"
servers="$(find $server_socket_path -mindepth 1 | rev | cut -d'/' -f1 | rev)"
dmenu="wofi --show dmenu"

function run_emacs() {
    wanted_server="$(echo "$servers" | wofi --show dmenu --prompt="Select a server to launch...")"
    
    if echo "$servers" | grep -q "^$wanted_server$"; then
        emacsclient -cs "$wanted_server" & disown
    else
        emacs --daemon="$wanted_server"
        emacsclient -cs "$wanted_server" & disown
    fi
}

function kill_emacs() {
    wanted_server="$(echo "$servers" | $dmenu --prompt="Select a server to kill...")"

    if echo "$servers" | grep -q "^$wanted_server$"; then
        emacsclient -s "$wanted_server" -e '(kill-emacs)'
    else
        echo "That server doesn't exist!"
        exit 1
    fi
}

if [ "$1" = "-k" ] || [ "$1" = "--kill" ]; then
    kill_emacs
else
    run_emacs
fi
