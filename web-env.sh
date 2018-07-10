#!/bin/bash -e

WEB_ENV_DIR="${APPS_DIR}"/web-env

command=''

#filter and shorten the commands that can be run though this script.
case $1 in
    ca)
        command="config-app"
        break
        ;;
    start)
        command=$1
        break
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
    bash -e "${WEB_ENV_DIR}"/"${command}".sh $@
fi