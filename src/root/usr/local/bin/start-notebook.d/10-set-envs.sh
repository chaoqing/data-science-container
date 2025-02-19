#!/bin/bash

if test -n "$USER_GROUP"; then
    export NB_GROUP=${USER_GROUP}
fi
if test -n "$USER_GID"; then
    export NB_GID=${USER_GID}
fi
if test -n "$USER_NAME"; then
    export NB_USER=${USER_NAME}
fi
if test -n "$USER_UID"; then
    export NB_UID=${USER_UID}
fi

if test -n "$VNC_PW"; then
    export VNC_PW=${USER_PASSWORD}
fi

test ! -d /opt/hpcx/ucx/lib/ || export LD_LIBRARY_PATH=/opt/hpcx/ucx/lib/:$LD_LIBRARY_PATH
