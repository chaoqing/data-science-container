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
    INST_DIR=${1:-/opt/google/chrome}
    echo "download Chrome $VERSION and install it to '$INST_DIR'."
    CHROME_URL=https://playwright.azureedge.net/builds/chromium/1148/chromium-linux-arm64.zip
    wget -O  chrome.zip "$CHROME_URL"
    mkdir -p "$INST_DIR"
    unzip -d "$INST_DIR" chrome.zip
    mv $INST_DIR/chrome-linux/* "$INST_DIR"
    rmdir "$INST_DIR/chrome-linux/" 
    rm -f chrome.zip
    test ! -f /usr/bin/google-chrome || ln -s "$INST_DIR/chrome-wrapper" /usr/bin/google-chrome
    command -v x-www-browser &> /dev/null || ln -sf /usr/bin/google-chrome /usr/bin/x-www-browser
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
