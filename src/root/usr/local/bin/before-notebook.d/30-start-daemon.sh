#!/bin/bash

# Daemons here should not be run as root
[ "$(id -u)" != "0" ] || return 0

find_jupyter_enabled_python() {
    PYTHON_EXE=$(command -v python3 2> /dev/null)
    [ -n "${PYTHON_EXE}" ] || return 0

    if ${PYTHON_EXE} -c "import importlib.util; exit(importlib.util.find_spec('jupyter') is None)"; then
        echo ${PYTHON_EXE} -m jupyter
    else
        echo /opt/conda/bin/mamba run python3 -m jupyter
    fi
}

start_jupyter_daemon() {
    JUPYTER_PATH=${JUPYTER_PATH:-$(find_jupyter_enabled_python)}

    if [ "${RESTARTABLE}" == "1" ]; then
        RESTARTABLE_PREFIX=$(command -v run-one-constantly 2> /dev/null)
    fi
    ( ${RESTARTABLE_PREFIX} ${JUPYTER_PATH} lab --ip=0.0.0.0 --port=8888 --no-browser &> /tmp/jupyterlab.log & ) &
}

if [ "${ENABLE_JUPYTER_SERVICE}" = "1" ]; then
start_jupyter_daemon 
fi


