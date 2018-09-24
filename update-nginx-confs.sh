#!/bin/sh

set -e

DIR=$( cd "$(dirname ${0})" && pwd)

source $DIR/env.sh

# Copy all applications nginx files into the mapped NginX vhost configuration directory.
printf "Copying NginX configs over to mapped conatiner directory.\n"

if [ -z "$1" ]; then
    printf "Please specify an docker container as the first parameter.\n"
    exit 1
fi

cp -v "${APPS_DIR}"/*/web-env/*.conf "${APPS_DIR}"/nginx-confs/

printf "Restarting NginX service.\n"
docker exec "${1}" nginx -s reload