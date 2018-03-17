#!/bin/bash -e

if [[ -f "~/.ssh/" ]]; then
    docker cp ~/.ssh/. centos-apps54:/root/.ssh
fi

docker exec centos-apps54 "chown" "-R" "root:root" "/root/.ssh/"
