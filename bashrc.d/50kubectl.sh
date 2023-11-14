if which kubectl &>/dev/null; then
    source <(kubectl completion bash)
    if command -v kubecolor &>/dev/null; then
        alias k=kubecolor
        complete -o default -F __start_kubectl kubecolor
    else
        alias k=kubectl
    fi
    complete -o default -F __start_kubectl k

    # short alias to set/show context/namespace
    # Based on: https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration
    kx() {
        [ "$1" ] && kubectl config use-context "$1" || kubectl config get-contexts
    }
    kn() {
        # $1 can be empty to unset the namespace
        [ "${1+x}" ] && kubectl config set-context --current --namespace "$1" || kubectl config view --minify | grep namespace | cut -d" " -f6
    }
fi
