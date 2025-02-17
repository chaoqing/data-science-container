FROM {% BASE_IMAGE %} AS final
ARG EXTRA_TOOL_SETS=NETWORK

COPY --chmod=755 setup-scripts/90-install-tools.sh /opt/setup-scripts/
COPY --chmod=755 setup-scripts/install-tools.d /opt/setup-scripts/install-tools.d/
RUN bash -c ". /opt/setup-scripts/90-install-tools.sh; install_useful_tools BASIC ${EXTRA_TOOL_SETS}"
ADD root/ /

USER ${NB_USER}
ENV HOME="/home/${NB_USER}"
WORKDIR "${HOME}"

ENTRYPOINT ["/usr/local/bin/container_entrypoint.sh"]
CMD ["/usr/local/bin/vnc_startup.sh"]

FROM final