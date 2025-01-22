#!/bin/bash

set -e

. /opt/setup-scripts/00-shell-utilities.sh

[ ! -f /etc/os-release ] || . /etc/os-release

export R_HOME=${R_HOME:-"/usr/local/lib/R"}
export R_VERSION=${R_VERSION:-latest}
export PURGE_BUILDDEPS=${PURGE_BUILDDEPS:-"false"}
export NCPUS=${NCPUS:-$(nproc)}
export RSTUDIO_VERSION=${1:-${RSTUDIO_VERSION:-"stable"}}
export DEFAULT_USER=${USER_NAME:-${NB_USER}}

export TZ="Etc/UTC"
export CRAN="https://p3m.dev/cran/__linux__/${VERSION_CODENAME:-jammy}/latest"
export LANG=en_US.UTF-8
export NVBLAS_CONFIG_FILE="/etc/nvblas.conf"

setup_time_logger " ======= Compile R from source ======="
/opt/setup-scripts/install-rstudio.d/10-install_R_source.sh
/opt/setup-scripts/install-rstudio.d/20-setup_R.sh
/opt/setup-scripts/install-rstudio.d/30-config_R_cuda.sh
setup_time_logger " ======= Installing Packages ======="
/opt/setup-scripts/install-rstudio.d/40-install_tidyverse.sh
setup_time_logger " ======= Installing RStudio ======="
/opt/setup-scripts/install-rstudio.d/50-install_rstudio.sh
/opt/setup-scripts/install-rstudio.d/60-install_pandoc.sh
/opt/setup-scripts/install-rstudio.d/70-install_quarto.sh
/opt/setup-scripts/install-rstudio.d/80-install_verse.sh
/opt/setup-scripts/install-rstudio.d/90-install_geospatial.sh
setup_time_logger " ======= Installing Shiny ======="
/opt/setup-scripts/install-rstudio.d/95-install_shiny_server.sh
