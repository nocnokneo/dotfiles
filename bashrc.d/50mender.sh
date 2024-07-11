
if type mender-cli &>/dev/null; then
    if mender-cli | grep -s 'Configuration file not found' &>/dev/null; then
        echo "{}" > ${HOME}/.mender-clirc
    fi
    . <(mender-cli completion bash 2>/dev/null)
fi
