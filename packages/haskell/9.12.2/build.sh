#!/bin/bash
set -e


PREFIX=$(realpath $(dirname $0))


mkdir -p build
cd build


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

echo "Downloading GHC for architecture: ${GHC_ARCH}..."
curl -L "https://downloads.haskell.org/~ghc/9.12.2/ghc-9.12.2-${GHC_ARCH}-deb10-linux.tar.xz" -o ghc.tar.xz
tar xf ghc.tar.xz --strip-components=1
rm ghc.tar.xz

echo "Configuring and installing GHC..."
./configure --prefix="$PREFIX"
make install -j$(nproc)

# --- 安装 Cabal 和 Haskell 库 ---

echo "Setting up environment for package installation..."

export PATH="$PREFIX/bin:$PATH"
export CABAL_STORE_DIR="$PREFIX/store"

echo "Downloading and installing cabal-install..."

curl -L "https://downloads.haskell.org/~cabal/Cabal-latest/cabal-install-3.14.2.0-${GHC_ARCH}-linux-deb10.tar.xz" -o cabal.tar.xz
tar xf cabal.tar.xz

mv cabal "$PREFIX/bin/"
rm cabal.tar.xz

echo "Updating cabal package index..."

cabal update

echo "Installing required Haskell packages..."

cabal --store-dir="$CABAL_STORE_DIR" \
    v2-install --lib \
    aeson \
    comonad \
    containers \
    effectful \
    haskeline \
    lens \
    mtl \
    parsec \
    pretty \
    repline \
    text \
    type-operators \
    unordered-containers \
    heftia-effects \
    --package-env="$PREFIX/ghc-env" \
    --install-method=copy \
    --overwrite-policy=always


# --- 清理部分 ---

echo "Cleaning up build directory..."
cd ../
rm -rf build

echo "Haskell environment setup complete!"
