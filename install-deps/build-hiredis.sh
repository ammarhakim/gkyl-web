#!/bin/bash

source ./build-opts.sh

## This script builds hiredis library

# Install prefix
PREFIX=$GKYLSOFT/hiredis

# delete old checkout and builds
rm -rf hiredis

git clone https://github.com/redis/hiredis.git
cd hiredis

make -j4
PREFIX=$PREFIX make install
