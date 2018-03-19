#!/bin/bash -e
#
pwd

# Copy all applications nginx files into a single directory.
cp ~/code/*/web-env/*.conf ~/code/nginx-confs/

# Copy the composer configuration to the app container
docker cp ./resources/add-internal-composer.sh centos-apps:/add-internal-composer.sh
docker exec centos-apps "chown" "root:root" "/add-internal-composer.sh"
docker exec centos-apps "chmod" "a+x" "/add-internal-composer.sh"
docker exec centos-apps "/add-internal-composer.sh"