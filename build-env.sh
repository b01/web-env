#!/bin/bash -e

if [ -z "${APPS_DIR}" ]; then
    printf "APPS_DIR environment variable is not set, please set it before running this command.\n"
    printf "Did you forget to run the \"initial-setup.sh\" command?\n"
    exit 1
fi

DIR=$( cd "$( dirname "$0" )" && pwd )
APPS_ENV_FILE="${DIR}/apps.env"

shopt -s nullglob
envFiles=("${APPS_DIR}"/*/web-env/env-vars.txt)
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later
#DEBUG: echo "${envFiles[@]}"  # Note double-quotes to avoid extra parsing of funny characters in filenames

rm -rf "${APPS_ENV_FILE}"
touch "${APPS_ENV_FILE}"

# Loop though all arguments passed to this script.
for envFile in "${envFiles[@]}"
do
    echo "# ${envFile}" >> "${APPS_ENV_FILE}"
    while read -r line || [[ $line ]]; do
        echo "${line}=\"${!line}\"" >> "${APPS_ENV_FILE}"
    done < "${envFile}"

    echo "" >> "${APPS_ENV_FILE}"
done

printf "Done building environment variables file: ${APPS_ENV_FILE}\n"