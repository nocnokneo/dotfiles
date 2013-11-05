# Only add an alias if the required executable exists. Usage:
#   maybe_add_alias alias command [executable]
# 'executable' defaults to 'command' (the common case)
function maybe_alias() {
    local alias=${1}
    local command="${2}"
    local executable=${3:-${2}}
    if type "${executable}" &>/dev/null; then
        alias ${alias}="${command}"
    fi
}
