# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#

pwd

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\utilities.ps1"


. "${DIR}\build-env.ps1"


#docker-compose --project-name=web_env up -d --no-recreate --remove-orphans
docker-compose --project-name=web_env up --no-recreate --remove-orphans