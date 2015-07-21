# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 0022

# set PATH so it includes user's private bin if it exists
if [ -d ${HOME}/.local/bin ] ; then
    export PATH="${HOME}/.local/bin:$PATH"
fi

# set EDITOR to the best editor we can find on the system
preferred_editors="emacs"
# gedit will suffice if we have a graphical display
[ ! -z $DISPLAY ] && preferred_editors="${preferred_editors} gedit"
preferred_editors="${preferred_editors} nano pico vim vi"

# TODO Preferred editor for OS X? subl?
#if [[ ! "$SSH_TTY" && "$OSTYPE" =~ ^darwin ]]; then
#    ...
#fi
export EDITOR=$(type ${preferred_editors} 2>/dev/null | sed 's/ .*$//;q')
export VISUAL="$EDITOR"

# Use the ~/.forward address for MAILTO
if [ -r ~/.forward ]; then
    export MAILTO=`cat ~/.forward`
else
    export MAILTO=taylor@braun-jones.org
fi
export EMAIL=$MAILTO
