# Compare version strings. Based on http://stackoverflow.com/a/4024263
vergte() {
    # Arg 1: Version 1 string
    # Arg 2: Version 2 string
    # Returns true if version 1 is greater or equal to version 2
    [  "$1" = "`echo -e "$1\n$2" | sort -rV | head -n1`" ]
}

# Older versions of IPython use different options to get the version
if ipython --version &>/dev/null
then
    ipython_version=$(ipython --version 2>/dev/null)
else
    ipython_version=0
fi

# If an IPython profile called nbserver exists, create an alias called ipynb
# IPython"profile list" command is in 0.13.2 but not in 0.10. Not sure which
# precise version it was introduced.
if  vergte ${ipython_version} 0.13 &&
    ipython profile list 2>/dev/null | grep -q -e '^[ ]*nbserver$'
then
    alias ipynb='ipython notebook --profile=nbserver'
    alias ipyqt='ipython qtconsole'
fi
