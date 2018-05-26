# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

function printf () {
    param($str)

    Write-Output "${str}"
}

function setUserEnvVar() {
    param($envName, $envVal, $level = "User")

    Write-Output "Setting ${envName} = ${envVal}`n"

    # Add the environement variable to every seesion.
    $Env:envName = $envValue

    Add-Content -Path $Profile.CurrentUserAllHosts -Value "`$Env:${envName} = ${envVal}"

    # Persist the value in the chosen profile.
    [Environment]::SetEnvironmentVariable($envName, $envVal, $level)
}