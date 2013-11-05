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

case ":${PATH:-}:" in
    *:/usr/lib64/ccache:*) ;;
    *) PATH="/usr/lib64/ccache${PATH:+:$PATH}" ;;
esac

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

function platform_dist() {
  python -c 'import platform ; print platform.dist()[0]'
}
