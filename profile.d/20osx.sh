# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
