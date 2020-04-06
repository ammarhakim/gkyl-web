# if we are in machines directory, go up a directory
if [ `dirname "$0"` == "." ] 
  then
    cd ..
fi
export GKYLSOFT='~/gkylsoft'
cd install-deps
# now build rest of packages
cmd="./mkdeps.sh CC=clang CXX=clang++ --build-luajit=yes --build-redis=yes --build-boost=yes --build-wt4=yes"
echo $cmd
$cmd
