# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --human'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

# Some more ls aliases
alias ll='ls -alF --color=auto --human'
alias la='ls -A'
alias l='ls -CF'

# If possible (e.g. with btrfs), perform a lightweight copy, where the data
# blocks are copied only when modified.
alias cp='cp --reflink=auto'

# Disable the GDB startup banner
alias gdb='gdb -quiet'
alias pu=pushd
alias po=popd
alias rl='readlink -f'

# Ignore binary files when grep'ing and enable colorized output
alias grep="grep -I --color=auto"
alias egrep="egrep -I --color=auto"

# Check that which supports the -i option
if which -i &>/dev/null; then
    alias which='alias | which -i'
fi
alias proxy-off='unset http_proxy https_proxy no_proxy'
alias strip-trailing=sed\ -i\ 's/[[:space:]]*$//'
maybe_alias yum-no-proxy-env 'env -u http_proxy -u https_proxy yum' yum
maybe_alias eamacs emacs
maybe_alias emasc emacs
maybe_alias unu teem-unu
maybe_alias octave 'octave --silent' octave
maybe_alias clipboard 'xclip -selection c' xclip

# Enabling this alias will cause difficulty using pip inside a virtualenv
#maybe_alias pip pip-python

maybe_alias trash trash-put
maybe_alias ij /opt/Fiji.app/fiji-linux64

# Simplify common valgrind tool usage
maybe_alias valgrind-callgrind 'valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes' valgrind
maybe_alias valgrind-memcheck  'valgrind --tool=memcheck --leak-check=yes' valgrind

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

function swap() {
    if [ $# -ne 2 ]; then
        echo "Usage: swap FILE1 FILE2" 1>&2
        return 1
    fi
    tmpfile=$(mktemp "$(dirname "$1")/XXXXXX") &&
        mv -f "$1" "$tmpfile" &&
        mv "$2" "$1" &&
        mv "$tmpfile" "$2"
}

function qtcreator() { $(which qtcreator) -client "$@" & }
#function qtcreator() { "${HOME}/Qt/Tools/Preview/Qt Creator 4.11.0-rc1/bin/qtcreator" -client "$@" & }
alias qc=qtcreator

# Run a command in a TTY that looks interactive so that output is automatically colored
# From: https://stackoverflow.com/a/20401674/471839
function faketty() {
    script -qefc "$(printf "%q " "$@")" /dev/null
}

if [[ $OS == Windows_NT ]]; then
    alias reboot="wmic os where Primary=TRUE reboot"
    alias uptime="wmic path Win32_OperatingSystem get LastBootUpTime"
    alias cpuinfo="wmic cpu get caption, deviceid, name, numberofcores, maxclockspeed, status"
    alias diskinfo="wmic diskdrive get Name, Manufacturer, Model, InterfaceType, MediaType, SerialNumber"
fi

# The "ultimate attach". Attaches to a screen session. If the session is
# attached elsewhere, detaches that other display. If no session exists,
# creates one. If multiple sessions exist, uses the first one.
# See: https://kapeli.com/cheat_sheets/screen.docset/Contents/Resources/Documents/index
maybe_alias screen-attach 'screen -dRR' screen

function onedrive-reauth() {
    for conf in onedrive{,-it,-cfd}; do
        confdir=~/.config/${conf}
        echo "Re-login ondrive config: ${confdir} ..."
        onedrive --reauth --confdir ${confdir}
    done
    sleep 2
    systemctl --user status "onedrive*"
}

function decode-uri() {
    echo "$1" | sed 's/%/\\x/g' | xargs -0 printf
}

# Open a SSH Remote VS Code workspace
# See: https://code.visualstudio.com/docs/remote/troubleshooting#_connect-to-a-remote-host-from-the-terminal
rcode() {
    if [[ -z "${1}" ]]; then
        echo "Usage: rcode HOSTNAME [WORKSPACE_PATH]" >&2
        return 1
    fi
    code --folder-uri=vscode-remote://ssh-remote+$1$2
}

_rcode_completion() {
    local cur prev words cword
    _init_completion || return

    # Use the _known_hosts function from bash-completion to complete hostnames
    if [[ $COMP_CWORD -eq 1 ]]; then
        _known_hosts_real "$cur"
    fi
}

# Register the rcode completion function
complete -F _rcode_completion rcode
