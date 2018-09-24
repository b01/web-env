#!/bin/bash

set -e

DIR=$( cd "$(dirname ${0})" && pwd)

source $DIR/env.sh

package="stop.sh"

source "${DIR}"/flags.sh

if [ -z "${dcFile}" ]; then
    dcFile="${WEB_ENV_DIR}/docker-compose.yml"
fi

docker-compose -f "${dcFile}" --project-name=web_env down