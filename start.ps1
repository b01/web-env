# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#
Param(
    [string]$dcFile = '', # docker compose config file.
    [string]$cname = '', # container to run copies on.
    [string]$cname2 = '' # container to connect a bash terminal to.
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\utilities.ps1"


. "${DIR}\build-env.ps1"

$errorLog = "${DIR}/error.log"
$conf = '';
if ($dcFile) {
    $conf = " -f ${dcFile}"
}

#docker-compose --project-name=web_env up -d --no-recreate --remove-orphans
#docker-compose --project-name=web_env up --no-recreate --remove-orphans
$DOCKER_COMPOSE_CMD="docker-compose${conf} --project-name=web_env up --no-recreate --remove-orphans"

# Run docker compose in a new window.
newWindow $DOCKER_COMPOSE_CMD $DIR
$maxWait = 30
$val = 0
while($val -lt $maxWait) {
    $isUp=$(docker ps | where {$_-match "Up.*${cname}"})

    if ($isUp) {
        printf "container is up"
        $val = $maxWait
    }

    $val++
    printf "${val}."
    Start-Sleep -Seconds 1
}

# Run copies command on container(s) passed in to cname variable.
if ($cname) {
    . "${DIR}\copies.ps1" "${cname}"
}

if ($cname2) {
    newWindow "docker exec -it ${cname2} sh" $DIR
}