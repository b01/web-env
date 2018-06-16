#!/bin/bash -e

function addUserEnvVar () {
    envFile=~/.bash_profile
    envName=$1
    envValue=$2

    if [ -n "${3}" ]; then
        envFile="${3}"
    fi

    fileContents=$(cat "${envFile}")

    case "${fileContents}" in
        *"${envName}"* ) hasVar="yes";;
        * ) hasVar="";;
    esac

    if [ -z "${hasVar}" ]; then
        echo "export ${envName}=${envValue}" >> "${envFile}"
    fi
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

addedEnvVar=()

# Check APPS_DIR environment variable is defined, if not ask for it.
if [ -z "${APPS_DIR}" ]; then
    appsDirDefault=~/code

    # Prompt the user for this value.
    getInput "Where would you like to store your projects (default=${appsDirDefault}):" $appsDirDefault

    APPS_DIR="${getInputReturn}"

    if [ -n "${din1}" ]; then
        APPS_DIR="${din1}"
    fi

    addedEnvVar+=("APPS_DIR")
    addUserEnvVar "APPS_DIR" "${APPS_DIR}"
fi

if [ -z "${DOCKER_APPS_DIR}" ]; then
    addedEnvVar+=("DOCKER_APPS_DIR")
    addUserEnvVar "DOCKER_APPS_DIR" "/code"
fi

if [ -z "${NGINX_CONFS_DIR}" ]; then
    addedEnvVar+=("NGINX_CONFS_DIR")
    addUserEnvVar "NGINX_CONFS_DIR" "${APPS_DIR}/nginx-confs"
fi

if [ -z "${SSL_DIR}" ]; then
    addedEnvVar+=("SSL_DIR")
    addUserEnvVar "SSL_DIR" "${APPS_DIR}/ssl"
fi

addedEnvVar+=("BACKUP_DIR")
addUserEnvVar 'BACKUP_DIR' "${APPS_DIR}/backup"

if [ ! "${#addedEnvVar[@]}" -eq 0 ]; then
    printf "New environment variables were added: ${addedEnvVar}, if you want them to take effect, please close all terminals and open again.\n"
    printf "${addedEnvVar}.\n"
fi