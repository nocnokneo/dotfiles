alias docker-rm-exited="docker ps -q -f status=exited | xargs docker rm"
alias docker-rmi-dangling="docker images -qf dangling=true | xargs docker rmi"
