#!/bin/bash -e
#
pwd

echo "Allow internal composer package manager"
mkdir -p ~/.composer && cp ./resources/composer-config.json ~/.composer/config.json

mkdir -p ~/code ~/code/nginx-configs

#docker-compose --project-name=marketing_web_env up -d --no-recreate --remove-orphans
docker-compose --project-name=marketing_web_env up --no-recreate --remove-orphans

# Copy the composer configuration to the app container
docker cp ./resources/add-internal-composer.sh centos-apps:/add-internal-composer.sh
docker exec centos-apps "chown" "root:root" "/add-internal-composer.sh"
docker exec centos-apps "chmod" "a+x" "/add-internal-composer.sh"
docker exec centos-apps "/add-internal-composer.sh"