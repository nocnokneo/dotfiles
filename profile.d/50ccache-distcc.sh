# Force ccache dir to be CPU-specific (or at least architecture-specific)
unset CCACHE_DIR CCACHE_UMASK
# If we have gcc, use it to find out the CPU type so that the ccache objects
# `-march=native` are portable accross machines. If we don't have gcc, at
# least make the ccache architecture-specific.
arch=$(uname -m)
cpu=unknown
if type -p gcc &>/dev/null; then
    cpu=$(gcc -march=native -Q -v --help=target 2>/dev/null | awk '/ *-march=/ {print $2;}')
fi
export CCACHE_DIR=${HOME}/.ccache/${arch}_${cpu}
mkdir -p ${CCACHE_DIR}

# Automatically use ccache and distcc for all gcc/cc/g++/etc... builds
#export PATH="/usr/lib/ccache:$PATH"
#export CCACHE_PREFIX=distcc

# A different .distcc directory for each host is needed when used shared a NFS
# home
export DISTCC_DIR=${HOME}/.distcc-`hostname`
