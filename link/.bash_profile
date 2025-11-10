# ~/.bash_profile: executed by bash for login shells

# Source .profile for environment setup (PATH, etc.)
[ -r ~/.profile ] && . ~/.profile

# Anything we do for an interactive non-login shell we also want for an
# interactive login shell.
[ -r ~/.bashrc ] && . ~/.bashrc

test -r /sw/bin/init.sh && . /sw/bin/init.sh
