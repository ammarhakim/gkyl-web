#!/bin/bash

source ./build-opts.sh

PREFIX=$GKYLSOFT/wt-4.3.0

# delete old checkout and builds
rm -rf wt-4.3.0*

curl -L https://github.com/emweb/wt/archive/4.3.0.tar.gz > wt-4.3.0.tar.gz

gunzip wt-4.3.0.tar.gz
tar -xvf wt-4.3.0.tar
cd wt-4.3.0
mkdir compile
cd compile
# for now, not building with SSL so no https
cmake -DCMAKE_BUILD_TYPE=Release -DBOOST_PREFIX_DEFAULT=$GKYLSOFT/boost -DCMAKE_INSTALL_PREFIX=$PREFIX -DBoost_USE_STATIC_LIBS=ON -DENABLE_SSL=OFF ../

make -j4
make install

# soft-link
ln -sf $PREFIX $GKYLSOFT/wt
