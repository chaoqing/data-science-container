#!/bin/bash

PYTHON_VERSION=${PYTHON_VERSION:-default}
export CONDA_DIR="${CONDA_DIR:-/opt/conda}"
export MAMBA_ROOT_PREFIX="${CONDA_DIR}"

install_mamba() {
    arch=$(uname -m)
    if [ "${arch}" = "x86_64" ]; then
        # Should be simpler, see <https://github.com/mamba-org/mamba/issues/1437>
        arch="64";
    fi

    # https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html#linux-and-macos
    wget --progress=dot:giga -O - "https://micro.mamba.pm/api/micromamba/linux-${arch}/latest" | tar -xvj -C /tmp bin/micromamba
    if [ "${PYTHON_VERSION}" = "default" ]; then
        PYTHON_SPECIFIER="python"
    else
        PYTHON_SPECIFIER="python=${PYTHON_VERSION}"
    fi

    # Install the packages
    /tmp/bin/micromamba install \
        --root-prefix="${CONDA_DIR}" \
        --prefix="${CONDA_DIR}" \
        --yes \
        'conda' \
        'mamba' \
        "${PYTHON_SPECIFIER}"
    rm -rf /tmp/bin/

    # Pin major.minor version of python
    # https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#preventing-packages-from-updating-pinning
    ${MAMBA_ROOT_PREFIX}/bin/mamba list --full-name 'python' | awk 'END{sub("[^.]*$", "*", $2); print $1 " " $2}' >> "${CONDA_DIR}/conda-meta/pinned"
    ${MAMBA_ROOT_PREFIX}/bin/mamba clean --all -f -y
}

install_pyenv() {
    PYENV_VERSION=${1:-${PYENV_VERSION:-v2.5.1}}
    echo git clone --branch=${PYENV_VERSION} --depth 1 https://github.com/pyenv/pyenv.git /opt/pyenv
}

install_poetry() {
    POETRY_VERSION=${1:-${POETRY_VERSION}}

    if  [ -z "$POETRY_VERSION" ]; then
    curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry_1.8 python3 - --version 1.8.4
    curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry_2 python3 - --version 2.0.0
    env -C /opt ln -s poetry_2 poetry
    else
    curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 - --version ${POETRY_VERSION}
    fi
}

create_python_packages_list() {

COMMON=()

CONDA=()
CONDA+=('altair')
CONDA+=('beautifulsoup4')
CONDA+=('bokeh')
CONDA+=('bottleneck')
CONDA+=('cloudpickle')
CONDA+=('conda-forge::blas=*=openblas')
CONDA+=('cython')
CONDA+=('dask')
CONDA+=('dill')
CONDA+=('h5py')
CONDA+=('ipympl')
CONDA+=('ipywidgets')
CONDA+=('jupyterlab-git')
CONDA+=('matplotlib-base')
CONDA+=('numba')
CONDA+=('numexpr')
CONDA+=('openpyxl')
CONDA+=('pandas')
CONDA+=('patsy')
CONDA+=('protobuf')
CONDA+=('pytables')
CONDA+=('scikit-image')
CONDA+=('scikit-learn')
CONDA+=('scipy')
CONDA+=('seaborn')
CONDA+=('sqlalchemy')
CONDA+=('statsmodels')
CONDA+=('sympy')
CONDA+=('widgetsnbextension')
CONDA+=('xlrd')

JUPYTER=()
JUPYTER+=('jupyter_core')
JUPYTER+=('jupyterhub-singleuser')
JUPYTER+=('jupyterlab')
JUPYTER+=('nbclassic')
JUPYTER+=('notebook>=7.2.2')

R=()
R+=('r-base')
R+=('r-caret')
R+=('r-crayon')
R+=('r-devtools')
R+=('r-e1071')
R+=('r-forecast')
R+=('r-hexbin')
R+=('r-htmltools')
R+=('r-htmlwidgets')
R+=('r-irkernel')
R+=('r-nycflights13')
R+=('r-randomforest')
R+=('r-rcurl')
R+=('r-rmarkdown')
R+=('r-rodbc')
R+=('r-rsqlite')
R+=('r-shiny')
R+=('r-tidymodels')
R+=('r-tidyverse')
R+=('rpy2')
R+=('unixodbc')


APT=()
APT+=('python3-pip')
APT+=('python3-numexpr')
APT+=('python3-skimage')
APT+=('python3-h5py')
APT+=('python3-openpyxl')
APT+=('python3-altair')
APT+=('python3-patsy')
APT+=('python3-seaborn')


APT+=('python3-ipywidgets')
APT+=('python3-sqlalchemy')
APT+=('python3-statsmodels')
APT+=('python3-widgetsnbextension')
APT+=('python3-xlrd')
APT+=('python3-pyodbc')

PIP=()
PIP+=('kaleido')
PIP+=('ipympl')
PIP+=('bottleneck') # python3-bottleneck may have conflict with pandas so upgrade it with pip
PIP+=('numexpr') # python3-numexpr may have conflict with pandas so upgrade it with pip
PIP+=('tables') # python3-tables may have conflict with pandas so upgrade it with pip

EXTRA=()
EXTRA+=('rainbow-api')

IFS=' ' read -r -a packages_group <<< "${@:-COMMON}"

packages=()
for group in "${packages_group[@]}"; do
case "${group}" in
    COMMON)
        packages+=("${COMMON[@]}")
        ;;
    CONDA)
        packages+=("${CONDA[@]}")
        ;;
    JUPYTER)
        packages+=("${JUPYTER[@]}")
        ;;
    R)
        packages+=("${R[@]}")
        ;;
    APT)
        packages+=("${APT[@]}")
        ;;
    PIP)
        packages+=("${PIP[@]}")
        ;;
    EXTRA)
        packages+=("${EXTRA[@]}")
        ;;
    *)
        packages+=("${group}")
        ;;
