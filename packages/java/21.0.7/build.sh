#!/usr/bin/env bash

# Put instructions to build your package in here
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    JDK_ARCH="x64"
    ;;
  aarch64)
    JDK_ARCH="aarch64"
    ;;
  *)
    echo "不支持的架构: $ARCH"
    exit 1
    ;;
esac

curl "https://download.oracle.com/graalvm/21/latest/graalvm-jdk-21_linux-${JDK_ARCH}_bin.tar.gz" -o java.tar.gz

tar xzf java.tar.gz --strip-components=1
rm java.tar.gz

