#!/bin/bash

create_utility_list() {

UTITILIES_BASE=()
UTITILIES_BASE+=(man-db)
UTITILIES_BASE+=(plocate)
UTITILIES_BASE+=(command-not-found)
UTITILIES_BASE+=(zsh)
UTITILIES_BASE+=(curl)
UTITILIES_BASE+=(wget)
UTITILIES_BASE+=(rsync)
UTITILIES_BASE+=(git)
UTITILIES_BASE+=(vim-nox)
UTITILIES_BASE+=(htop)
UTITILIES_BASE+=(tmux)
UTITILIES_BASE+=(screen)
UTITILIES_BASE+=(tree)
UTITILIES_BASE+=(unar)
UTITILIES_BASE+=(unzip)
UTITILIES_BASE+=(zip)
UTITILIES_BASE+=(jq)
UTITILIES_BASE+=(psmisc)
UTITILIES_BASE+=(lsof)
UTITILIES_BASE+=(ttf-wqy-zenhei)

UTITILIES_NETWORK=()
UTITILIES_NETWORK+=(dnsutils)
UTITILIES_NETWORK+=(net-tools)
UTITILIES_NETWORK+=(iputils-ping)
UTITILIES_NETWORK+=(iproute2)
UTITILIES_NETWORK+=(tcpdump)
UTITILIES_NETWORK+=(nmap)
UTITILIES_NETWORK+=(telnet)
UTITILIES_NETWORK+=(socat)
UTITILIES_NETWORK+=(ncat)

IFS=' ' read -r -a utitilies <<< "${UTITILIES_EXTRA:-$@}"
IFS=' ' read -r -a utitilies_group <<< "${UTITILIES_GROUP:-BASE}"

for group in "${utitilies_group[@]}"; do
case "${group}" in
    BASE)
        utitilies+=("${UTITILIES_BASE[@]}")
        ;;
    NETWORK)
        utitilies+=("${UTITILIES_NETWORK[@]}")
        ;;
    *)
        ;;
esac
done

echo "${utitilies[@]}"
}

install_useful_tools() {
    apt update && apt install -y $(create_utility_list "$@") && rm -rf /var/lib/apt/lists/*
}
