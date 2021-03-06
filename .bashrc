#!/bin/bash

# -- Set Bash Options

HISTSIZE=100000  # Disk space is cheap
HISTFILESIZE=200000

shopt -s checkwinsize  # Check window size after each command and update LINES
shopt -s histappend    # and COLUMNS if necessary

# -- Path Manipulation
export PATH=$HOME/.local/bin:$PATH

# -- List Directory Colors
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# -- Aliases
if [[ -f $HOME/.bash_aliases ]]; then
    source $HOME/.bash_aliases
fi

# -- Colorize Less Output
LESS_COLOR=$HOME/.local/bin/src-hilite-lesspipe.sh
if [[ -x $LESS_COLOR ]]; then
    export LESSOPEN="| $LESS_COLOR %s"
    export LESS=" -R "
fi

# -- Better Prompt
if [[ -f $HOME/.prompt ]]; then
    source $HOME/.prompt
fi

# Finally, augment everything with whatever is required for EDA tools
if [[ -f $HOME/.toolsrc ]]; then
    source $HOME/.toolsrc
fi

# -- Function Definitions

# Tcl does not have readline support, so wrap it if it's available
tcl () {
    local tclsh=/usr/bin/tclsh
    local rlwrap=/usr/bin/rlwrap
    if [[ -x "$tclsh" && -x "$rlwrap" ]]; then
        "$rlwrap" -c "$tclsh"
    else
        "$tclsh"
    fi
}

# Colorize man pages
# man() {
#     env \
#          LESS_TERMCAP_mb=$(printf "\e[1;31m") \
#          LESS_TERMCAP_md=$(printf "\e[1;31m") \
#          LESS_TERMCAP_me=$(printf "\e[0m") \
#          LESS_TERMCAP_se=$(printf "\e[0m") \
#          LESS_TERMCAP_so=$(printf "\e[1;30;33m") \
#          LESS_TERMCAP_ue=$(printf "\e[0m") \
#          LESS_TERMCAP_us=$(printf "\e[1;32m") \
#          man "$@"
# }
#        LESS_TERMCAP_mb=$(printf "\e[1;31m") \  # Start blinking
#        LESS_TERMCAP_md=$(printf "\e[1;31m") \  # Start bold mode
#        LESS_TERMCAP_me=$(printf "\e[0m") \  # End all mode like so, us, mb, md, and mr
#        LESS_TERMCAP_se=$(printf "\e[0m") \  # End standout mode
#        LESS_TERMCAP_so=$(printf "\e[1;30;33m") \  # Start standout mode
#        LESS_TERMCAP_ue=$(printf "\e[0m") \  # End underline
#        LESS_TERMCAP_us=$(printf "\e[1;32m") \  # Start underline
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}
