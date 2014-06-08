#!/bin/bash

MPL_DIR=$HOME/src/boost-mpl/include
MPL_CORE_DIR=$HOME/src/boost-mpl_core/include

set -e

HEADERS=`cat move_headers.txt`

pushd $MPL_DIR

for header in $HEADERS
do
    echo Moving $header
    git log --pretty=email --patch-with-stat --reverse -- $header >$MPL_CORE_DIR/history.txt
    cd $MPL_CORE_DIR
    git am <$MPL_CORE_DIR/history.txt
    rm $MPL_CORE_DIR/history.txt
    cd $MPL_DIR
    git rm $header
done

popd

set +e
