# ~/.bashrc: executed by bash(1) for shells that are both interactive AND non-login
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [[ "$OSTYPE" =~ ^darwin ]]; then
    if [ -d ~/.dotfiles/profile.d ]; then
        for sh_file in ~/.dotfiles/profile.d/*.sh; do
            if [ -r $sh_file ]; then
                . $sh_file
            fi
        done
        unset sh_file
    fi
fi

# Source all ~/.bashrc.d/*.sh files
if [ -d ~/.dotfiles/bashrc.d ]; then
    for sh_file in ~/.dotfiles/bashrc.d/*.sh; do
        if [ -r $sh_file ]; then
            . $sh_file
        fi
    done
    unset sh_file
fi
