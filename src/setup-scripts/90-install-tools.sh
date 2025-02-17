#!/bin/bash

set -e

create_utility_list() {

UTITILIES_BASIC=()
UTITILIES_BASIC+=(man-db)
UTITILIES_BASIC+=(plocate)
UTITILIES_BASIC+=(command-not-found)
UTITILIES_BASIC+=(zsh)
UTITILIES_BASIC+=(curl)
UTITILIES_BASIC+=(wget)
UTITILIES_BASIC+=(rsync)
UTITILIES_BASIC+=(ncdu)
UTITILIES_BASIC+=(git)
UTITILIES_BASIC+=(vim-nox)
UTITILIES_BASIC+=(htop)
UTITILIES_BASIC+=(tmux)
UTITILIES_BASIC+=(rename)
UTITILIES_BASIC+=(screen)
UTITILIES_BASIC+=(tree)
UTITILIES_BASIC+=(unar)
UTITILIES_BASIC+=(unzip)
UTITILIES_BASIC+=(zip)
UTITILIES_BASIC+=(jq)
UTITILIES_BASIC+=(psmisc)
UTITILIES_BASIC+=(lsof)
UTITILIES_BASIC+=(pipx)
UTITILIES_BASIC+=(ttf-wqy-zenhei)
UTITILIES_BASIC+=(fonts-noto)
UTITILIES_BASIC+=(openssh-server)
UTITILIES_BASIC+=(doxygen)
UTITILIES_BASIC+=(gettext)
UTITILIES_BASIC+=(git-lfs)
UTITILIES_BASIC+=(libtalloc2)
UTITILIES_BASIC+=(libtool)
UTITILIES_BASIC+=(luarocks)
UTITILIES_BASIC+=(ninja-build)
UTITILIES_BASIC+=(pkg-config)
UTITILIES_BASIC+=(ripgrep)
UTITILIES_BASIC+=(samba)
UTITILIES_BASIC+=(inotify-tools)
UTITILIES_BASIC+=(dialog)

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
UTITILIES_NETWORK+=(w3m)

UTITILIES_EXTRA=()
UTITILIES_EXTRA+=(orca) # For R plotly saving images
UTITILIES_EXTRA+=(zeal)
UTITILIES_EXTRA+=(graphviz)
UTITILIES_EXTRA+=(ccache)
UTITILIES_EXTRA+=(clang)
UTITILIES_EXTRA+=(clang-format)
UTITILIES_EXTRA+=(clang-tidy)
UTITILIES_EXTRA+=(clang-tools)
UTITILIES_EXTRA+=(valgrind)
UTITILIES_EXTRA+=(fonts-noto-cjk-extra)
UTITILIES_EXTRA+=(webhttrack)
UTITILIES_EXTRA+=(nginx)

IFS=' ' read -r -a utitilies_group <<< "${@:-BASIC}"

utitilies=()
for group in "${utitilies_group[@]}"; do
case "${group}" in
    BASIC)
        utitilies+=("${UTITILIES_BASIC[@]}")
        ;;
    NETWORK)
        utitilies+=("${UTITILIES_NETWORK[@]}")
        ;;
    EXTRA)
        utitilies+=("${UTITILIES_EXTRA[@]}")
        ;;
    *)
        utitilies+=("${group}")
        ;;
esac
done

echo "${utitilies[@]}"
}

configure_ssh() {
    test ! -f /etc/ssh/sshd_config || sudo sed -i 's/^#Port 22/Port 8022/' /etc/ssh/sshd_config
    chmod 600 /etc/ssh/ssh_host_*key || true
}

install_useful_tools() {
    apt update && apt install -y $(create_utility_list "$@") && rm -rf /var/lib/apt/lists/*

    configure_ssh
}
