#!/bin/bash

source ./build-opts.sh

PREFIX=$GKYLSOFT/boost-1.72.0

# delete old checkout and builds
rm -rf boost_1_72*

curl -L https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz > boost_1_72_0.tar.gz

gunzip boost_1_72_0.tar.gz
tar -xvf boost_1_72_0.tar
cd boost_1_72_0

./bootstrap.sh --prefix=$PREFIX
# Specify cxxstd=14 to avoid "undefined reference to generic_category_instance" while building. 
# See: https://github.com/boostorg/system/issues/26
./b2 link=static cxxstd=14 install

# soft-link
ln -sf $PREFIX $GKYLSOFT/boost
