#!/bin/bash

test -z "$SHELL_UTITITES_SCRIPTS_INCLUDED" || return

export DEBIAN_FRONTEND=noninteractive

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

do_upgrade() {
    ensure_debian
    ensure_root

    # Install all OS dependencies for the Server that starts
    # but lacks all features (e.g., download as all possible file formats)
    apt-get update --yes 
    # - `apt-get upgrade` is run to patch known vulnerabilities in system packages
    #   as the Ubuntu base image is rebuilt too seldom sometimes (less than once a month)
    apt-get upgrade --yes

    rm -rf /var/lib/apt/lists/*
}

install_must_have() {
    ensure_debian
    ensure_root

    apt update
    apt install -y --no-install-recommends bzip2 bash-completion wget curl ca-certificates locales sudo netbase
    apt clean -y

    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    echo "C.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen

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