for ociruntime in docker podman; do
    alias ${ociruntime}-rm-exited="${ociruntime} ps -q -f status=exited | xargs --no-run-if-empty ${ociruntime} rm"
    alias ${ociruntime}-rmi-dangling="${ociruntime} images -qf dangling=true | xargs --no-run-if-empty ${ociruntime} rmi"
    alias ${ociruntime}-cleanup="${ociruntime} system prune --filter 'until=24h'"
done

if type podman-compose &> /dev/null && ! type docker-compose &> /dev/null; then
    alias docker-compose=podman-compose
fi
