#!/usr/bin/env bash

# libmusl tool chain
# Download musl
mkdir -p musl
cd musl
wget http://more.musl.cc/10/x86_64-linux-musl/x86_64-linux-musl-native.tgz
tar -xzf x86_64-linux-musl-native.tgz
rm x86_64-linux-musl-native.tgz
export TOOLCHAIN_DIR=`pwd`/x86_64-linux-musl-native
export CC=${TOOLCHAIN_DIR}/bin/gcc
# Download, build, install zlib into TOOLCHAIN_DIR
wget https://zlib.net/zlib-1.2.12.tar.gz
tar -xzf zlib-1.2.12.tar.gz
rm zlib-1.2.12.tar.gz
cd zlib-1.2.12
./configure --prefix=${TOOLCHAIN_DIR} --static
make
make install
cd ..
# Add TOOLCHAIN_DIR to PATH
# Add it to bash, but as a comment. If you add libmusl to the path,native image only works if you specify
# libmusl as the libc
# Currently, if you add libmusl to the path builds will fail, unless you explicitly specify using limbusl
echo "export LIBMUSL_BIN_DIR=${TOOLCHAIN_DIR}/bin" >> ~/.bashrc

# For manipulating the PATH variable
echo "path_append ()  { path_remove $1; export PATH="$PATH:$1"; }" >> ~/.bashrc
echo "path_prepend () { path_remove $1; export PATH="$1:$PATH"; }" >> ~/.bashrc
echo "path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }" >> ~/.bashrc

echo "# Adds LIBMUSL to path" >> ~/.bashrc
echo "libmusl_use() { path_prepend $LIBMUSL_BIN_DIR; }" >> ~/.bashrc
echo "libmusl_rm() { path_remove $LIBMUSL_BIN_DIR; }" >> ~/.bashrc
cd