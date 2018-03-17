#!/bin/bash -e

# 1. Parse the app name, for ex: git@git:marketing-web/quickenloans.git => quickenloans
APP_NAME=$(echo "${1}" | perl -pe 's#.+?/(.+?).git$#\1#g')
# A sed version if perl is not available.
#APP_NAME=$(echo "${1}" | sed -E 's#[^/]+/(.+).git#\1#g')
printf "Spinning up ${APP_NAME}\n"

# 2. Clone the repo.
cd "${APPS_DIR}"
git clone "${1}"

# 3. Copy the Nginx config to the correct directory.
NGINX_CONF_FILE="${APP_NAME}/webenv/nginx.conf"
if [ -f "${NGINX_CONF_FILE}" ]; then
    cp "${NGINX_CONF_FILE}" "${NGINX_CONFS_DIR}/${APP_NAME}.conf"
    ls "${NGINX_CONFS_DIR}"
else
    printf "Could not find a WebEnv Nginx config at the location ${NGINX_CONF_FILE} to copy.\n"
fi

# 4. Run any necessary configurations for the app from within the Docker app container.

# 5. Add the apps domain to hosts file
# 6. Restart the NginX services