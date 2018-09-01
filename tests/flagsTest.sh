#!/bin/sh

set -e

TST_DIR=$( cd "$(dirname ${0})" && pwd)
SRC_DIR=$( cd "${TST_DIR}/.." && pwd)

function flagDebug() {
    echo "args set:"
    echo '-----------'
    echo "cname = ${cname}"
    echo "dcFile = ${dcFile}"
    echo "iaterm = ${iaterm}"
    echo "nWin = ${nWin}"
    echo ''
}

echo ''
echo "testing: ${SRC_DIR}/flags.sh"
echo ''

source "${SRC_DIR}"/flags.sh -w 1 -f test
if [ -z "${nWin}" ] || [ "${dcFile}" != "test" ]; then
    printf "E"
    exit 1
else

    printf "."
fi

source "${SRC_DIR}"/flags.sh -w 1 -f test -c ap -n nx
if [ -z "${nWin}" ] || [ "${dcFile}" != "test" ] || [ "${cname}" != "ap" ] || [ "${iaterm}" != "nx" ]; then
    printf "E"
    exit 1
else

    printf "."
fi

echo ''
echo 'PASSED!'