#!/usr/bin/env bash
set -e
PREFIX=$(realpath $(dirname "$0"))

# Download MoonBit CLI tools
curl -L "https://cli.moonbitlang.com/binaries/latest/moonbit-linux-x86_64.tar.gz" -o moonbit.tar.gz
mkdir -p "$PREFIX"
cd "$PREFIX"
tar xzf ../moonbit.tar.gz --strip-components=0
rm ../moonbit.tar.gz

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
