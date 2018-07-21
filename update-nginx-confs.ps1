# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Param(
    [array]$container = "alpine-apps" # Allow a container to be specified.
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "$DIR\utilities.ps1"

if (!$container) {
    printf "Please specify a docker container as the first parameter.`n"
    exit 1
}

$isUp=$(docker ps -aq -f "name=${container}" -f "status=running")
if (!$isUp) {
    printf "There is no container ${container} running. Please specify a running docker container as the first parameter.`n"
    exit 1
}

# Copy all applications nginx files into the mapped NginX vhost configuration directory.
printf "Copying NginX configs over to mapped container ${container} directory.`n"
cp -v "${APPS_DIR}\*\web-env\*.conf" "${APPS_DIR}\nginx-confs\"

printf "Restarting NginX service.`n"
docker exec "${container}" nginx -s reload