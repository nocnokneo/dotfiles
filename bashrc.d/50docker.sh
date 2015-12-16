alias docker-rm-exited="docker ps -q -f status=exited | xargs --no-run-if-empty docker rm"
alias docker-rmi-dangling="docker images -qf dangling=true | xargs --no-run-if-empty docker rmi"
