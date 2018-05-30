#!/bin/bash -e

DIR=$( cd "$( dirname "$0" )" && pwd )
CWD=$(pwd)
package="start.sh"

source "${DIR}"/utilities.sh
source "${DIR}"/flags.sh

"${DIR}"/build-env.sh

#docker-compose --project-name=web_env up -d --no-recreate --remove-orphans
DOCKER_COMPOSE_CMD='docker-compose --project-name=web_env up --no-recreate --remove-orphans'

if [ -n "${dcFile}" ]; then
    DOCKER_COMPOSE_CMD="docker-compose -f ${dcFile} --project-name=web_env up --no-recreate --remove-orphans"
fi

printf "Starting web Docker environment in a new terminal Window.\n"
new_tab "WebEnv Monitor" "cd ${CWD} && ${DOCKER_COMPOSE_CMD}"

# Run copies command on container(s) passed in to cname variable.
if [ -n "${cname}" ]; then
    source "${DIR}/copies.sh" "${cname}"
fi