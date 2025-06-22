#!/usr/bin/env bash
set -e

ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        GO_ARCH="amd64"
        ;;
    aarch64|arm64)
        GO_ARCH="arm64"
        ;;
    *)
        GO_ARCH="$ARCH"
        ;;
esac

curl -LO "https://golang.org/dl/go1.23.10.linux-${GO_ARCH}.tar.gz"
tar -xzf go1.23.10.linux-${GO_ARCH}.tar.gz
rm go1.23.10.linux-${GO_ARCH}.tar.gz

