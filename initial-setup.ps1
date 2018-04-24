


# Check APPS_DIR environment variable is defined.
if (!$env:APPS_DIR) {
    $homeDrive = Split-Path -qualifier $HOME

    printf "Home drive is ${homeDrive}`n"

    $networkDisk = Gwmi Win32_LogicalDisk -filter "DriveType = 4 AND DeviceID = '$homeDrive'"

    if ($networkDisk) {
        $APPS_DIR=$("C:\${env:USERNAME}\code")
        printf "Home is is network drive: ${logicalDisk}`n"
    } else {
        $APPS_DIR="${HOME}\code"
    }

    printf "Environment variable APPS_DIR is empty, setting to ${APPS_DIR}`n"

    [Environment]::SetEnvironmentVariable("APPS_DIR", $APPS_DIR, "User")
}

# Check NGINX_CONFS_DIR environment variable is defined.
if (!$env:NGINX_CONFS_DIR) {
    $NGINX_CONFS_DIR="${APPS_DIR}\nginx-confs"
    printf "Environment variable NGINX_CONFS_DIR is empty, setting to ${NGINX_CONFS_DIR}"
    [Environment]::SetEnvironmentVariable("NGINX_CONFS_DIR", $NGINX_CONFS_DIR, "User")
}

