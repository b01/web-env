# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#
Param(
    [string]$f = '', # path to a a docker compose config file.
    [string]$c = '', # container to run copies on.
    [string]$n = '' # container to connect a terminal to.
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

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

$DOCKER_COMPOSE_CMD="docker-compose -f `"${dcFile}`" --project-name=web_env up --no-recreate --remove-orphans"

# Run docker compose in a new window.
newWindow $DOCKER_COMPOSE_CMD $DIR
$maxWait = 30
$val = 0
while($val -lt $maxWait) {
#    $isUp=$(docker ps | where {$_-match "Up.*${cname}"})
    $isUp=$(docker ps -aq -f "name=${cname}" -f "status=running")

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

if ($dcTerm) {
    newWindow "docker exec -it ${dcTerm} sh" $DIR
}