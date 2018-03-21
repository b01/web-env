#!/bin/bash -e

# 1. Parse the app name, for ex: git@git:marketing-web/quickenloans.git => quickenloans
APP_NAME=$(echo "${1}" | perl -pe 's#.+?/(.+?).git$#\1#g')
# A sed version if perl is not available.
#APP_NAME=$(echo "${1}" | sed -E 's#[^/]+/(.+).git#\1#g')
printf "Spinning up ${APP_NAME}\n"

# Allow an app container to be specified.
APP_CONTAINER="centos-apps"
if [ ! -z "${2}" ]; then
    APP_CONTAINER="${2}"
fi

# 1.a Change to the docker apps dir.
cd "${APPS_DIR}"
pwd

# 2. Clone the repo, if it does not already exist.
if [ ! -d "${APP_NAME}" ]; then
    git clone "${1}"
fi

# 3. Copy the Nginx config to the correct directory.
NGINX_CONF_FILE="${APP_NAME}/webenv/nginx.conf"
if [ -f "${NGINX_CONF_FILE}" ]; then
    cp "${NGINX_CONF_FILE}" "${NGINX_CONFS_DIR}/${APP_NAME}.conf"
    ls "${NGINX_CONFS_DIR}"
else
    printf "Could not find a WebEnv Nginx config at the location ${NGINX_CONF_FILE} to copy.\n"
fi

# 4. Run build steps if build script is present.
BUILD_SCRIPT=$("${APP_NAME}/bin/build.sh")
if [ -f "${BUILD_SCRIPT}" ]; then
    docker exec "${APP_CONTAINER}" "cd" "/code/${APP_NAME}" "&&" "./bin/build.sh"

else
    printf "No build script found at the location ${BUILD_SCRIPT}.\n"
fi


# 5 Make an SSL certificate for the app.
printf "Generating an named SSL certificate for the .\n"
docker exec "${APP_CONTAINER}" "/generate-named-ssl-cert.sh" "${APP_NAME}.docker"

# 6. Add the apps domain to host PCs' hosts file
printf "Missing step to add '${APP_NAME}.docker' to the host PCs' host file.\n"

# 7. Restart the NginX services
printf "Restarting NginX service.\n"
docker exec centos-nginx "nginx" "-s" "reload"