# .bashrc -- personal config of svngms

# Set some programs
export EDITOR="emacs -nw"
export PAGER="less"

# Custom prompt
function ps1_exit {
    local e=$?
    if [[ e -ne 0 ]]; then
        printf "─[\e[31m%s\e[0m]" "$e"
    fi
}

ps1_save() {
    EXIT_CODE=$(ps1_exit)
    TIME="$(date "+%H:%M:%S")"
}
PROMPT_COMMAND=ps1_save

export PS1='\n┌[${TIME}]─[\w]${EXIT_CODE}\n└\$ '

# Some safty features
alias rm="rm -Id"
alias mv="mv -i"
alias cp="cp -i"

# Shortcuts
alias e="$EDITOR"
alias ls="ls --color=always -l"

alias play="mpv --config-dir=$HOME/.config/mpv/yt"

# Change the path
export PATH="$HOME/.local/bin:$PATH" # Scripts
export PATH="$HOME/.cargo/bin:$PATH" # Rust

# I forgot what this is but I'm not removing it for fear of breaking something
export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"

# Display some fun stuff at start up

# Miku's birthday!
if [[ $(date +%m-%d) == "08-31" ]]; then
    echo -e "\e[94m\e[1m\e[4mHAPPY BIRTHDAY MIKU!!!\e[0m"
    echo -e "
   \e[5m\e[93m☆☆☆☆☆☆☆☆☆\e[0m
  ╭┻┻┻┻┻┻┻┻┻╮
  ┃╱╲╱╲╱╲╱╲╱┃
 ╭┻━━━━━━━━━┻╮
 ┃╱╲╱╲╱╲╱╲╱╲╱┃
 ┗━━━━━━━━━━━┛"
else
    fortune | cowsay -f ~/.dotfiles/fun/miku.cow -W 100 | lolcat
fi
