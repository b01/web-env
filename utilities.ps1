# you may need to run, before you can use this script:
# Try running, in an elevated PS prompt: Set-ExecutionPolicy RemoteSigned
# - or -
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Persist in PowerShell user profile script as a global variable.
function addPsEnvVar() {
    param ($file, $envName, $envVal)

    Add-Content -Path $file -Value "`n`$${envName} = ${envVal}"
}

function newWindow {
    param($cmd, $dir)

    Start-Process -FilePath powershell.exe -Args "${cmd} ; pause" -Verb open -WorkingDirectory "${dir}"
}

function printf {
    param($str)

    Write-Output "${str}"
}

# Replace content in a file.
function regReplace {
    param($file, $lookup, $val)

    (Get-Content $file) -replace $lookup, $val | Set-Content $file -Encoding String
}

# Set an envrionment variable for:
#   Current seession,
#   User Profile,
#   and Powershell profile
function setEnvVar {
    param ($envName, $envVal)

    # Add as an evironment variable to current sessions.
    Set-Item "Env:${envName}" "${envVal}"
    Set-Variable -Name "${envName}" -Value "${envVal}" -Scope global

    setUserEnvVar $envName $envVal
    setPsProfileVar "`Env:${envName}" "'${envVal}'"
    setPsProfileVar "${envName}" "'${envVal}'"
}

# Persist environment variable in the Powsershell profile
function setPsProfileVar
{
    param ($envName, $envVal)

    $exists = [bool](Get-Variable $envName -Scope "Global" -EA "Ig")
    $regEx = "\`$${envName} =.*"
    $regExRpl = "(?>=<\`$${envName} =.*)"

    $content = (Get-Content $ENV_FILE)
    if ($content -match $regEx) {
        regReplace $ENV_FILE $regExRpl $envVal
        printf "Updated Powershell Env varaible ${envName}"
    } else {
        addPsEnvVar $ENV_FILE $envName $envVal
        printf "Set Powershell Env varaible ${envName}"
    }
}

# Persist environment variable in the User profile
# Note: This will show up in Environment Variables UI and $Env: drive.
function setUserEnvVar
{
    param ($envName, $envVal)

    [Environment]::SetEnvironmentVariable($envName, $envVal, 'User')

    printf "Set User Env Variable ${envName} = ${envVal}"
}