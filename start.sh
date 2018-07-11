#!/bin/sh -e

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
i=1
isUp=''
printf "waiting for ${cname} to start "
while [ $i -lt 10 ]; do
    (( i++ ))

    printf "."

    isUp=$(docker ps -aq -f "name=${cname}" -f "status=running")

    if [ -n "${isUp}" ]; then
        break
    fi

    sleep 1
done
printf " done\n"

# Run copies command on container(s) passed in to cname variable.
if [ -n "${isUp}" ]; then
    source "${DIR}/copies.sh" "${cname}"
fi

container=$(docker ps -aq -f "name=${iaterm}" -f "status=running")
if [ -n "${container}" ]; then
    printf "Open a new terminal window to the docker container ${iaterm}.\n"
    new_tab "Docker ${iaterm}" "docker exec -it ${container} sh"
fi