#!/usr/bin/env bash
set -e

ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        RUST_ARCH="x86_64"
        ;;
    aarch64|arm64)
        RUST_ARCH="aarch64"
        ;;
    *)
        RUST_ARCH="$ARCH"
        ;;
esac

curl -OL "https://static.rust-lang.org/dist/rust-1.87.0-${RUST_ARCH}-unknown-linux-gnu.tar.gz"
tar xzvf rust-1.87.0-${RUST_ARCH}-unknown-linux-gnu.tar.gz
rm rust-1.87.0-${RUST_ARCH}-unknown-linux-gnu.tar.gz
