# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Param(
    [Parameter(Mandatory=$true)][string]$gitUrl,
    [string]$APP_CONTAINER = "centos-apps", # Allow an app container to be specified.
    [string]$NGINX_CONTAINER = "centos-nginx" # Allow an nginx container to be specified.
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "$DIR\utilities.ps1"

printf "CWD = ${DIR}`n"

# $1 = URL of a Git repository.
# $2 = (centos-apps|centos-apps54)
# $3 = (centos-nginx)
# 1. Parse the app name, for ex: git@github.com:b01/web-env.git => web-env
$APP_NAME=($gitUrl -replace ".+?/(.+?).git$",'$1')

printf "Spinning up ${APP_NAME}`n"
#Get-ChildItem Env: | Sort Name


# Check APPS_DIR environment variable is defined.
if (!$env:APPS_DIR) {
    $homeDrive = Split-Path -qualifier $HOME

    printf "Home drive is ${homeDrive}`n"

    $networkDisk = Gwmi Win32_LogicalDisk -filter "DriveType = 4 AND DeviceID = '$homeDrive'"

    if ($networkDisk) {
        $APPS_DIR=$("C:\${env:USERNAME}\code")
        printf "Home is is network drive: ${logicalDisk}`n"
    } else {
        $APPS_DIR="${HOME}\code"
    }

    printf "Environment variable APPS_DIR is empty, setting to ${APPS_DIR}`n"
} else {
    $APPS_DIR = $env:APPS_DIR
}

$APP_DIR = "${APPS_DIR}\${APP_NAME}"
$APP_WEB_ENV_DIR="${APP_DIR}\web-env"

# Check NGINX_CONFS_DIR environment variable is defined.
if (!$env:NGINX_CONFS_DIR) {
    $NGINX_CONFS_DIR="${APPS_DIR}\nginx-confs"
    printf "Environment variable NGINX_CONFS_DIR is empty, setting to ${NGINX_CONFS_DIR}"
}

# 1. Clone the repo, if it does not already exist.
if (!(Test-Path -Path $APP_DIR)) {
    git clone "${gitUrl}" "${APP_DIR}"
}

# 2. Setup with Nginx container.
if (Test-Path -Path $APP_WEB_ENV_DIR) {
    get-childitem $APP_WEB_ENV_DIR | where {$_-match ".*?-nginx.conf"} | % {
        $NGINX_CONF_FILE=$_.FullName
    }
    printf "NGINX_CONF_FILE=${NGINX_CONF_FILE}`n"
} else {
    printf "No WebEnv ${APP_WEB_ENV_DIR} directory found.`n"
}

if ($NGINX_CONF_FILE -and (Test-Path -Path $NGINX_CONF_FILE)) {
    # Escap special chars in the path.
    $reEscStr = [Regex]::Escape($APP_WEB_ENV_DIR)
    # Parse the beginning of the NGinX conf file.
    $NGINX_NAME=($NGINX_CONF_FILE -replace "${reEscStr}\\(.*?)-nginx.conf$", '$1')
    # Copy the Nginx conf to the correct directory.
    printf "making copy: "
    cp -v "${NGINX_CONF_FILE}" "${NGINX_CONFS_DIR}/${NGINX_NAME}-nginx.conf"

    printf "Debug show all Nginx configs: "
    ls "${NGINX_CONFS_DIR}"

    # Make an SSL certificate for the app.
    printf "Generating a named SSL certificate for the app ${NGINX_NAME}.docker`n"

    docker exec "${NGINX_CONTAINER}" "generate-named-ssl-cert.sh" "${NGINX_NAME}.docker"

    # Restart the NginX services
    printf "Restarting NginX service.`n"
    docker exec "${NGINX_CONTAINER}" "nginx" "-s" "reload"

    # Add the apps domain to host PCs' hosts file

    $hostFile = "${env:WINDIR}\System32\drivers\etc\hosts"
    printf "host file: ${hostFile}"
    $hostsEntryFound = (cat $hostFile | where {$_-match "$NGINX_NAME`.docker"})
    printf "host entry: ${hostsEntryFound}"

    # cat C:\Windows\System32\drivers\etc\hosts | where {$_-match "local"}
#    if ([string]::IsNullOrEmpty($hostsEntryFound)) {
#        printf "Attempting to add ${NGINX_NAME}.docker to hosts file."
#        echo "127.0.0.1 ${NGINX_NAME}.docker" >> $hostFile
#        echo "::1 ${NGINX_NAME}.docker" >> $hostFile
#        $hostsEntryFound = (Get-Content $hostFile | where {$_-match "$NGINX_NAME`.docker"})
#    }
    if ([string]::IsNullOrEmpty($hostsEntryFound)) {
        printf "Don't forget to add '${NGINX_NAME}.docker' to the host PCs' host file.`n"
    }
} else {
    printf "Could not find an Nginx config at the location `"${APP_WEB_ENV_DIR}`" to copy.`n"
}

# 4. Run build steps if build script is present.
$BUILD_SCRIPT="${APP_DIR}\bin\build.sh"
if (Test-Path -Path $BUILD_SCRIPT) {
    docker exec "${APP_CONTAINER}" "cd" "/code/${APP_NAME}" "&&" "./bin/build.sh"
} else {
    printf "No build script found at the location ${BUILD_SCRIPT}.`n"
}
