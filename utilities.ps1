# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

function newWindow() {
    param($cmd, $dir)

    Start-Process -FilePath powershell.exe -Args "${cmd}" -Verb open -WorkingDirectory "${dir}"
}

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

    # Add as an evironment and a global variable to current sessions.
    Set-Item "Env:${envName}" "${runtimeVal}"
    Set-Variable -Name "${envName}" -Value "${runtimeVal}" -Scope global

    # Persist the value in the User profile (will show up in Environment Variables UI and $Env: drive).
    [Environment]::SetEnvironmentVariable($envName, $envVal, 'User')

    # Persist in PowerShell as a global variable.
    Add-Content -Path $Profile.CurrentUserAllHosts -Value "`$${envName} = `$Env:${envName}"
}