esac
done

echo "${packages[@]}"
}

install_jupyter_facets() {
git clone https://github.com/PAIR-code/facets
${PYTHON_RUN_PREFIX} jupyter nbclassic-extension install facets/facets-dist/ --sys-prefix
rm -rf facets
}

configure_python() {

    ${PYTHON_RUN_PREFIX} jupyter server --generate-config
    ${PYTHON_RUN_PREFIX} jupyter lab clean

## Import matplotlib the first time to build the font cache
# ${PYTHON_RUN_PREFIX} env MPLBACKEND=Agg python -c "import matplotlib.pyplot"

}

install_packages_with_venv() {
    ${MAMBA_ROOT_PREFIX}/bin/mamba install --yes $(create_python_packages_list COMMON CONDA JUPYTER R)
    PYTHON_RUN_PREFIX="${MAMBA_ROOT_PREFIX}/bin/mamba run" install_jupyter_facets
    PYTHON_RUN_PREFIX="${MAMBA_ROOT_PREFIX}/bin/mamba run" configure_python
    ${MAMBA_ROOT_PREFIX}/bin/mamba run pip install --no-cache-dir $(create_python_packages_list PIP "$@")

    ${MAMBA_ROOT_PREFIX}/bin/mamba clean --all -f -y
}

install_packages_with_system() {
    apt update 
    apt install -y $(create_python_packages_list APT) 
    rm -rf /var/lib/apt/lists/*

    python3 -m pip install --no-cache-dir --break-system-packages --upgrade $(create_python_packages_list COMMON PIP "$@")
    PYTHON_RUN_PREFIX="python3 -m" install_jupyter_facets
    PYTHON_RUN_PREFIX="python3 -m" configure_python

    # NVIDIA images have workspace here
    test ! -d /workspace || rm -rf /workspace/
}

install_to_seperate_env() {
    command -v python3 &> /dev/null || return 0
    python3 -c "import importlib.util; exit(any(importlib.util.find_spec(pkg) is None for pkg in ['pip', 'pandas', 'matplotlib', 'jupyterlab']))" || return 0

    return 1
}

install_env_managers() {
    install_mamba
    install_pyenv
    install_poetry
}

install_python_analysis_tools() {
install_env_managers
if [ "${USE_CONDA_ENV:-0}" = "1" ] || install_to_seperate_env; then
    install_packages_with_venv "$@"
else
    install_packages_with_system "$@"
fi
    rm -rf ~/.cache ~/.local/share/virtualenv
}
