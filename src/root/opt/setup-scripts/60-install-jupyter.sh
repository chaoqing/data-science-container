#!/bin/bash

export CONDA_DIR="${CONDA_DIR:-/opt/conda}"

install_conda() {
}

install_mamba() {
    install_conda

    arch=$(uname -m)
    if [ "${arch}" = "x86_64" ]; then
        # Should be simpler, see <https://github.com/mamba-org/mamba/issues/1437>
        arch="64";
    fi

    cd /tmp

    # https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html#linux-and-macos
    wget --progress=dot:giga -O - "https://micro.mamba.pm/api/micromamba/linux-${arch}/latest" | tar -xvj bin/micromamba
    PYTHON_SPECIFIER="python=${PYTHON_VERSION}"
    if [[ "${PYTHON_VERSION}" == "default" ]]; then PYTHON_SPECIFIER="python"; fi

    # Install the packages
    ./bin/micromamba install \
        --root-prefix="${CONDA_DIR}" \
        --prefix="${CONDA_DIR}" \
        --yes \
        'jupyter_core' \
        'conda' \
        'mamba' \
        "${PYTHON_SPECIFIER}"
    rm -rf /tmp/bin/

    # Pin major.minor version of python
    # https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#preventing-packages-from-updating-pinning
    mamba list --full-name 'python' | awk 'END{sub("[^.]*$", "*", $2); print $1 " " $2}' >> "${CONDA_DIR}/conda-meta/pinned"
    mamba clean --all -f -y
    fix-permissions "/home/${NB_USER}"
}