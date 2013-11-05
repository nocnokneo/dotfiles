#!/bin/bash

# Solution to lack of support for non-NRRD images in "unu join"
function unu-join-images() {
    local tmp_nrrd_list=""

    if [ $# -lt 2 ]
    then
        echo "Usage: unu-join-images OUTPUT_NRRD INPUT_IMG [ INPUT_IMG ... ]"
        echo
        echo "INPUT_IMG can be any format suported by the ImageMagick tool convert."
        return 1
    fi

    joined_nrrd="${1}"
    shift

    for img in "$@"
    do
        local tmp_nrrd=${TMPDIR:-/tmp}/$(basename ${img%.*}).nrrd
        convert ${img} ${tmp_nrrd}
        tmp_nrrd_list+=" ${tmp_nrrd}"
    done
    unset img

    unu join --axis 2 --input ${tmp_nrrd_list} --output ${joined_nrrd}
    status=$?
    rm -f ${tmp_nrrd_list}

    return ${status}
}
