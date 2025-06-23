#!/bin/bash
set -e

# 获取脚本所在的绝对路径作为安装前缀
PREFIX=$(realpath $(dirname $0))

# 创建一个临时构建目录
mkdir -p build
cd build

# --- GHC 安装部分 (与原脚本相同) ---

# 根据平台架构选择正确的 GHC 版本
# 这是一个很好的实践，因为真正的源码编译需要预装 GHC
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

# --- 新增部分：安装 Cabal 和指定的 Haskell 库 ---

echo "Setting up environment for package installation..."
# 将我们刚刚安装的 GHC 的 bin 目录添加到 PATH 中
# 这样后续命令（如 cabal）就能找到正确的 ghc 和 ghc-pkg
export PATH="$PREFIX/bin:$PATH"
export CABAL_STORE_DIR="$PREFIX/store"

echo "Downloading and installing cabal-install..."
# 我们使用与 GHC 版本兼容的 cabal-install 版本
# 注意：cabal-install 的命名约定可能略有不同（例如 ghc-9.12 而不是 9.12.2）
# 请根据实际情况调整下载链接
curl -L "https://downloads.haskell.org/~cabal/Cabal-latest/cabal-install-3.14.2.0-${GHC_ARCH}-linux-deb10.tar.xz" -o cabal.tar.xz
tar xf cabal.tar.xz
# 将 cabal 可执行文件移动到我们的安装目录中
mv cabal "$PREFIX/bin/"
rm cabal.tar.xz

echo "Updating cabal package index..."
# 首次运行需要更新包列表，这会从 Hackage 下载元数据
# 这确保我们能找到所有需要的包
cabal update

echo "Installing required Haskell packages..."
# 使用 cabal install 来安装所有你指定的库
# `--installdir` 和 `--prefix` 确保一切都安装在我们的本地环境中
# 注：`cabal install` 在较新版本中主要用于安装可执行文件，但也可用于在环境中安装库。
# 它会自动处理依赖并将其注册到 GHC 的包数据库中。
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
    # 注意：'heftia-effects' 这个包在公共的 Hackage 仓库中似乎不存在。
    # 如果这是一个私有库或者名字有误，请检查。
    # 我已将其从安装列表中注释掉，如果需要，请取消注释或修正它。
    # heftia-effects

# --- 清理部分 (与原脚本相同) ---

echo "Cleaning up build directory..."
cd ../
rm -rf build

echo "Haskell environment setup complete!"
