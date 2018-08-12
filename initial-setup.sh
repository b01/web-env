#!/bin/bash

# Directory of this script.
DIR=$( cd "$( dirname "$0" )" && pwd )

function addUserEnvVar () {
    envFile=~/.bash_profile
    envName=$1
    envValue=$2

    if [ -n "${3}" ]; then
        envFile="${3}"
    fi

    fileContents=$(cat "${envFile}")

    hasVar=$(echo "${fileContents}" | grep -c --color=never -E "^export\s+${envName}")

    if [ "${hasVar}" = "0" ]; then
        printf "\nexport ${envName}=${envValue}" >> "${envFile}"
        printf "Added ${envName} to environment\n"
    else
        searchTerm="^export ${envName}.*"
        replacement="export ${envName}=${envValue}"
        sed -E -i 'bash_profile.bak' "s|${searchTerm}|${replacement}|g" "${envFile}"
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
addUserEnvVar 'WEB_ENV_DIR' "'$DIR'"
addUserEnvVar 'HOST_IP' '$(ipconfig getifaddr en0)'

#link short-cut
if [ ! -f "/usr/local/bin/webenv" ]; then
    printf "Added webenv symlink to /usr/local/bin/webenv\n"
    ln -s "${WEB_ENV_DIR}/web-env.sh" /usr/local/bin/webenv
else
    printf "Symlink webenv successfully detected in /usr/local/bin/webenv\n"
fi