#!/bin/bash

set -eo pipefail

image_name="${1?Must provide image name}"

# Get the digest of the latest tag
latest_digest=$(skopeo inspect docker://${image_name}:latest | jq -r '.Digest')

# List all tags
tags=$(skopeo list-tags docker://${image_name} | jq -r '.Tags[]')

echo "Tags for '${image_name}' with the same digest as 'latest':"

# Loop through each tag and compare the digest
for tag in $tags; do
    tag_digest=$(skopeo inspect docker://${image_name}:${tag} | jq -r '.Digest')
    if [ "$tag_digest" = "$latest_digest" ]; then
        echo $tag
    fi
done
