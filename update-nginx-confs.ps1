# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Param(
    [array]$container = "centos-nginx" # Allow a container to be specified.
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "$DIR\utilities.ps1"

printf "CWD = ${DIR}`n"

# Copy all applications nginx files into the mapped NginX vhost configuration directory.
printf "Copying NginX configs over to mapped container ${container} directory.`n"
cp -v "${APPS_DIR}"\*\web-env\*.conf ~\code\nginx-confs\

printf "Restarting NginX service.`n"
docker exec "${container}" nginx -s reload