#!/bin/bash -e

function copySshKeysToContainer() {
    sshDir=$1
    container=$2

    printf "copy ssh keys to ${container} container"
    docker cp "${sshDir}"/. "${container}":/root/.ssh

    printf " and changing permissions."
    docker exec "${container}" chown -R root:root /root/.ssh/

    printf " Completed.\n"
}

function copyGitConfigToContainer() {
    gitConfig=$1
    container=$2

    printf "copy git configuration to ${container} container"
    docker cp "${gitConfig}" ${container}:/root/.gitconfig


    printf " and changing permissions."
    docker exec ${container} chown -R root:root /root/.gitconfig

    printf " Completed.\n"
}

# Constants
SSH_DIR=$(echo ~/.ssh)
GIT_CONF_FILE=$(echo ~/.gitconfig)

# Variables
dockerContainers=("alpine-apps")

# Override variables
if [ ! "$#" -eq 0 ]; then
    dockerContainers=( "$@" )
fi

# Loop though all arguments passed to this script.
for val in "${dockerContainers[@]}"
do
    if [ -d "${SSH_DIR}" ]; then
        copySshKeysToContainer "${SSH_DIR}" "${val}"
    fi

    if [ -f "${GIT_CONF_FILE}" ]; then
        copyGitConfigToContainer "${GIT_CONF_FILE}" "${val}"
    fi
done