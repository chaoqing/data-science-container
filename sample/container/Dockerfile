FROM scratch

# ADD ./obuntu.tar /
COPY --from=ghcr.io/chaoqing/data-science-container/xbuntu:full-nightly / /

ARG USER_NAME=jovyan
ARG USER_GROUP=${USER_NAME}
ENV USER=${USER_NAME}
ENV HOME=/home/$USER

ENV SHELL=/bin/zsh
ENV GRANT_SUDO=yes
ENV LANG=en_US.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV STARTUPDIR=/tmp
ENV NO_VNC_HOME=/var/www/no_vnc
ENV NO_VNC_PORT=6901
ENV TZ=Etc/UTC
ENV VNC_COL_DEPTH=24
ENV VNC_PORT=5901
ENV VNC_RESOLUTION=1920x1200

ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh", "/usr/local/bin/container_entrypoint.sh"]
CMD ["bash", "-c", "exec supervisord -c $HOME/.local/etc/supervisor/supervisord.conf"]
