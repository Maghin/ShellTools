alias docker_rm_all='docker rm `docker ps -qa`'
alias docker_rmi_soft='docker rmi `docker images -qa -f dangling=true`'
alias docker_rmi_all='docker rmi `docker images -qa`'
alias docker_volume_rm_all='docker volume rm `docker volume ls -q`'

alias docker_clean_all='docker_rm_all ; docker_rmi_all ; docker_volume_rm_all'
