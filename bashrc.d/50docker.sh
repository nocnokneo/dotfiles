for ociruntime in docker podman; do
    alias ${ociruntime}-rm-exited="${ociruntime} ps -q -f status=exited | xargs --no-run-if-empty ${ociruntime} rm"
    alias ${ociruntime}-rmi-dangling="${ociruntime} images -qf dangling=true | xargs --no-run-if-empty ${ociruntime} rmi"
done
