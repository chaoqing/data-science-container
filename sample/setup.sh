#!/bin/bash

export() {
    if test $# -eq 0; then
    echo "usage: $0 export container_name"
    exit 1
    fi

docker exec ${1} tar -cvpf - \
        --exclude=/swap.img \
        --exclude=/boot/* \
        --exclude=/tmp/* \
        --exclude=/var/tmp/* \
        --exclude=/var/log/* \
        --exclude=/var/lib/apt/* \
        --exclude=/var/cache/* \
        --exclude=/lib/modules/* \
        --exclude=/lib/firmware/* \
        --one-file-system / \
        | cat > build/obuntu.tar
}

"$@"