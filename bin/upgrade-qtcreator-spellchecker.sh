#!/bin/bash

set -e

QTCREATOR_DIR=${HOME}/Qt/Tools/QtCreator

echo -e "Download the latest version of SpellChecker-Plugin into ~/Downloads\n\n  https://github.com/CJCombrink/SpellChecker-Plugin/releases/\n"
read -sp "Press enter when ready."
echo -e "\n"
package=$(find ~/Downloads/ -type f -name 'SpellChecker-Plugin_*' | xargs --no-run-if-empty ls -t | head -n1)
echo "Installing ${package} into ${QTCREATOR_DIR}"
tar -C ${QTCREATOR_DIR} --strip-components=1 -xf ${package}
echo Done.
