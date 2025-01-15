#!/bin/bash

set -e

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