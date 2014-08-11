for ant in /opt/apache-ant*/bin/ant; do
    if [ -x ${ant} ]; then
        bindir=$(dirname ${ant})
        PATH=${PATH}:${bindir}
        ANT_HOME=$(dirname ${bindir})
        break
    fi
done
export PATH ANT_HOME
