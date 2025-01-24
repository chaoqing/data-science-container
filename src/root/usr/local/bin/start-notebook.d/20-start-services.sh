#!/bin/bash

# Non-root not support yet
[ "$(id -u)" == "0" ] || return 0

if  [ "${ENABLE_SSH_SERVICE}" = "1" ]; then
    test ! -x /etc/init.d/ssh || /etc/init.d/ssh start
fi

if [ "${ENABLE_RSTUDIO_SERVICE}" = "1" ]; then
    test ! -x /etc/init.d/rstudio-server || /etc/init.d/rstudio-server start
fi