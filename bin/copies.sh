#!/bin/bash -e

pwd

# Copy SSH keys over to the containers.
if [[ -f "~/.ssh/" ]]; then
    docker cp ~/.ssh/. centos-apps54:/root/.ssh
    docker cp ~/.ssh/. centos-apps:/root/.ssh
fi

docker exec centos-apps54 "chown" "-R" "root:root" "/root/.ssh/"
docker exec centos-apps "chown" "-R" "root:root" "/root/.ssh/"

# Copy all applications nginx files into the mapped NginX vhost configuration directory.
cp ~/code/*/web-env/*.conf ~/code/nginx-confs/
docker exec centos-apps "nginx" "-s" "reload"