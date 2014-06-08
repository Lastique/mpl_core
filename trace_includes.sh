#!/bin/bash

MPL_DIR=$HOME/src/boost-mpl/include
PREPROCESSED_DIR=boost/mpl/aux_/preprocessed
PREPROCESSED_CONFIGS=`ls $MPL_DIR/$PREPROCESSED_DIR`

TRACE_HEADERS=`cat root_list.txt`
#INDENT_STEP="  "
INDENT_STEP=""

trace_includes()
{
    local INDENT="$2"
    local HEADER="$MPL_DIR/$1"
    if [ -f "$HEADER" ]
    then
        local INCLUDED_HEADERS=`perl -ne 'if (/#\s*define\s*BOOST_MPL_PREPROCESSED_HEADER\s*(.*)/) { print "BOOST_MPL_PREPROCESSED_HEADER=$1\n" } else { if (/#\s*include\s*[<"](.*)[>"]/) { print "$1\n"; } else { if (/#\s*include\s*(.*)/) { print "$1\n"; } } }' "$HEADER"`

        local f
        for f in $INCLUDED_HEADERS
        do
            if [[ "$f" =~ BOOST_MPL_PREPROCESSED_HEADER=(.*) ]]
            then
                trace_preprocessed "${BASH_REMATCH[1]}" "$INDENT$INDENT_STEP"
            else
                echo -n "$INDENT"
                echo $f
                if [ "$f" != "boost/mpl/aux_/include_preprocessed.hpp" ]
                then
                    trace_includes $f "$INDENT$INDENT_STEP"
                fi
            fi
        done
    fi
}

trace_preprocessed()
{
    local INDENT="$2"
    local HEADER="$1"

    local conf
    for conf in $PREPROCESSED_CONFIGS
    do
        local file="$PREPROCESSED_DIR/$conf/$HEADER"
        echo -n "$INDENT"
        echo $file
        trace_includes $file "$INDENT$INDENT_STEP"
    done
}

for file in $TRACE_HEADERS
do
    echo $file
    trace_includes $file "$INDENT_STEP"
done

