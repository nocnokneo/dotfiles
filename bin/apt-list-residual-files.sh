#!/bin/bash

set -eo pipefail

# From: https://askubuntu.com/a/1388156/19189
apt-cache show '?config-files' | grep -oP '^Package: \K(.*)$' | uniq | while read -r pkg; do
    dpkg-query -W --showformat "\${binary:Package}:\n\${db-fsys:Files}" "${pkg}"
    if [[ -e /var/lib/dpkg/info/${pkg}.postrm ]]; then
        echo " postrm:"
        sed 's/^/  /' /var/lib/dpkg/info/${pkg}.postrm
    fi
done
