#!/bin/bash -e

$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\utilities.ps1"


if (!$APPS_DIR) {
    printf "APPS_DIR environment variable is not set, please set it before running this command.`n"
    printf "Did you forget to run the `"initial-setup.ps1`" command?`n"
    exit 1
}

$APPS_ENV_FILE = "${DIR}\apps.env"
rm "${APPS_ENV_FILE}" -ErrorAction Ignore
Out-File $APPS_ENV_FILE -Encoding utf8

$envFiles = Get-ChildItem "${APPS_DIR}\*\web-env\env-vars.txt"

# Loop though all arguments passed to this script.
foreach ($envFile in $envFiles) {
    printf "# ${envFile}" | Out-File $APPS_ENV_FILE -Encoding utf8 -Append

    foreach($line in Get-Content $envFile.ToString()) {
        $envValue = (Get-Item Env:$line).Value
        printf "${line}=`"${envValue}`"" | Out-File $APPS_ENV_FILE -Encoding utf8 -Append
    }
}

if ((Test-Path -Path $APPS_ENV_FILE) -eq $false) {
    printf "Could not build an apps.env file: ${APPS_ENV_FILE}`n"
} else {
    printf "Done building environment variables file: ${APPS_ENV_FILE}`n"
}