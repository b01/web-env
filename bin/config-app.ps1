# you may need to run, before you can use this script:
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# $1 = URL of a Git repository.
# $2 = (centos-apps|centos-apps54)
# $3 = (centos-nginx)

# 1. Parse the app name, for ex: git@github.com:b01/web-env.git => web-env
$APP_NAME=$(echo $args[0] | %{$_-replace ".+?/(.+?).git$","$1"})

Write-Host "Spinning up ${APP_NAME}\n"

# Allow an app container to be specified.
$APP_CONTAINER="centos-apps"
if (! -z "${2}" ) {
    $APP_CONTAINER="${2}"
}

# Allow an nginx container to be specified.
$NGINX_CONTAINER="centos-nginx"
if ($args.Length > 1) {
    $NGINX_CONTAINER=$args[2]
}

# Check APPS_DIR environment variable is defined.
if ("${APPS_DIR}") {
    printf "APPS_DIR is empty, setting to default ~/code\n"
    $APPS_DIR=$(echo "${HOME}/code")
}

# Check NGINX_CONFS_DIR environment variable is defined.
if (-z "${NGINX_CONFS_DIR}") {
    printf "NGINX_CONFS_DIR is empty, setting to default ~/code/nginx-confs\n"
    NGINX_CONFS_DIR=$(echo "${HOME}/code/nginx-confs")
}


# 1.a Change to the docker apps dir.
cd "${APPS_DIR}"
printf "CWD: " && pwd

# 2. Clone the repo, if it does not already exist.
if (! -d "${APP_NAME}") {
    git clone "${1}"
}

# 3. Setup with Nginx container.
APP_NGINX_CONF_DIR="${HOME}/code/${APP_NAME}/web-env"
{ # try
    NGINX_CONF_FILE=$(find "${APP_NGINX_CONF_DIR}" -name "*-nginx.conf")
} || { # catch
    NGINX_CONF_FILE=''
}

echo "NGINX_CONF_FILE=${NGINX_CONF_FILE}"

if ( -f "${NGINX_CONF_FILE}") {
    WEB_ENV_DIR=$(echo "${HOME}/code/${APP_NAME}/web-env/")
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
} else {
    printf "Could not find an Nginx config at the location \"${APP_NGINX_CONF_DIR}\" to copy.\n"
}

# 4. Run build steps if build script is present.
BUILD_SCRIPT="${APP_NAME}/bin/build.sh"
if (-f "${BUILD_SCRIPT}") {
    docker exec "${APP_CONTAINER}" "cd" "/code/${APP_NAME}" "&&" "./bin/build.sh"
} else {
    printf "No build script found at the location ${BUILD_SCRIPT}.\n"
}
