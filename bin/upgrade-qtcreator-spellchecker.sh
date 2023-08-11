#!/bin/bash

set -e

qtcreator_version=$(qtcreator -version 2>&1 | egrep '^Qt Creator ' | egrep -o '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)

PLUGIN_DIR=${HOME}/.local/share/data/QtProject/qtcreator/plugins/${qtcreator_version}
mkdir -p ${PLUGIN_DIR}

echo -e "Download the latest version of SpellChecker-Plugin for Qt Creator ${qtcreator_version} into ~/Downloads\n\n  https://github.com/CJCombrink/SpellChecker-Plugin/releases/\n"
read -sp "Press enter when ready."
echo -e "\n"
package=$(find ~/Downloads/ -type f -name 'SpellChecker-Plugin_*' | xargs --no-run-if-empty ls -t | head -n1)
echo "Installing ${package} into ${PLUGIN_DIR}"
tar -C ${PLUGIN_DIR} --strip-components=1 -xf ${package}
echo Done.
