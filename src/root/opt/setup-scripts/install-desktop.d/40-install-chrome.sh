#!/usr/bin/env bash
set -e

VERSION="stable"
echo "Install Chrome $VERSION"

function instChrome_amd64() {
    apt-get update
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
    apt-get install -y ./chrome.deb
    rm chrome.deb
    rm -rf /var/lib/apt/lists/*
}

function instChrome_arm64() {
    apt-get update
    apt-get install -y chromium-browser
    rm -rf /var/lib/apt/lists/*
}


function instChrome() {
case $(dpkg --print-architecture) in
    amd64) instChrome_amd64;;
    arm64) instChrome_arm64;;
    *) echo "Unsupported architecture"; exit 1 ;;
esac

    realpath /usr/bin/google-chrome
}

instChrome "$VERSION"
