# From https://github.com/httpie/cli/blob/master/extras/httpie-completion.bash
_http_complete() {
    local cur_word=${COMP_WORDS[COMP_CWORD]}
    local prev_word=${COMP_WORDS[COMP_CWORD - 1]}

    if [[ "$cur_word" == -* ]]; then
        _http_complete_options "$cur_word"
    fi
}

complete -o default -F _http_complete http httpie.http httpie.https https

_http_complete_options() {
    local cur_word=$1
    local options="-j --json -f --form --pretty -s --style -p --print
    -v --verbose -h --headers -b --body -S --stream -o --output -d --download
    -c --continue --session --session-read-only -a --auth --auth-type --proxy
    --follow --verify --cert --cert-key --timeout --check-status --ignore-stdin
    --help --version --traceback --debug --raw"
    COMPREPLY=( $( compgen -W "$options" -- "$cur_word" ) )
}

# From https://httpie.io/docs/cli/redirected-output
function httpless {
    # `httpless example.org'
    http --pretty=all --print=hb "$@" | less -R;
}
