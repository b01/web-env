#!/bin/bash -e

DIR=$( cd "$( dirname "$0" )" && pwd )
package="stop.sh"

source "${DIR}"/flags.sh

DOCKER_COMPOSE_CMD='docker-compose --project-name=web_env down'

if [ -z "${dcFile}" ]; then
    dcFile="${WEB_ENV_DIR}/docker-compose.yml"
fi

docker-compose -f "${dcFile}" --project-name=web_env down