#!/bin/sh -e

WEB_ENV_DIR="${APPS_DIR}"/web-env

command=$1
commandParams=''

# Skip the first param since that is the actual command.
shift
while [ "$1" != "" ]; do
  commandParams="${commandParams}${1} " && shift;
done;

# Run the actual script and pass all arguments along.
sh "${WEB_ENV_DIR}/${command}.sh" "${commandParams}"