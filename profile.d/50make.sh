if [[ ${OSTYPE} =~ ^darwin ]]; then
    export MAKEFLAGS=-j`sysctl -n hw.ncpu`
else
    export MAKEFLAGS=-j`grep -i -c ^processor /proc/cpuinfo`
fi
