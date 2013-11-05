# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source all ~/.bashrc.d/*.sh files
if [ -d ~/.dotfiles/bashrc.d ]; then
    for sh_file in ~/.dotfiles/bashrc.d/*.sh; do
        if [ -r $sh_file ]; then
            . $sh_file
        fi
    done
    unset sh_file
fi
