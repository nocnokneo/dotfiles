# ~/.profile: executed by the command interpreter for login shells.
#
# This file is NOT read by bash, if ~/.bash_profile or ~/.bash_login
# exists.
#
# Although not universal, a common convention is for graphical environments to
# source this file upon login (e.g. by /etc/X11/xinit/xinitrc-common). That is
# our hope with this file.

# Source ~/.dotfiles/profile.d/*.sh files
if [ -d ~/.dotfiles/profile.d ]; then
    for sh_file in ~/.dotfiles/profile.d/*.sh; do
        if [ -r "$sh_file" ]; then
            . "$sh_file"
        fi
    done
    unset sh_file
fi
