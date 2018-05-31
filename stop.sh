#!/bin/bash -e

DIR=$( cd "$( dirname "$0" )" && pwd )
package="stop.sh"

source "${DIR}"/flags.sh

DOCKER_COMPOSE_CMD='docker-compose --project-name=web_env down'

if [ -n "${dcFile}" ]; then
    DOCKER_COMPOSE_CMD="docker-compose -f ${dcFile} --project-name=web_env down"
fi

$($DOCKER_COMPOSE_CMD)