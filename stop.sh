#!/bin/bash -e

DOCKER_COMPOSE_CMD='docker-compose --project-name=web_env down'

if [ -n "${1}" ]; then
    DOCKER_COMPOSE_CMD="docker-compose -f ${1} --project-name=web_env down"
fi

$($DOCKER_COMPOSE_CMD)