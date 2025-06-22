#!/bin/bash
set -e

ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        NODE_ARCH="x64"
        ;;
    aarch64|arm64)
        NODE_ARCH="arm64"
        ;;
    *)
        NODE_ARCH="$ARCH"
        ;;
esac

curl -L "https://nodejs.org/dist/v20.11.1/node-v20.11.1-linux-${NODE_ARCH}.tar.xz" -o node.tar.xz
tar xf node.tar.xz --strip-components=1
rm node.tar.xz