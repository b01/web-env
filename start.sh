#!/bin/sh

set -e

DIR=$( cd "$(dirname ${0})" && pwd)

source $DIR/env.sh

CWD=$(pwd)
package="start.sh"

source "${DIR}"/utilities.sh
source "${DIR}"/flags.sh

"${DIR}"/build-env.sh

if [ -n "${dcFile}" ] && [[ "${dcFile::1}" != "/" ]]; then
    dcFile="${CWD}/${dcFile}"
    printf "changing dcFile to ${dcFile}\n"
fi

if [ -z "${dcFile}" ]; then
    dcFile="${WEB_ENV_DIR}/docker-compose.yml"
fi

if [ -z "${wTime}" ]; then
    wTime=300
fi

echo "wTime = ${wTime}"
echo "cname = ${cname}"

DOCKER_COMPOSE_CMD="docker-compose -f ${dcFile} --project-name=web_env up -d --no-recreate --remove-orphans"

if [ "${nWin}" = "1" ]; then
    printf "Starting web Docker environment in a new terminal Window.\n"
    new_tab "bash -l -c 'cd ${WEB_ENV_DIR} && source .env && ${DOCKER_COMPOSE_CMD}'" "WebEnv Monitor"
else
    bash -l -c "${DOCKER_COMPOSE_CMD}"
fi

# "i" controls home many seconds this loop runs, as snore will sleep for 1 second each iteration.
i=$wTime
isUp=''
iLen=${#i}

# Just to make output pleasant.
if [ -n "${cname}" ]; then
    printf "Time remaining for containers to spin up: "
fi

while [ -n "${cname}" ] && [ $i -gt 0 ]; do
    (( i-- ))

    iLen=${#i}

    printf "${i}"

    isUp=$(docker ps -aq -f "name=${cname}" -f "status=running")

    if [ -n "${isUp}" ]; then
        printf "\010%.0s" $(seq 1 $iLen)
        sleep 1
        break
    fi

    sleep 1

    printf "\010%.0s" $(seq 1 $iLen)
done

printf "done.\n"

# These can only run if the above process was started in a new window.
if [ "${nWin}" = 1 ]; then

    # Run copies command on container(s) passed in to cname variable.
    if [ -n "${isUp}" ]; then
        source "${DIR}/copies.sh" "${cname}"
    fi

    if [ -z "${entryPoint}" ]; then
        entryPoint='sh'
    fi

    container=$(docker ps -aq -f "name=${iaterm}" -f "status=running")
    if [ -n "${container}" ]; then
        printf "Open a new terminal window to the docker container ${iaterm}.\n"
        new_tab "docker exec -it ${container} ${entryPoint}" "Docker ${iaterm}"
  fi
fi