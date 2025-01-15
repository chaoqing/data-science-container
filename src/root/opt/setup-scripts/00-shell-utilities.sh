#!/bin/bash

test -z "$SHELL_UTITITES_SCRIPTS_INCLUDED" || return

setup_time_logger() {
    echo "[$(date)]: $@"
}

ensure_debian() {
    if [ ! -f /etc/debian_version ]; then
        setup_time_logger "This script is only for Debian-based systems"
        exit 1
    fi
}

ensure_root() {
    if [ "$(id -u)" -ne 0 ]; then
        setup_time_logger "Please run as root"
        exit 1
    fi
}

do_unminimize() {
    test ! -f /etc/update-motd.d/60-unminimize && return

    ensure_debian
    ensure_root

    if ! command -v unmimize &> /dev/null; then
        apt update && apt install -y unminimize
    fi
    yes | unminimize
    rm -f /etc/dpkg/dpkg.cfg.d/excludes.dpkg-tmp

    rm -rf /var/lib/apt/lists/*
}


source_parts() {
for script in "$@"; do
    if [ -f "$script" ]; then
        . "$script"
    fi
done
}

SHELL_UTITITES_SCRIPTS_INCLUDED=1