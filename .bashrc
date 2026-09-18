# .bashrc -- personal config of svngms

# Set some programs
export EDITOR="emacs -nw"
export PAGER="less"

# Custom prompt
function prompt_errno {
    local e=$?
    if [[ e -ne 0 ]]; then
        printf "─[\e[31m%s\e[0m]" "$e"
    fi
}

function prompt_git {
    local branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    local num_of_changes="$(git status -s 2> /dev/null | wc -l)"
    if [[ -n $branch ]]; then
        printf "─["
        if [[ $num_of_changes > 0 ]]; then
            printf "\e[31m"
        else
            printf "\e[32m"
        fi
        printf "%s" "$branch"
        if [[ $num_of_changes > 0 ]]; then
            printf ":%s" "$num_of_changes"
        fi
        printf "\e[0m]"
    fi
}

construct_prompt() {
    EXIT_CODE="$(prompt_errno)"
    TIME="$(date "+%H:%M:%S")"
    GIT_BRANCH="$(prompt_git)"
}
PROMPT_COMMAND=construct_prompt

export PS1='\n┌[${TIME}]─[\w]${GIT_BRANCH}${EXIT_CODE}\n└\$ '

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
export PATH="$HOME/.go/bin:$PATH"    # Go

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
