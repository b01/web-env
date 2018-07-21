$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\utilities.ps1"

$webEnvDir = "${APPS_DIR}\web-env"
$userModules = "${Env:USERPROFILE}\Documents\WindowsPowerShell\Modules\"
$webEnvModule = "${webEnvDir}\Webenv\"

# This works, but was not needed after all, left here for reference.
#$envUserPaths = [Environment]::GetEnvironmentVariable('Path', 'User')
#if (!($envUserPaths -like "*${webEnvDir}*")) {
#    printf "Adding to environment PATH: $webEnvDir`n"
#    $envUserPaths = $envUserPaths + "${webEnvDir};"
#    [Environment]::SetEnvironmentVariable('Path', $envUserPaths, 'User')
#}

if (!(Test-Path -Path $userModules)) {
    printf "Making ${userModules} dir."
    md $userModules -Force
}

if (Test-Path -Path "${userModules}\Webenv") {
    Remove-Item "${userModules}\Webenv" -Force -Recurse
}

Copy-Item $webEnvModule $userModules -Recurse -Container