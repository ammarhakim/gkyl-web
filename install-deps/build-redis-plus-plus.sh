#!/bin/bash

source ./build-opts.sh

## This script builds hiredis redis++

PREFIX=$GKYLSOFT/redis-plus-plus

# delete old checkout and builds
rm -rf redis-plus-plus

# from https://github.com/sewenew/redis-plus-plus
git clone https://github.com/sewenew/redis-plus-plus.git
cd redis-plus-plus
mkdir compile
cd compile
cmake -DCMAKE_BUILD_TYPE=Release -DREDIS_PLUS_PLUS_CXX_STANDARD=17 -DCMAKE_PREFIX_PATH=$HIREDIS_PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX ..

make -j4
make install
cd ..
