#!/bin/bash -e

DIR=$( cd "$( dirname "$0" )" && pwd )
CWD=$(pwd)

"${DIR}"/build-env.sh

source "${DIR}"/utilities.sh

if [ ! -f "apps.env" ]; then
    printf "Could not find an apps.env file in ${CWD}\n"
    exit 1
fi

#docker-compose --project-name=web_env up -d --no-recreate --remove-orphans
DOCKER_COMPOSE_CMD='docker-compose --project-name=web_env up --no-recreate --remove-orphans'

printf "Starting web Docker environment in a new terminal Window.\n"
new_tab "WebEnv Monitor" "cd ${CWD} && ${DOCKER_COMPOSE_CMD}"
