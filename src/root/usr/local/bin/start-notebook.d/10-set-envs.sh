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