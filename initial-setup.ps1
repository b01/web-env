# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#
# Add environment variables.

Param(
    [Parameter(Mandatory=$false)][string]$appsDir = (Read-Host -Prompt "Set APPS_DIR (default = ${Env:USERPROFILE}\code )")
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\utilities.ps1"

if (!$appsDir) {
    $appsDir = "${Env:USERPROFILE}\code"
}

if ($Env:HOMESHARE) {
    $UserPsDir = "${Env:HOMESHARE}\Documents\WindowsPowerShell"
} else {
    $UserPsDir = "${Env:USERPROFILE}\Documents\WindowsPowerShell"
}

# First, lets make sure the directory exist, otherwise this script will error.
md $UserPsDir -Force

# Add some evironment variables.
setUserEnvVar 'APPS_DIR' $appsDir
setUserEnvVar 'NGINX_CONFS_DIR' "${appsDir}\nginx-confs"
setUserEnvVar 'SSL_DIR' "${appsDir}\ssl"

setUserEnvVar 'DOCKER_APPS_DIR' '/code'

$getIpString = '(
    Get-NetIPConfiguration | `
    Where-Object { `
        $_.IPv4DefaultGateway -ne $null `
    -and `
        $_.NetAdapter.Status -ne "Disconnected" `
    } `
).IPv4Address.IPAddress'

setPowerShellUserEnvVar 'HOST_IP' $getIpString $true
setPowerShellUserEnvVar 'XDEBUG_CONFIG' '"remote_host=${HOST_IP}"'

printf "`nPlease logout and then log back in order for these changes to take effect!`n"