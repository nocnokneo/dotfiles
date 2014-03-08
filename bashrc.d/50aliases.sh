# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

# Some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Disable the GDB startup banner
alias gdb='gdb -quiet'
alias pu=pushd
alias po=popd
alias rl='readlink -f'
# Check that which supports the -i option
if which -i &>/dev/null; then
    alias which='alias | which -i'
fi
alias proxy-off='unset http_proxy https_proxy no_proxy'
alias strip-trailing=sed\ -i\ 's/[[:space:]]*$//'
maybe_alias yum-no-proxy-env 'env -u http_proxy -u https_proxy yum' yum
maybe_alias xo xdg-open
maybe_alias eamacs emacs
maybe_alias emasc emacs
maybe_alias unu teem-unu
maybe_alias octave 'octave --silent' octave

# Enabling this alias will cause difficulty using pip inside a virtualenv
#maybe_alias pip pip-python

maybe_alias trash trash-put
maybe_alias ij /opt/Fiji.app/fiji-linux64

# Simplify common valgrind tool usage
maybe_alias valgrind-callgrind 'valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes' valgrind
maybe_alias valgrind-memcheck  'valgrind --tool=memcheck --leak-check=yes' valgrind

# Remove ccache from the PATH (and keep the path clean be removing leading or trailing ":"
maybe_alias ccache-disable \
    'export PATH=$(echo $PATH | sed -e "s,:*/usr/lib64/ccache:*,:,g" -e "s/\(^:*\|:*$\)//g")' \
    ccache
maybe_alias ccache-enable \
    'if ! echo $PATH | grep -q /usr/lib64/ccache; then export PATH=$PATH:/usr/lib64/ccache; fi' \
    ccache

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --expire-time 4000 --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Check that dmesg on this box supports -T option
if dmesg -T &>/dev/null
then
    # Color the date (;34 for blue)
    alias colordmesg="dmesg -T|sed -e 's|\(^.*'`date +%Y`']\)\(.*\)|\x1b[0;34m\1\x1b[0m - \2|g'"
fi

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# Ignore binary files when grep'ing and enable colorized output
export GREP_OPTIONS="-I --color=auto"
