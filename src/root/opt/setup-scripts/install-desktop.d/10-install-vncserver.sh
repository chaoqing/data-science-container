#!/usr/bin/env bash
set -e

apt-get update -y
echo "Install TigerVNC server"
apt-get install -y tigervnc-standalone-server
apt-get clean -y
printf '\n# docker-headless-vnc-container:\n$localhost = "no";\n1;\n' >>/etc/tigervnc/vncserver-config-defaults
rm -rf /var/lib/apt/lists/*
