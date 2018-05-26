# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#
# Add environment variables.

Param(
    [Parameter(Mandatory=$true)][string]$appsDir
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\utilities.ps1"

if (!$Env:APPS_DIR) {
    setUserEnvVar 'APPS_DIR' "`"${appsDir}`""
}

if (!$Env:NGINX_CONFS_DIR) {
    setUserEnvVar 'NGINX_CONFS_DIR' "`"${Env:APPS_DIR}\nginx-confs`""
}

if (!$Env:SSL_DIR) {
    setUserEnvVar "SSL_DIR" "`"${Env:APPS_DIR}\ssl`""
}

# Check DOCKER_APPS_DIR environment variable is defined.
if (!$env:DOCKER_APPS_DIR) {
    setUserEnvVar 'DOCKER_APPS_DIR' '"/code"'
}

$getIpString = '(
    Get-NetIPConfiguration | `
    Where-Object { `
        $_.IPv4DefaultGateway -ne $null `
-and `
#        $_.NetAdapter.Status -ne "Disconnected" `
#    } `
#).IPv4Address.IPAddress'

setUserEnvVar "HOST_IP" $getIpString
setUserEnvVar "XDEBUG_CONFIG" '"remote_host=${env:HOST_IP}"'