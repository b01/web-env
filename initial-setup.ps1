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
setUserEnvVar 'BACKUP_DIR' "${appsDir}\backup"
setUserEnvVar 'MONGO_DKR_BKUP_DIR' '/var/lib/mongodb-backup'
setUserEnvVar 'MONGO_DKR_DATA_DIR' '/var/lib/mongodb'
setUserEnvVar 'MONGO_DKR_LOG_DIR' '/var/log/mongodb'

setUserEnvVar 'DOCKER_APPS_DIR' '/code'

$getIpString = '(
    Get-NetIPConfiguration | `
    Where-Object { `
        $_.IPv4DefaultGateway -ne $null `
    -and `
        $_.NetAdapter.Status -ne "Disconnected" `
    } `
).IPv4Address.IPAddress'

$runtimeVal = Invoke-Expression -Command $getIpString

# Will be immediately available in PowerShell as a global variable.
Set-Variable "`$HOST_IP" $runtimeVal -Scope global
Set-Item "Env:HOST_IP" $HOST_IP
echo "HOST_IP = ${HOST_IP}"
echo "Env:HOST_IP = ${Env:HOST_IP}"

# Will persist in PowerShell as a global and an environment variable.
Add-Content -Path $Profile.CurrentUserAllHosts -Value "`$HOST_IP = ${getIpString}"
Add-Content -Path $Profile.CurrentUserAllHosts -Value "`$Env:HOST_IP = `$HOST_IP"

printf "`n**You may need to logout and then log back in order for these changes to take effect!**`n"