#!/bin/bash

set -e

DIR=$( cd "$(dirname ${0})" && pwd)

source $DIR/.env

# Check APPS_DIR environment variable is defined.
if [ -z "${APPS_DIR}" ]; then
    printf "Please set the APPS_DIR environment variable before using WebEnv tool. Exiting.\n"
    exit 1
fi

# Parameters to this script:
# --
# $1 = URL of a Git repository.
# $2 optional = (alpine-apps|alpine-apps54)
# $3 optional = (alpine-nginx)
# $4 optional = (/private/etc/hosts)

if [ -z "${1}" ]; then
    printf "Missing the required first parameter which should a git repository. Exiting.\n"
    exit 1
fi

# 1. Parse the app name, for ex: git@git:marketing-web/quickenloans.git => quickenloans
APP_NAME=$(echo "${1}" | perl -pe 's#.+\/(.+?).git$#\1#g')
WEB_ENV_DIR=$(echo "${APPS_DIR}/${APP_NAME}/web-env/")

printf "Spinning up ${APP_NAME}\n"
printf "...\n"

# Allow an app container to be specified.
APP_CONTAINER="alpine-apps"
if [ -n "${2}" ]; then
    APP_CONTAINER="${2}"
fi
printf "Using app container: ${APP_CONTAINER}\n"

# Allow an nginx container to be specified.
NGINX_CONTAINER="alpine-nginx"
if [ -n "${3}" ]; then
    NGINX_CONTAINER="${3}"
fi
printf "Using NGinX container: ${NGINX_CONTAINER}\n"

# Check $CMP_HOST_FILE environment variable is defined.
CMP_HOST_FILE="/private/etc/hosts"
if [ -n "${4}" ]; then
    CMP_HOST_FILE=$4
fi
printf "Using hosts file: ${CMP_HOST_FILE}\n"

# Check NGINX_CONFS_DIR environment variable is defined.
if [ -z "${NGINX_CONFS_DIR}" ]; then
    NGINX_CONFS_DIR=$(echo "${APPS_DIR}/nginx-confs")
fi
printf "Using NGinX config directory: ${NGINX_CONFS_DIR}\n"

# 1.a Change to the docker apps dir.
cd "${APPS_DIR}"
printf "CWD: " && pwd

# 2. Clone the repo, if it does not already exist.
if [ ! -d "${APP_NAME}" ]; then
    git clone "${1}"
else
    printf "Directory found ${APP_NAME}. Skipping git clone process.\n"
fi

# 3. Setup with Nginx container.
APP_NGINX_CONF_DIR="${APPS_DIR}/${APP_NAME}/web-env"

NGINX_CONF_FILE=$(find "${APP_NGINX_CONF_DIR}" -name "*-nginx.conf")

echo "NGINX_CONF_FILE=${NGINX_CONF_FILE}"

dockerNginxId=$(docker ps -aq -f "name=${NGINX_CONTAINER}")
if [ -f "${NGINX_CONF_FILE}" ] && [ -n "${dockerNginxId}" ]; then
    printf "NGinX container ID: ${dockerNginxId}\n"
    NGINX_NAME=$(echo "${NGINX_CONF_FILE}" | sed "s#${WEB_ENV_DIR}\(.*\)-nginx.conf\$#\1#")

    # Copy the Nginx config to the correct directory.
    printf "making copy: "
    cp -v "${NGINX_CONF_FILE}" "${NGINX_CONFS_DIR}/${NGINX_NAME}-nginx.conf"

    # Make an SSL certificate for the app.
    printf "Generating a named SSL certificate for the app ${NGINX_NAME}.docker\n"
    docker exec "${NGINX_CONTAINER}" generate-named-ssl-cert.sh "${NGINX_NAME}.docker"

    nginxConfigFound=$(cat $CMP_HOST_FILE | grep "${NGINX_NAME}.docker")
    if [ -z "${nginxConfigFound}" ]; then
        # Add the apps domain to host PCs' hosts file
        printf "Don't forget to add '${NGINX_NAME}.docker' to the host PCs' host file.\n"
    fi

    # Restart the NginX services
    printf "Restarting NginX service.\n"
    docker exec "${NGINX_CONTAINER}" nginx -s reload
else
    printf "Skipping NGinX configuration.\n"
fi

# 4. Copy environment variables.
dockerAppsId=$(docker ps -aq -f "name=${APP_CONTAINER}")
ENV_FILE="${WEB_ENV_DIR}/env-vars.txt"
if [ -f "${ENV_FILE}" ] && [ -n "${dockerAppsId}" ]; then
    printf "Apps container ID: ${dockerAppsId}\n"
    printf "Copying ${APP_NAME} environement variables over to "${APP_CONTAINER}".\n"
    E_FILE="${DIR}/${APP_NAME}-env-vars.txt"
    rm -rf "${E_FILE}"
    touch "${E_FILE}"

    while read -r line || [[ $line ]]; do
        echo "export ${line}=\"${!line}\"" >> "${E_FILE}"
    done < "${ENV_FILE}"

    docker cp "${E_FILE}" "${APP_CONTAINER}":/root/env-vars.txt
    docker exec "${APP_CONTAINER}" chown -R root:root /root/env-vars.txt

    docker cp "${DIR}"/resources/append-vars.sh "${APP_CONTAINER}":/root/append-vars.sh
    docker exec "${APP_CONTAINER}" chown -R root:root /root/append-vars.sh
    docker exec "${APP_CONTAINER}" chmod a+x /root/append-vars.sh
    docker exec -i "${APP_CONTAINER}" /root/append-vars.sh
    printf "Copied ${APP_NAME} ENV vars to "${APP_CONTAINER}".\n"
    rm "${E_FILE}"
else
    printf "Skipped copy of files to the apps container.\n"
fi

# 5. Run build steps if build script is present.
BUILD_SCRIPT="${APP_NAME}/bin/build.sh"
if [ -f "${BUILD_SCRIPT}" ]; then
    printf "Running ${APP_NAME} build script on ${APP_CONTAINER} container.\n"
    docker exec --user "root" "${APP_CONTAINER}" bash -c "source ~/.bashrc && cd /code/${APP_NAME} && ./bin/build.sh"
else
    printf "No build script found at the location ${BUILD_SCRIPT}. Skipping.\n"
fi