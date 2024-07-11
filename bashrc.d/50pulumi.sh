# add Pulumi to the PATH
if [ -x "${HOME}/.pulumi/bin/pulumi" ]; then
    export PATH="$PATH:${HOME}/.pulumi/bin"
fi

if type pulumi &>/dev/null; then
    PULUMI_SKIP_UPDATE_CHECK=1 . <(pulumi gen-completion bash)
fi
