#!/bin/bash -e

pwd

#docker-compose --project-name=web_env up -d --no-recreate --remove-orphans
docker-compose --project-name=web_env up --no-recreate --remove-orphans