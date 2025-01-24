FROM {% BASE_IMAGE %} AS final
RUN bash -c ". /opt/setup-scripts/90-install-tools.sh; install_useful_tools BASIC NETWORK"

USER ${NB_USER}
ENV HOME="/home/${NB_USER}"
WORKDIR "${HOME}"

ENTRYPOINT ["/usr/local/bin/container_entrypoint.sh"]

FROM final