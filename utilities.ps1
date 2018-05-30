# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

function printf () {
    param($str)

    Write-Output "${str}"
}

function setUserEnvVar() {
    param($envName, $envVal, $quote=$true, $expand=$false)

    $envValue = $envVal
    $runtimeVal = $envVal

    if ($quote -eq $true) {
        $envValue = "`"${envVal}`""
    }

    if ($expand -eq $true) {
        $runtimeVal = Invoke-Expression -Command $envVal
    }

    Write-Output "Setting ${envName} = ${runtimeVal}`n"

    # Add the environement variable to every seesion.
    Set-Item "Env:${envName}" "${runtimeVal}"

    # Persist the value in the user profile.
    Add-Content -Path $Profile.CurrentUserAllHosts -Value "`$Env:${envName} = ${envValue}"
}