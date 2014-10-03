# Improvemnents for the interactive Python console
if [ -f ~/.pythonstartup ]; then
    export PYTHONSTARTUP=~/.pythonstartup
fi

# Cache pip package downloads
export PIP_DOWNLOAD_CACHE=~/.cache/pip
