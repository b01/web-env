#!/bin/bash -e

if [[ -f "~/.ssh/" ]]; then
    docker cp ~/.ssh/. centos-apps54:/root/.ssh
    docker cp ~/.ssh/. centos-apps:/root/.ssh
fi

docker exec centos-apps54 "chown" "-R" "root:root" "/root/.ssh/"
docker exec centos-apps "chown" "-R" "root:root" "/root/.ssh/"
