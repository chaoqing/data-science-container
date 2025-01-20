#!/bin/bash

# Non-root not support yet
if [ "$(id -u)" == "0" ]; then
    test ! -x /etc/init.d/ssh || /etc/init.d/ssh start
fi