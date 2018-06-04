# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

function printf () {
    param($str)

    Write-Output "${str}"
}

function setUserEnvVar() {
    param($envName, $envVal, $expand=$false)

    $runtimeVal = $envVal

    if ($expand -eq $true) {
        $runtimeVal = Invoke-Expression -Command $envVal
    }

    Write-Output "Setting ${envName} = ${runtimeVal}`n"

    # Add the environement variable to every seesion.
    Set-Item "Env:${envName}" "${runtimeVal}"

    # Persist the value in the chosen profile.
    [Environment]::SetEnvironmentVariable($envName, $envVal, 'User')
}

function setPowerShellUserEnvVar() {
    param($envName, $envVal, $expand=$false)

    $runtimeVal = $envVal

    if ($expand -eq $true) {
        $runtimeVal = Invoke-Expression -Command $envVal
    }

    Write-Output "Setting ${envName} = ${runtimeVal}`n"

    # Add the environement variable to every seesion.
#    Set-Item "Env:${envName}" "${runtimeVal}"

    # Persist the value in the user profile.
    Add-Content -Path $Profile.CurrentUserAllHosts -Value "`$${envName} = ${envVal}"
}