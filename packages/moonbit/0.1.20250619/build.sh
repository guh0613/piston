#!/usr/bin/env bash
set -e
PREFIX=$(realpath $(dirname "$0"))

ARCH=$(uname -m)

mkdir -p "$PREFIX"
cd "$PREFIX"

if [ "$ARCH" = "x86_64" ]; then
    # Download official binary for x86_64
    curl -L "https://cli.moonbitlang.com/binaries/latest/moonbit-linux-x86_64.tar.gz" -o moonbit.tar.gz
    tar xzf moonbit.tar.gz --strip-components=0
    rm moonbit.tar.gz
else
    # Build from source for arm64/others
    MOON_VERSION=$(curl -s https://raw.githubusercontent.com/moonbitlang/moonbit-compiler/main/node/moon_version)
    CORE_VERSION=$(curl -s https://raw.githubusercontent.com/moonbitlang/moonbit-compiler/main/node/core_version)

    git clone https://github.com/moonbitlang/moon moon
    pushd moon
    git checkout "$MOON_VERSION"
    cargo build --release
    cp target/release/moon ../bin/
    cp target/release/moonrun ../bin/
    popd
    rm -rf moon

    curl -L https://raw.githubusercontent.com/moonbitlang/moonbit-compiler/main/node/moonc.js -o bin/moonc
    curl -L https://raw.githubusercontent.com/moonbitlang/moonbit-compiler/main/node/moonfmt.js -o bin/moonfmt
    curl -L https://raw.githubusercontent.com/moonbitlang/moonbit-compiler/main/node/mooninfo.js -o bin/mooninfo
    curl -L https://raw.githubusercontent.com/moonbitlang/moonbit-compiler/main/node/moonc.assets -o bin/moonc.assets
    curl -L https://raw.githubusercontent.com/moonbitlang/moonbit-compiler/main/node/moonfmt.assets -o bin/moonfmt.assets
    curl -L https://raw.githubusercontent.com/moonbitlang/moonbit-compiler/main/node/mooninfo.assets -o bin/mooninfo.assets
    chmod +x bin/moonc bin/moonfmt bin/mooninfo
fi

# Fetch core library and bundle
CORE_COMMIT="44c8d2b91f51e0e167ce941ae7522a5f4701bfef"
mkdir -p lib
cd lib
git clone https://github.com/moonbitlang/core core
cd core
git checkout "$CORE_COMMIT"
"$PREFIX/bin/moon" bundle --target all
rm -rf .git
cd "$PREFIX"
