#!/bin/bash -e

# Directory of this script.
DIR=$( cd "$( dirname "$0" )" && pwd )

# $1 = URL of a Git repository.
# $2 = )(centos-apps|centos-apps54)
# 1. Parse the app name, for ex: git@git:marketing-web/quickenloans.git => quickenloans
APP_NAME=$(echo "${1}" | perl -pe 's#.+?/(.+?).git$#\1#g')
WEB_ENV_DIR=$(echo "${HOME}/code/${APP_NAME}/web-env/")

printf "Spinning up ${APP_NAME}\n"

# Allow an app container to be specified.
APP_CONTAINER="centos-apps"
if [ ! -z "${2}" ]; then
    APP_CONTAINER="${2}"
fi

# Allow an nginx container to be specified.
NGINX_CONTAINER="centos-nginx"
if [ ! -z "${3}" ]; then
    NGINX_CONTAINER="${3}"
fi

# Check APPS_DIR environment variable is defined.
if [ -z "${APPS_DIR}" ]; then
    printf "APPS_DIR is empty, setting to default ~/code\n"
    APPS_DIR=$(echo "${HOME}/code")
fi

# Check NGINX_CONFS_DIR environment variable is defined.
if [ -z "${NGINX_CONFS_DIR}" ]; then
    printf "NGINX_CONFS_DIR is empty, setting to default ~/code/nginx-confs\n"
    NGINX_CONFS_DIR=$(echo "${HOME}/code/nginx-confs")
fi

# 1.a Change to the docker apps dir.
cd "${APPS_DIR}"
printf "CWD: " && pwd

# 2. Clone the repo, if it does not already exist.
if [ ! -d "${APP_NAME}" ]; then
    git clone "${1}"
fi

# 3. Setup with Nginx container.
APP_NGINX_CONF_DIR="${HOME}/code/${APP_NAME}/web-env"
{ # try
    NGINX_CONF_FILE=$(find "${APP_NGINX_CONF_DIR}" -name "*-nginx.conf")
} || { # catch
    NGINX_CONF_FILE=''
}

echo "NGINX_CONF_FILE=${NGINX_CONF_FILE}"

if [ -f "${NGINX_CONF_FILE}" ]; then
    NGINX_NAME=$(echo "${NGINX_CONF_FILE}" | sed "s#${WEB_ENV_DIR}\(.*\)-nginx.conf\$#\1#")

    # Copy the Nginx config to the correct directory.
    printf "making copy: "
    cp -v "${NGINX_CONF_FILE}" "${NGINX_CONFS_DIR}/${NGINX_NAME}-nginx.conf"

    printf "Debug show all Nginx configs: "
    ls "${NGINX_CONFS_DIR}"

    # Make an SSL certificate for the app.
    printf "Generating a named SSL certificate for the app ${NGINX_NAME}.docker\n"

    docker exec "${NGINX_CONTAINER}" "/generate-named-ssl-cert.sh" "${NGINX_NAME}.docker"

    # Restart the NginX services
    printf "Restarting NginX service.\n"
    docker exec centos-nginx "nginx" "-s" "reload"

    # Add the apps domain to host PCs' hosts file
    printf "Don't forget to add '${NGINX_NAME}.docker' to the host PCs' host file.\n"
else
    printf "Could not find an Nginx config at the location \"${APP_NGINX_CONF_DIR}\" to copy.\n"
fi

# 4. Run build steps if build script is present.
BUILD_SCRIPT="${APP_NAME}/bin/build.sh"
if [ -f "${BUILD_SCRIPT}" ]; then
    docker exec "${APP_CONTAINER}" "cd" "/code/${APP_NAME}" "&&" "./bin/build.sh"
else
    printf "No build script found at the location ${BUILD_SCRIPT}.\n"
fi

# 5. Copy environment variables.
ENV_FILE="${WEB_ENV_DIR}/env_vars.txt"
if [ -f "${ENV_FILE}" ]; then
    docker cp "${DIR}"/../resources/append-vars.sh "${APP_CONTAINER}":/root/append-vars.sh
    docker exec "${APP_CONTAINER}" chown -R root:root /root/append-vars.sh
    docker exec "${APP_CONTAINER}" chmod a+x /root/append-vars.sh

    docker cp "${ENV_FILE}" centos-apps:/root/env_vars
    docker exec "${APP_CONTAINER}" chown -R root:root /root/env_vars
    docker exec -i "${APP_CONTAINER}" ls -la /root
    docker exec -i "${APP_CONTAINER}" /root/append-vars.sh
    printf "Copied ENV vars.\n"
fi