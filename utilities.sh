#!/bin/bash -e

# Mac OS X - Open a command in a new terminal window/tab.
new_tab() {
    TAB_NAME=$1
    COMMAND=$2
    osascript \
        -e "tell application \"Terminal\"" \
        -e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
        -e "do script \"printf '\\\e]1;$TAB_NAME\\\a'; $COMMAND\" in front window" \
        -e "end tell" > /dev/null
}
