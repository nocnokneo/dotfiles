# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# Source ~/.bashrc if running bash
[ -n "$BASH_VERSION" -a -r ~/.bashrc ] && . ~/.bashrc

# Source ~/.dotfiles/profile.d/*.sh files
if [ -d ~/.dotfiles/profile.d ]; then
    for sh_file in ~/.dotfiles/profile.d/*.sh; do
        if [ -r $sh_file ]; then
            . $sh_file
        fi
    done
    unset sh_file
fi
