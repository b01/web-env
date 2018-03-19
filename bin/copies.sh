#!/bin/bash -e

pwd

SSH_DIR=$(echo ~/.ssh)

# Copy SSH keys over to the containers.
if [ -d "${SSH_DIR}" ]; then
    printf "copy ssh keys to apps54\n"
    docker cp ~/.ssh/. centos-apps54:/root/.ssh

    printf "copy ssh keys to apps\n"
    docker cp ~/.ssh/. centos-apps:/root/.ssh

    printf "Changing\n"
    docker exec centos-apps54 "chown" "-R" "root:root" "/root/.ssh/"
    docker exec centos-apps "chown" "-R" "root:root" "/root/.ssh/"
fi

# Copy all applications nginx files into the mapped NginX vhost configuration directory.
printf "Copying NginX configs over to mapped conatiner directory.\n"
cp -v ~/code/*/web-env/*.conf ~/code/nginx-confs/

printf "Restarting NginX service.\n"
docker exec centos-nginx "nginx" "-s" "reload"