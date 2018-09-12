#!/bin/bash

function addUserEnvVar () {
    envName=$1
    envValue=$2

    if [ -n "${3}" ]; then
        envFile="${3}"
    fi

    hasVar=$(grep -sc --color=never -E "^export\s+${envName}" $envFile)

    if [ "${hasVar}" = "0" ]; then
        printf "\nexport ${envName}=${envValue}" >> "${envFile}"
        printf "Added ${envName} to ${envFile}\n"
    else
        searchTerm="^export ${envName}.*"
        replacement="export ${envName}=${envValue}"
        sed -E -i'' "s|${searchTerm}|${replacement}|g" "${envFile}"
        printf "Updated environment variable ${envName}\n"
    fi

    export "${envName}=${envValue}"
}

function getInput() {
    msg=$1
    getInputReturn=$2

    # Prompt the user for this value.
    read -p "${msg}" din1

    if [ -n "${din1}" ]; then
        getInputReturn="${din1}"
    fi
}

# Directory of this script.
DIR=$( cd "$( dirname "$0" )" && pwd )
WEB_ENV_DIR="${DIR}"
envFile="${WEB_ENV_DIR}/env.sh"

echo '# WebEnv Environment variables:' > "${envFile}"

if [ -f "$" ]; then
    echo "Could NOT make ${envFile}"
    exit 1
fi

# Check APPS_DIR environment variable is defined, if not ask for it.
appsDirDefault=~/code

# Prompt the user for this value.
getInput "Where do you store your projects (default=${appsDirDefault}):" $appsDirDefault

appsDir="${getInputReturn}"

printf "You entered ${appsDir} for APPS_DIR\n"

if [ ! -d "${appsDir}" ]; then
    printf "${appsDir} is not a directory. Please try again with a valid directory to continue.\n"
    exit 1
fi

addUserEnvVar 'APPS_DIR' "'${appsDir}'"
addUserEnvVar 'DOCKER_APPS_DIR' "'/code'"
addUserEnvVar 'NGINX_CONFS_DIR' "'${appsDir}/nginx-confs'"
addUserEnvVar 'SSL_DIR' "'${appsDir}/ssl'"
addUserEnvVar 'BACKUP_DIR' "'${appsDir}/backup'"
addUserEnvVar 'MONGO_DKR_BKUP_DIR' "'/var/lib/mongodb-backup'"
addUserEnvVar 'MONGO_DKR_DATA_DIR' "'/var/lib/mongodb'"
addUserEnvVar 'MONGO_DKR_LOG_DIR' "'/var/log/mongodb'"
addUserEnvVar 'WEB_ENV_DIR' "'${DIR}'"
addUserEnvVar 'HOST_IP' '$(ipconfig getifaddr en0 2>/dev/null)'

#link short-cut
if [ -d "/usr/local/bin" ]; then
    if [ -f "/usr/local/bin/webenv" ]; then
        printf "Symlink webenv successfully detected in /usr/local/bin/webenv\n"
    else
        SYM_FILE='/usr/local/bin/webenv'
        SYM_USER=$(whoami)
        #&& chown -h ${SYM_USER} /usr/local/bin/webenv
        LNK_CMD="ln -s ${WEB_ENV_DIR}/web-env.sh ${SYM_FILE} && chown -h ${SYM_USER} ${SYM_FILE}"
        osascript -e "do shell script \"${LNK_CMD}\" with administrator privileges"
        printf "Added webenv symlink to /usr/local/bin/webenv\n"
    fi
fi