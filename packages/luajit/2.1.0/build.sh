#!/usr/bin/env bash
set -e

PREFIX=$(realpath $(dirname "$0"))

mkdir -p build
cd build

# Download LuaJIT source
curl -L "https://github.com/LuaJIT/LuaJIT/archive/v2.1.tar.gz" -o luajit.tar.gz

tar xzf luajit.tar.gz --strip-components=1
rm luajit.tar.gz

make PREFIX="$PREFIX" -j$(nproc)
make install PREFIX="$PREFIX" -j$(nproc)

cd ..
rm -rf build
