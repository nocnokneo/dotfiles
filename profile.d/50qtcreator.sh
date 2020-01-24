# Add Qt Creator from the Qt binary installer to the end of the path so the
# system-installed Qt Creator takes precedence if it exists
if [ -x ${HOME}/Qt/Tools/QtCreator/bin/qtcreator ]; then
    export PATH=${PATH}:${HOME}/Qt/Tools/QtCreator/bin
fi
