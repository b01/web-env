# Copy ${APP_NAME} environment variables over to "${APP_CONTAINER}".\n"
copyEnvVars () {
    WEB_ENV_DIR=""
    APP_NAME=""
    APP_CONTAINER=""
    envTxtFile="${WEB_ENV_DIR}/env-vars.txt"

    if [ -f "${envTxtFile}" ]; then
        printf "Copying ${APP_NAME} environment variables over to "${APP_CONTAINER}".\n"
        E_FILE="${DIR}/${APP_NAME}-env-vars.txt"
        rm -rf "${E_FILE}"
        touch "${E_FILE}"

        while read -r line || [[ $line ]]; do
            echo "export ${line}=\"${!line}\"" >> "${E_FILE}"
        done < "${envTxtFile}"

        docker cp "${E_FILE}" "${APP_CONTAINER}":/root/env-vars.txt
        docker exec "${APP_CONTAINER}" chown -R root:root /root/env-vars.txt

        docker cp "${DIR}"/resources/append-vars.sh "${APP_CONTAINER}":/root/append-vars.sh
        docker exec "${APP_CONTAINER}" chown -R root:root /root/append-vars.sh
        docker exec "${APP_CONTAINER}" chmod a+x /root/append-vars.sh
        docker exec -i "${APP_CONTAINER}" /root/append-vars.sh
        printf "Copied ${APP_NAME} ENV vars to "${APP_CONTAINER}".\n"
    fi
}