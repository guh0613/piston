#!/bin/bash
set -e

PREFIX=$(realpath $(dirname $0))

mkdir -p build

cd build

# Platform specific because a true source compile would require GHC preinstalled
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        GHC_ARCH="x86_64"
        ;;
    aarch64|arm64)
        GHC_ARCH="aarch64"
        ;;
    *)
        GHC_ARCH="$ARCH"
        ;;
esac

curl -L "https://downloads.haskell.org/~ghc/9.12.2/ghc-9.12.2-${GHC_ARCH}-deb10-linux.tar.xz" -o ghc.tar.xz
tar xf ghc.tar.xz --strip-components=1
rm ghc.tar.xz

./configure --prefix="$PREFIX"
make install -j$(nproc)

cd ../

rm -rf build
