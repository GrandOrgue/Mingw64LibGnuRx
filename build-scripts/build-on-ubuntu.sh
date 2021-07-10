#!/bin/bash

set -e

SRC_DIR=$(readlink -f $(dirname $0)/..)
echo SRC_DIR=$SRC_DIR

DEBIAN_PKG_NAME=libgnurx-mingw-w64
VERSION=${1:-2.6.1}
BUILD_VERSION=${2:-0.os}


BUILD_DIR=`pwd`/build/win64
mkdir -p $BUILD_DIR

pushd $BUILD_DIR
rm -rf *

PARALLEL_PRMS="-j$(nproc)"

CC="${MINGW64_CC:-x86_64-w64-mingw32-gcc}"; export CC; 
CFLAGS="${MINGW64_CFLAGS:--O2 -g -pipe -Wall -fexceptions --param=ssp-buffer-size=4 -mms-bitfields}"; export CFLAGS; 
LDFLAGS="${MINGW64_LDFLAGS:--Wl,--exclude-libs=libintl.a -Wl,--exclude-libs=libiconv.a -Wl,--no-keep-memory -fstack-protector}"; export LDFLAGS; 

PKG_DIR=`pwd`/libgnurx-mingw-w64_${VERSION}-${BUILD_VERSION}_all
MINGW64_DIR=/usr/x86_64-w64-mingw32

$SRC_DIR/submodules/LibGnuRx/configure --host=x86_64-w64-mingw32 --prefix=$PKG_DIR/$MINGW64_DIR --bindir=$PKG_DIR/$MINGW64_DIR/lib
make $PARALLEL_PRMS

make install
cp -r $SRC_DIR/build-scripts/DEBIAN $PKG_DIR
dpkg-deb --build --root-owner-group $PKG_DIR

popd

