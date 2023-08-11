# Make ccache compliant with the XDG Base Directory Specification
export CCACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/ccache

export CCACHE_MAXSIZE=50G

# Make the ccache objects CPU-specific by including /proc/cpuinfo when hashing
# input files. This is necessary for objects compiled with `-march=native`
# TODO: Find alternative solution since this file can change dynamically (e.g.
# the `cpu MHz` field)
#export CCACHE_EXTRAFILES=/proc/cpuinfo

# Automatically use ccache and distcc for all gcc/cc/g++/etc... builds
#export PATH="/usr/lib/ccache:$PATH"
#export CCACHE_PREFIX=distcc

# A different .distcc directory for each host is needed when used shared a NFS
# home
export DISTCC_DIR=${HOME}/.distcc-`hostname`
mkdir -p ${DISTCC_DIR}
