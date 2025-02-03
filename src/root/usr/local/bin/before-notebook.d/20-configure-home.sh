#!/bin/bash

get_user_home() {
    test -n "$1" || return 0
    getent passwd $1 | cut -d: -f6
}

sync_etc_skel() {
    test -n "$1" || return 0
    USER=$1
    HOME=$(get_user_home ${USER}) 

    test ! -f $HOME/.skip.skel || return 0
    sudo -u ${USER} rsync -rlptDv --ignore-existing /etc/skel/ $HOME/

    chmod 600 $HOME/.vnc/passwd || true
}

fix_home_permissions() {
    test -n "$1" || return 0
    USER=$1
    HOME=$(get_user_home ${USER}) 

    if sudo -u $1 test ! -r "$HOME"; then
        sudo -E chown -R $USER "$HOME"
    fi
}

if command -v sudo &>/dev/null; then
if  [ "$(id -u)" == "0" ] ; then
    test -n "$USER_NAME" || USER_NAME=$(id -un ${USER_UID})

    fix_home_permissions ${USER_NAME}
    sync_etc_skel ${USER_NAME}
fi
fi
