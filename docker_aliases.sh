alias docker-rm-all = 'docker rm `docker ps -qa`'
alias docker-rmi-soft = 'docker rmi `docker images -qa -f dangling=true`'
alias docker-rmi-all = 'docker rmi `docker images -qa`'
alias docker-volume-rm-all = 'docker volume rm `docker volume ls -q`'
