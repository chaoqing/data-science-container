#!/bin/bash

setup_vnc() {
XSTARTUP=$HOME/.vnc/xstartup
test ! -f ${XSTARTUP} || return

mkdir -p $(dirname ${XSTARTUP})

cat > ${XSTARTUP} <<'EOF'
#!/bin/bash

test ! -f $HOME/.Xresources || xrdb $HOME/.Xresources

if [ -x /etc/X11/xinit/xinitrc ]; then
    exec /etc/X11/xinit/xinitrc
elif command -v openbox-session &> /dev/null; then
    exec openbox-session
elif command -v startxfce4 &> /dev/null; then
    exec startxfce4 --replace
fi

EOF

chmod +x ${XSTARTUP}

VNCPASSWD=$HOME/.vnc/passwd
# if no vncpasswd set vncpasswd
if [ ! -f "${VNCPASSWD}" ]; then
    echo "${VNC_PW:-vnc_pw}" | vncpasswd -f > "${VNCPASSWD}"
    chmod 0600 "${VNCPASSWD}"
fi

VNCCONFIG=$HOME/.vnc/config
# if no config create config
if [ ! -f "${VNCCONFIG}" ]; then
    echo -e 'geometry=1920x1080\nlocalhost=no' > "${VNCCONFIG}"
fi

}

fix_home_permissions() {
    test ! -r $HOME && sudo -E fix-permissions $HOME || true
}

if [ "$(id -u)" != "0" ]; then
    fix_home_permissions
    setup_vnc
fi