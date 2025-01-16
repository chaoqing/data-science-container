#!/bin/bash

set -e
. /opt/setup-scripts/00-shell-utilities.sh

install_xfce4() {
apt-get update
apt-get install -y xfce4 xfce4-terminal xfce4-goodies xterm dbus-x11 libdbus-glib-1-2
apt-get purge -y pm-utils *screensaver*
apt-get clean -y

rm -rf /var/lib/apt/lists/*
}

install_openbox() {
apt-get update
apt-get install -y openbox xterm dbus-x11 libdbus-glib-1-2
apt-get purge -y pm-utils *screensaver*
apt-get clean -y

rm -rf /var/lib/apt/lists/*
}

install_browser() {
    . /opt/setup-scripts/install-desktop.d/50-install-firefox.sh
}

install_vncserver() {
    if [ "${DESKTOP_TYPE}" == "xfce4" ]; then
        install_xfce4
    elif [ "${DESKTOP_TYPE}" == "openbox" ]; then
        install_openbox
    else
        echo "Unknown desktop type: $DESKTOP_TYPE"
        exit 1
    fi

    apt-get update
    . /opt/setup-scripts/install-desktop.d/10-install-vncserver.sh
    install_browser
    apt-get clean -y
}

install_novnc() {
    install_vncserver

    . /opt/setup-scripts/install-desktop.d/90-install-noVNC.sh
}