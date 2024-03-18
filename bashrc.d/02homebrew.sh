if [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "MANPATH=$(manpath); $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    . /home/linuxbrew/.linuxbrew/etc/bash_completion.d/brew
fi
