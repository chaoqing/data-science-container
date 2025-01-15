ARG ROOT_IMAGE=nvcr.io/nvidia/pytorch:24.12-py3

FROM $ROOT_IMAGE AS base

ADD root/ /

RUN bash -c ". /opt/setup-scripts/00-shell-utilities.sh; do_unminimize"

FROM base AS final

RUN bash -c ". /opt/setup-scripts/90-install-tools.sh; UTITILIES_GROUP='BASE NETWORK' install_useful_tools"

FROM final
ENTRYPOINT ["/usr/bin/local/start.sh"]