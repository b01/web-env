#!/bin/bash -e



function getInput() {
    msg=$1
    getInputReturn=$2

    # Prompt the user for this value.
    read -p "${msg}" din1

    if [ -n "${din1}" ]; then
        getInputReturn="${din1}"
    fi
}

elevate_cmd ()
{
    COMMAND=$1
    osascript -e "do shell script \"${COMMAND}\" with administrator privileges"
}


# Mac OS X - Open a command in a new terminal window/tab.
new_tab() {
    COMMAND=$1

    if [ -n "${2}" ] && [ -n "${BASH_VERSION}" ]; then
        osascript \
            -e "tell application \"Terminal\"" \
            -e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
            -e "do script \"printf '\\\e]1;${2}\\\a'; ${COMMAND}\" in front window" \
            -e "end tell" > /dev/null
    else
        osascript \
            -e "tell application \"Terminal\"" \
            -e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
            -e "do script \"${COMMAND}\" in front window" \
            -e "end tell" > /dev/null
    fi
}

snore()
{
    read -t $1 -u 1
}