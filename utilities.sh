#!/bin/bash -e

# Mac OS X - Open a command in a new terminal window/tab.
new_tab() {
    COMMAND=$1
    TAB_NAME=''

    if [ -n "${2}" ] && [ -n "${BASH_VERSION}" ]; then
        TAB_NAME="printf '\\\e]1;${1}\\\a'; "
    fi

    # Open a new tab
    #-e "do script \"${TAB_NAME} ${COMMAND}\" in front window" \
    osascript \
        -e "tell application \"Terminal\"" \
        -e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
        -e "do script \"${TAB_NAME}${COMMAND}\" in front window" \
        -e "end tell" > /dev/null
}

snore()
{
    read -t $1 -u 1
}