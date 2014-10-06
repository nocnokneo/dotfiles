# ~/.bash_profile: executed by bash for login shells

# Anything we do for a interactive non-login shell we also want for an
# interacive login shell.
[ -r ~/.bashrc ] && . ~/.bashrc

test -r /sw/bin/init.sh && . /sw/bin/init.sh
