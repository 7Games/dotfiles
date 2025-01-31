# Just set some programs
export EDITOR="emacs -nw"
export PLAYER="celluloid"
export PAGER="less"

# Custom prompt
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# Some safty features
alias rm="rm -Id"
alias mv="mv -i"
alias cp="cp -i"

# Shortcuts
alias e="$EDITOR"
alias ls="ls --color=always -l"

alias play="mpv --ytdl-raw-options=cookies=\"$HOME/.config/mpv/cookies.txt\" --ytdl-format=\"bestvideo[height<=?1080]+bestaudio/best\""

# The "I can't remember those" aliases
alias encrypt_file="gpg -c --no-symkey-cache --cipher-algo AES256"
alias decrypt_file="gpg --no-symkey-cache"

# Custom scripts/programs directory
export PATH="$HOME/.local/bin:$PATH"

export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

export JAVA_HOME="$HOME/.MAUI/java"
export ANDROID_HOME="$HOME/.MAUI/android"
export ANDROID_SDK_HOME="$HOME/.android"

export ANDROID_HOME=~/.android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

unset HISTFILE
export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
. "$HOME/.cargo/env"
