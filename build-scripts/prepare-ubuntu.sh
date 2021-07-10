#!/bin/sh

set -e
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
make file gcc-mingw-w64-x86-64


