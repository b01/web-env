#!/bin/bash

DIR=$( cd "$( dirname "$0" )" && pwd )
CWD=$(pwd)
package="start.sh"

source "${DIR}"/utilities.sh
source "${DIR}"/flags.sh

"${DIR}"/build-env.sh

docker volume create mongoData
docker volume create mongoLog

DOCKER_COMPOSE_CMD='docker-compose --project-name=web_env up --no-recreate --remove-orphans'

if [ -n "${dcFile}" ]; then
    DOCKER_COMPOSE_CMD="docker-compose -f ${dcFile} --project-name=web_env up --no-recreate --remove-orphans"
fi

printf "Starting web Docker environment in a new terminal Window.\n"
new_tab "WebEnv Monitor" "cd ${CWD} && ${DOCKER_COMPOSE_CMD}"

# "i" controls home many seconds this loop runs, as snore will sleep for 1 second each iteration.
i=10
printf "waiting for ${cname} to start "
while ((i--)); do
    isUp=$(docker ps | grep "Up.*${cname}")

    printf "."

    if [ -n "${isUp}" ]; then
        break
    fi

    snore 1
done
printf " done\n"

# Run copies command on container(s) passed in to cname variable.
if [ -n "${cname}" ]; then
    source "${DIR}/copies.sh" "${cname}"
fi