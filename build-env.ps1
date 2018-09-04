
$DIR = split-path -parent $MyInvocation.MyCommand.Definition

. "${DIR}\.env.ps1"

. "${DIR}\utilities.ps1"

if (!$APPS_DIR) {
    printf "APPS_DIR environment variable is not set, please set it before running this command.`n"
    printf "Did you forget to run the `"initial-setup.ps1`" command?`n"
    exit 1
}

$APPS_ENV_FILE = "${WEB_ENV_DIR}\apps.env"
rm "${APPS_ENV_FILE}" -ErrorAction Ignore
Out-File $APPS_ENV_FILE -Encoding ascii
$content = ''

$envFiles = Get-ChildItem "${APPS_DIR}\*\web-env\env-vars.txt"

# Loop though all arguments passed to this script.
foreach ($envFile in $envFiles) {
    $content = "${content}# ${envFile}`n"

    foreach($line in Get-Content $envFile.ToString()) {
        $envValue = (Get-Item Env:$line).Value

        if ($envValue) {
            $content = "${content}${line}=${envValue}`n"
        } else {
            printf "Environment variable ${line} is not set and is required for ${envFile}`n"
        }
    }
}

Set-Content -Path $APPS_ENV_FILE -Value $content -Encoding String

if ((Test-Path -Path $APPS_ENV_FILE) -eq $false) {
    printf "Could not build an apps.env file: ${APPS_ENV_FILE}`n"
} else {
    printf "Done building environment variables file: ${APPS_ENV_FILE}`n"
}