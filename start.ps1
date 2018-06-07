# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#
Param(
    [string]$dcFile = '', # docker compose config file.
    [string]$cname = '' #
)
pwd

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\utilities.ps1"


. "${DIR}\build-env.ps1"

$errorLog = "${DIR}/error.log"
$conf = '';
if ($dcFile) {
    $conf = " -f ${dcFile}"
}

#docker-compose --project-name=web_env up -d --no-recreate --remove-orphans
docker-compose --project-name=web_env up --no-recreate --remove-orphans
#$DOCKER_COMPOSE_CMD="docker-compose${conf} --project-name=web_env up --no-recreate --remove-orphans"

# Run docker compose in a new window.
#Start-Process -FilePath "powershell.exe" -Args $DOCKER_COMPOSE_CMD -Verb open -WorkingDirectory $DIR -RedirectStandardError $errorLog
