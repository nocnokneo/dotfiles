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

# From http://stackoverflow.com/questions/370047/#370255
function path_remove() {
    IFS=:
    # convert it to an array
    t=($PATH)
    unset IFS
    # perform any array operations to remove elements from the array
    t=(${t[@]%%$1})
    IFS=:
    # output the new array
    echo "${t[*]}"
}

# Enable the ccache PATH interceptors if installed
for d in /usr/lib{64,}/ccache; do
    if [ -d ${d} ]; then
        # Don't auto-enable ccache symlinks for now
        # case ":${PATH:-}:" in
        #     *:${d}:*) ;;
        #     *) PATH="${d}${PATH:+:$PATH}" ;;
        # esac

        # Add convenience aliases to enable/disable the ccache PATH interceptors
        # Remove ccache from the PATH (and keep the path clean be removing leading or trailing ":"
        alias ccache-disable='export PATH=$(echo $PATH | sed -e "s,:*'${d}':*,:,g" -e "s/\(^:*\|:*$\)//g")'
        alias ccache-enable='if ! echo $PATH | grep -q '${d}'; then export PATH='${d}':$PATH; fi'

        # We've found a ccache interceptor directory - first one wins, so we're done
        break
    fi
done

# Add a directory to the system PATH.
#  -f or --front to prepend to the front
#  -b or --back to append to the back
function path_add() {
    local append=1
    while (( "$#" )); do
        local arg="$1"
        shift
        
        case "${arg}" in
            -f) append=;  continue ;;
            -b) append=1; continue ;;
        esac

        # Strip trailing /
        local extrapath=${arg%/}

        # Skip directories that don't exist.
        [ ! -d $(readlink -f ${extrapath}) ] && continue

        # Add to PATH avoiding duplicates
        case ":${PATH:-}:" in
            *:${extrapath}:*) ;; # Duplicate - skip
            *)
                if [[ "${append}" ]]; then
                    # Append
                    export PATH="${PATH:+$PATH:}${extrapath}"
                else
                    # Prepend
                    export PATH="${extrapath}${PATH:+:$PATH}"
                fi
        esac
    done
}

# Get the name of the current platform
function platform_dist() {
    if [ -n "${OSTYPE}" ]; then
        echo "${OSTYPE}"
    else
        python -c 'import platform ; print platform.dist()[0]'
    fi
}

# From: http://stackoverflow.com/a/4025065
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

# Compare version strings. Based on http://stackoverflow.com/a/4024263
vergte() {
    # Arg 1: Version 1 string
    # Arg 2: Version 2 string
    # Returns true if version 1 is greater or equal to version 2
    vercomp "$1" "$2"
    [ $? -eq 0 -o $? -eq 1 ]
}
