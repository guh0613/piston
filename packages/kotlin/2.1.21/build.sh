#!/usr/bin/env bash

set -e -o pipefail

JDK_VERSION="21.0.7_6"
JDK_VERSIONP="21.0.7+6"
KOTLIN_VERSION="2.1.21"

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

echo "检测到架构: $ARCH, 使用 JDK 架构标识: $JDK_ARCH"

JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-${JDK_VERSIONP}/OpenJDK21U-jdk_${JDK_ARCH}_linux_hotspot_${JDK_VERSION}.tar.gz"

echo "正在从 $JDK_URL 下载 JDK 21..."
curl -L "$JDK_URL" -o jdk.tar.gz
tar xzf jdk.tar.gz --strip-components=1
rm jdk.tar.gz
echo "JDK 21 安装完成。"

KOTLIN_URL="https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip"

echo "正在从 $KOTLIN_URL 下载 Kotlin 编译器..."
curl -L "$KOTLIN_URL" -o kotlin.zip
unzip kotlin.zip
rm kotlin.zip
cp -r kotlinc/* .
rm -rf kotlinc
echo "Kotlin 编译器安装完成。"

echo "构建环境准备就绪！"
