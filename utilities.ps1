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

    # Add as an evironment/global variable to current sessions.
    Set-Item "Env:${envName}" "${runtimeVal}"
    Set-Variable "${envName}" "${runtimeVal}" -Scope global

    # Persist the value in the User profile:
    # Will show up in Environment Variables UI and $Env: drive.
    [Environment]::SetEnvironmentVariable($envName, $envVal, 'User')
    # Will be available in PowerShell as a global variable.
    Add-Content -Path $Profile.CurrentUserAllHosts -Value "`$${envName} = `$Env:${envName}"
}