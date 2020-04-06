#!/bin/bash

# Defaults
PREFIX=$HOME/gkylsoft

# default build options
CC=gcc
CXX=g++
MPICC=mpicc
MPICXX=mpicxx

# by default, don't build anything. will check later to see if things
# should be installed.
BUILD_LUAJIT=
BUILD_REDIS=
BUILD_BOOST=
BUILD_WT4=

# ----------------------------------------------------------------------------
# FUNCTION DEFINITIONS
# ----------------------------------------------------------------------------

# Help

show_help() {
cat <<EOF

./mkdeps.sh CC=cc CXX=cxx MPICC=mpicc MPICXX=mpicxx

Build Gkyl dependencies. By default, only builds libraries that Gkyl 
needs that haven't yet been built or can't be found.

CC 
CXX
MPICC
MPICXX                      C, C++, MPI C and MPI C++ compilers to use

-h
--help                      This help.
--prefix=DIR                Prefix where dependencies should be installed.
                            Default is $HOME/gkylsoft

The following flags specify which libraries to build. By default, only
builds libraries that haven't yet been built or can't be found. 
If you build libraries that depend on MPI please specify the MPI C 
and C++ compilers to use.

--build-luajit              Should we build LuaJIT?
--build-redis               Should we build redis?
--build-boost               Should we build boost?
--build-wt4                 Should we build wt4?

The behavior of the flags for library xxx is as follows:
--build-xxx=no              Don't build xxx, even if it can't be found in PREFIXDIR
--build-xxx=yes             Build xxx, no matter what
[no flag specified]         Build xxx only if it can't be found in PREFIXDIR (default)
EOF
}

# Helper functions

find_program() {
   prog=`command -v "$1" 2>/dev/null`
   if [ -n "$prog" ]
   then
      dirname "$prog"
   fi
}

die() {
   echo "$*"
   echo
   echo "Dependency builds failed."
   echo
   exit 1
}

# ----------------------------------------------------------------------------
# MAIN PROGRAM
# ----------------------------------------------------------------------------

# Parse options

while [ -n "$1" ]
do
   value="`echo $1 | sed 's/[^=]*.\(.*\)/\1/'`"
   key="`echo $1 | sed 's/=.*//'`"
   if `echo "$value" | grep "~" >/dev/null 2>/dev/null`
   then
      echo
      echo '*WARNING*: the "~" sign is not expanded in flags.'
      echo 'If you mean the home directory, use $HOME instead.'
      echo
   fi
   case "$key" in
   -h)
      show_help
      exit 0
      ;;
   --help)
      show_help
      exit 0
      ;;
   CC)
      [ -n "$value" ] || die "Missing value in flag $key."
      CC="$value"
      ;;
   CXX)
      [ -n "$value" ] || die "Missing value in flag $key."
      CXX="$value"
      ;;
   MPICC)
      [ -n "$value" ] || die "Missing value in flag $key."
      MPICC="$value"
      ;;
   MPICXX)
      [ -n "$value" ] || die "Missing value in flag $key."
      MPICXX="$value"
      ;;   
   --prefix)
      [ -n "$value" ] || die "Missing value in flag $key."
      PREFIX="$value"
      ;;
   --build-luajit)
      [ -n "$value" ] || die "Missing value in flag $key."
      BUILD_LUAJIT="$value"
      ;;
   --build-redis)
      [ -n "$value" ] || die "Missing value in flag $key."
      BUILD_REDIS="$value"
      ;;
   --build-boost)
      [ -n "$value" ] || die "Missing value in flag $key."
      BUILD_BOOST="$value"
      ;;
   --build-wt4)
      [ -n "$value" ] || die "Missing value in flag $key."
      BUILD_WT4="$value"
      ;;
   *)
      die "Error: Unknown flag: $1"
      ;;
   esac
   shift
done

# if mpicc doesn't work (because it doesn't exist or it's not in path), try to use installed openmpi version
if ! [ -x "$(command -v $MPICC)" ]
then
    MPICC=$PREFIX/openmpi-3.1.2/bin/mpicc
    MPICXX=$PREFIX/openmpi-3.1.2/bin/mpicxx
fi
# if mpicc still doesn't work, force to install openmpi
if ! [ -x "$(command -v $MPICC)" ] 
then
    BUILD_OPENMPI="yes"
fi

# Write out build options for scripts to use
cat <<EOF1 > build-opts.sh
# Generated automatically! Do not edit

# Installation directory
GKYLSOFT=$PREFIX
# Various compilers
CC=$CC
CXX=$CXX
MPICC=$MPICC
MPICXX=$MPICXX

EOF1


build_luajit() {
    if [[ ! "$BUILD_LUAJIT" = "no" && ("$BUILD_LUAJIT" = "yes" || ! -f $PREFIX/luajit/include/luajit-2.1/lua.hpp) ]]
    then    
	echo "Building LuaJIT"
	./build-luajit-openresty.sh
    fi
}

build_redis() {
    if [[ ! "$BUILD_REDIS" = "no" && ("$BUILD_REDIS" = "yes" || ! -f $PREFIX/redis-plus-plus/include/sw/redis++/redis.hpp) ]]
    then    
	echo "Building redis and related libraries"
	./build-redis.sh
	./build-hiredis.sh
	./build-redis-plus-plus.sh
    fi
}

build_boost() {
    if [[ ! "$BUILD_BOOST" = "no" && ("$BUILD_BOOST" = "yes" || ! -f $PREFIX/boost/include/boost/any.hpp) ]]
    then    
	echo "Building boost"
	./build-boost.sh
    fi
}

build_wt4() {
    if [[ ! "$BUILD_WT4" = "no" && ("$BUILD_WT4" = "yes" || ! -f $PREFIX/wt/include/Wt/WApplication.h) ]]
    then    
	echo "Building wt4"
	./build-wt4.sh
    fi
}

echo "Installations will be in $PREFIX"

build_luajit
build_redis
build_boost
build_wt4
