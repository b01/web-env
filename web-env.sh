#!/bin/bash -e

if [ -z "${APPS_DIR}" ] && [ -z "${BASH_VERSION}" ]; then
    source ~/.bash_profile
fi

command=''

# Filter and shorten the commands that can be run though this script.
case $1 in
    ca)
        command="config-app"
        ;;
    cp)
        command="copies"
        ;;
    up)
        command="start"
        ;;
    dn)
        command="stop"
        ;;
    *)
        echo "Unknown command: ${1}. Please use one of the following:"
        echo ""
        cat "${WEB_ENV_DIR}"/help.md
        ;;
esac

# Run the actual script and pass all arguments (excluding the first) along.
if [ -n "${command}" ]; then
    shift
    bash -e "${WEB_ENV_DIR}/${command}".sh $@
fi