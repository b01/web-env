# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#
Param(
    [string]$f = '', # path to a a docker compose config file.
    [string]$c = '', # container to run copies on.
    [string]$n = '', # container to connect a terminal to.
    [Int32]$t = 300 # time to wait for container to spin up.
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\.env.ps1"

. "${DIR}\utilities.ps1"

. "${DIR}\build-env.ps1"

$dcFile = "${WEB_ENV_DIR}\docker-compose.yml"

if ($f) {
    $dcFile = "${f}"
}

if ($c) {
    $cname = "${c}"
}

if ($n) {
    $dcTerm = "${n}"
}

if ($t) {
    $wTime = $t
}

$DOCKER_COMPOSE_CMD="docker-compose -f `"${dcFile}`" --project-name=web_env up --no-recreate --remove-orphans"

# Run docker compose in a new window.
newWindow $DOCKER_COMPOSE_CMD $DIR

# Wait for Docker to spin up the containers.
$timer = $wTime

while($timer -gt 0) {
    $isUp=$(docker ps -aq -f "name=${cname}" -f "status=running")

    if ($isUp) {
        Write-Progress -Activity "waiting for containers to spin up" -Completed -Status 'container is up'
        break
    }

    $timer--
    Write-Progress -Activity "waiting for containers to spin up" -SecondsRemaining $timer
    Start-Sleep -Seconds 1
}

# Run copies command on container(s) passed in to cname variable.
if ($cname) {
    . "${DIR}\copies.ps1" "${cname}"
}

if ($dcTerm) {
    newWindow "docker exec -it ${dcTerm} sh" $DIR
}