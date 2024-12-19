if [ -e ${HOME}/.pixi/bin ]; then
    export PATH=${HOME}/.pixi/bin:$PATH
fi
eval "$(pixi completion --shell bash)"
