# Color prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '

# History expansions will be verified before execution.
#shopt -s histverify

# autocd shell option introduced in bash 4.0
if vergte ${BASH_VERSION} 4; then
    # automatically prepend 'cd ' when entering just a directory path
    shopt -s autocd
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
elif [ -x /usr/bin/lesspipe.sh ]; then
    export LESSOPEN='|/usr/bin/lesspipe.sh %s'
elif [ -x /opt/local/bin/lesspipe.sh ]; then
    export LESSOPEN='| /opt/local/bin/lesspipe.sh %s'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}
