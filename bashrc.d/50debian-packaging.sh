# Variables for dh_* scripts, dch, debuild, etc...
export DEBEMAIL="taylor@braun-jones.org"
export DEBFULLNAME="Taylor Braun-Jones"

# Handy shortcut for using quilt within a debian source package tree. Usage:
#
# $ mkdir debian/patches
# $ dquilt new <patch-name>.patch
# $ dquilt add <broken-file> [...]
# ... GO FIX <broken-file>
# $ dquilt refresh
# $ dquilt header -e
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
