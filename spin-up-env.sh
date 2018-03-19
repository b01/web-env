#!/bin/bash -e
#
pwd

# Copy all applications nginx files into a single directory.
cp ~/code/*/web-env/*.conf ~/code/nginx-confs/

#docker-compose --project-name=marketing_web_env up -d --no-recreate --remove-orphans
docker-compose --project-name=marketing_web_env up --no-recreate --remove-orphans
