# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#

pwd

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\utilities.ps1"


. "${DIR}\build-env.ps1"

$errorLog = "${DIR}/error.log"

#docker-compose --project-name=web_env up -d --no-recreate --remove-orphans
$DOCKER_COMPOSE_CMD="docker-compose --no-recreate --remove-orphans --project-name=web_env up"

# Run docker compose in a new window.
Start-Process -FilePath "powershell.exe" -Args $DOCKER_COMPOSE_CMD -Verb open -WorkingDirectory $DIR -RedirectStandardError $errorLog
