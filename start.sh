#!/bin/sh

set -e

DIR=$( cd "$(dirname ${0})" && pwd)

source $DIR/.env

CWD=$(pwd)
package="start.sh"

source "${DIR}"/utilities.sh
source "${DIR}"/flags.sh

"${DIR}"/build-env.sh

#TODO Move this out of the repo.
docker volume create mongoData
docker volume create mongoLog

if [ -z "${dcFile}" ]; then
    dcFile="${WEB_ENV_DIR}/docker-compose.yml"
fi

if [[ " ${dcFile::1}" != "/" ]]; then
    dcFile="${CWD}/${dcFile}"
    printf "changing dcFile to ${dcFile}\n"
fi

DOCKER_COMPOSE_CMD="docker-compose -f ${dcFile} --project-name=web_env up --no-recreate --remove-orphans"

if [ "${nWin}" = "1" ]; then
    printf "Starting web Docker environment in a new terminal Window.\n"
    new_tab "bash -l -c 'cd ${WEB_ENV_DIR} && source .env && ${DOCKER_COMPOSE_CMD}'" "WebEnv Monitor"
else
    bash -l -c "${DOCKER_COMPOSE_CMD}"
fi

# "i" controls home many seconds this loop runs, as snore will sleep for 1 second each iteration.
i=1
isUp=''

printf "Starting web environment ..."
while [ -n "${cname}" ] && [ $i -lt 10 ]; do
    (( i++ ))

    printf "."

    isUp=$(docker ps -aq -f "name=${cname}" -f "status=running")

    if [ -n "${isUp}" ]; then
        break
    fi

    sleep 1
done
printf " done\n"

# These can only run if the above process was started in a new window.
if [ "${nWin}" = 1 ]; then

    # Run copies command on container(s) passed in to cname variable.
    if [ -n "${isUp}" ]; then
        source "${DIR}/copies.sh" "${cname}"
    fi

    container=$(docker ps -aq -f "name=${iaterm}" -f "status=running")
    if [ -n "${container}" ]; then
        printf "Open a new terminal window to the docker container ${iaterm}.\n"
        new_tab "docker exec -it ${container} sh" "Docker ${iaterm}"
    fi
fi