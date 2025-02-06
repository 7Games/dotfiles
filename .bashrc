# Just set some programs
export EDITOR="emacs -nw"
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

alias encrypt_file="gpg -c --no-symkey-cache --cipher-algo AES256"
alias decrypt_file="gpg --no-symkey-cache"

alias play="mpv --ytdl-raw-options=cookies=\"$HOME/.config/mpv/cookies.txt\" --ytdl-format=\"bestvideo[height<=?1080]+bestaudio/best\""

# Custom scripts/programs directory
export PATH="$HOME/.local/bin:$PATH"

# idk
unset HISTFILE
export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
. "$HOME/.cargo/env"

# dotnet shit
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export ANDROID_HOME=$HOME/.MAUI/Android
export JAVA_HOME=$HOME/.MAUI/jdk
export ANDROID_SDK_HOME=$HOME/.MAUI
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/11.0/bin
