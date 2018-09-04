# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#
# Add environment variables.

Param(
    [Parameter(Mandatory=$false)][string]$appsDir = (Read-Host -Prompt "Where do you store your projects (default = ${Env:USERPROFILE}\code )")
)

$DIR = split-path -parent $MyInvocation.MyCommand.Definition
$WEB_ENV_DIR = $DIR

. "${DIR}\utilities.ps1"

printf "Powershell version "
$PSVersionTable.PSVersion.toString()

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

#$ENV_FILE = $Profile.CurrentUserAllHosts
$ENV_FILE = "${WEB_ENV_DIR}\.env.ps1"
rm "${ENV_FILE}" -ErrorAction Ignore
Out-File $ENV_FILE -Encoding ascii
printf "ENV_FILE = ${ENV_FILE}"

# Add some evironment variables.
setEnvVar 'WEB_ENV_DIR' $DIR
setEnvVar 'APPS_DIR' $appsDir
setEnvVar 'NGINX_CONFS_DIR' "${appsDir}\nginx-confs"
setEnvVar 'SSL_DIR' "${appsDir}\ssl"
setEnvVar 'BACKUP_DIR' "${appsDir}\backup"
setEnvVar 'MONGO_DKR_BKUP_DIR' '/var/lib/mongodb-backup'
setEnvVar 'MONGO_DKR_DATA_DIR' '/var/lib/mongodb'
setEnvVar 'MONGO_DKR_LOG_DIR' '/var/log/mongodb'
setEnvVar 'DOCKER_APPS_DIR' '/code'

$getIpString = '(
    Get-NetIPConfiguration | `
    Where-Object { `
        $_.IPv4DefaultGateway -ne $null `
    -and `
        $_.NetAdapter.Status -ne "Disconnected" `
    } `
).IPv4Address.IPAddress'

if (!$HOST_IP) {
    printf "setting HOST_IP environment var.`n"

    $runtimeVal = Invoke-Expression -Command $getIpString

    # Will be immediately available in PowerShell as a global variable.
    Set-Variable "`$HOST_IP" $runtimeVal -Scope global
    Set-Item "Env:HOST_IP" $HOST_IP
    # Will persist in PowerShell as a global and an environment variable.
    Add-Content -Path $ENV_FILE -Value "`n`$HOST_IP = Get-IpString"
    Add-Content -Path $ENV_FILE -Value "`n`$Env:HOST_IP = `$HOST_IP"
}

Invoke-Expression -Command "& `"${WEB_ENV_DIR}\add-commands.ps1`""

printf "`n**You may need to logout and then log back in order for these changes to take effect!**"