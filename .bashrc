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

# The "I can't remember those" aliases
alias encrypt_file="gpg -c --no-symkey-cache --cipher-algo AES256"
alias decrypt_file="gpg --no-symkey-cache"

# Custom scripts/programs directory
export PATH="$HOME/.local/bin:$PATH"

unset HISTFILE
