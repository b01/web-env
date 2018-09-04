# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Param(
    [string]$dcFile = '' # path to a a docker compose config file.
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\.env.ps1"

if (!$dcFile) {
    $dcFile = "${WEB_ENV_DIR}\docker-compose.yml"
}

docker-compose -f "`"${dcFile}`"" --project-name=web_env down