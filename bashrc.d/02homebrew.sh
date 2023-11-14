if [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    . /home/linuxbrew/.linuxbrew/etc/bash_completion.d/brew
fi
