# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Param(
    [array]$containers # Allow an app container to be specified.
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\.env.ps1"
. "$DIR\utilities.ps1"

if (!$containers) {
    $containers = "alpine-apps"
}

function copySshKeysToContainer() {
    param($sshDir, $container)

    printf "copy ssh keys to ${container} container"
    docker cp "${sshDir}\\." "${container}:/root/.ssh"

    printf " and change permissions."
    docker exec "${container}" chown -R root:root /root/.ssh/

    printf " Completed.`n"
}

function copyGitConfigToContainer() {
    param($gitConfig, $container)

    printf "copy git configuration to ${container} container"
    docker cp "${gitConfig}" "${container}:/root/.gitconfig"

    printf " and change permissions."
    docker exec "${container}" chown -R root:root /root/.gitconfig

    printf " Completed.`n"
}

# Constants
$SSH_DIR=(Resolve-Path -Path "~\.ssh").Path
$GIT_CONF_FILE=$(Resolve-Path "~\.gitconfig").Path

printf "CWD = ${DIR}`n"
printf "SSH_DIR = ${SSH_DIR}`n"
printf "GIT_CONF_FILE = ${GIT_CONF_FILE}`n"

# Loop though all arguments passed to this script.
foreach ($val in $containers) {
    if ($SSH_DIR) {
        copySshKeysToContainer "${SSH_DIR}" "${val}"
    }

    # Copy ~/gitconfig over to app containers.
    if ($GIT_CONF_FILE) {
        copyGitConfigToContainer "${GIT_CONF_FILE}" "${val}"
    }
}