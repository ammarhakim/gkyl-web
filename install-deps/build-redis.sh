#!/bin/bash

source ./build-opts.sh

# Edit to suite your system
PREFIX=$GKYLSOFT/redis

# delete old checkout and builds
rm -rf redis-stable redis-stable.tar*

curl -L http://download.redis.io/redis-stable.tar.gz > redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable

make -j4
PREFIX=$PREFIX make install

