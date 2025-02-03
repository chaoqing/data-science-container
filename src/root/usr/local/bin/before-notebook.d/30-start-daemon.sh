#!/bin/bash

# Daemons here should not be run as root
if [ "$(id -u)" = "0" ]; then
test -n "${USER_NAME}" || return 0
SUDO_PREFIX="sudo -E -u ${USER_NAME}"
else
SUDO_PREFIX=
fi

find_jupyter_enabled_python() {
    PYTHON_EXE=$(command -v python3 2> /dev/null)
    [ -n "${PYTHON_EXE}" ] || return 0

    if ${PYTHON_EXE} -c "import importlib.util; exit(importlib.util.find_spec('jupyter') is None)"; then
        echo ${PYTHON_EXE}
    else
        echo /opt/conda/bin/mamba run python3
    fi
}

start_jupyter_daemon() {
    JUPYTER_ENABLED_PYTHON_PATH=$(find_jupyter_enabled_python)
    JUPYTER_PATH=${JUPYTER_PATH:-"${JUPYTER_ENABLED_PYTHON_PATH} -m jupyter"}
    RESTARTABLE_PREFIX=$(command -v run-one-constantly 2> /dev/null)

    JUPYTER_PASSWORK_FILE=$HOME/.jupyter/jupyter_server_config.json
    if [ ! -f "${JUPYTER_PASSWORK_FILE}" ]; then
        ${SUDO_PREFIX} mkdir -p $(dirname "${JUPYTER_PASSWORK_FILE}")

        echo "using '${JUPYTER_PATH} lab password' to generate password"
        JUPYTER_HASHED_PASSWORD=$($(find_jupyter_enabled_python) -c "from jupyter_server.auth import passwd; print(passwd('${JUPYTER_PASSWORD:-${USER_PASSWORD}}'))")
        ${SUDO_PREFIX} tee "${JUPYTER_PASSWORK_FILE}" > /dev/null <<EOF
{
    "IdentityProvider": {
        "hashed_password": "${JUPYTER_HASHED_PASSWORD}"
    }
}
EOF
    fi

    ( ${SUDO_PREFIX} bash -c "exec ${RESTARTABLE_PREFIX} ${JUPYTER_PATH} lab --ip=0.0.0.0 --port=8888 --no-browser &> /tmp/jupyterlab.log" & ) &
}

if [ "${ENABLE_JUPYTER_SERVICE}" = "1" ]; then
start_jupyter_daemon 
fi


