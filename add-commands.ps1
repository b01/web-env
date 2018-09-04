$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\.env.ps1"

. "${DIR}\utilities.ps1"

$webEnvDir = "${WEB_ENV_DIR}\web-env"
$userModules = "${Env:USERPROFILE}\Documents\WindowsPowerShell\Modules\"
$webEnvModule = "${WEB_ENV_DIR}\Webenv\"

# We move from using profile.ps1 to a self-contained app method.
# Now we still need to supply $WEB_ENV_DIR to the module during
# run-time. So we give the modules its own env file to load.
$webEnvFile = "${webEnvModule}\.env.ps1"
Out-File $webEnvFile -Encoding ascii
Set-Content -Path $webEnvFile -Value "`$WEB_ENV_DIR = '${WEB_ENV_DIR}'" -Encoding String

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