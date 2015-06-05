#!/bin/sh

FEATURES="-funsigned-bitfields -funsigned-char -fvisibility=hidden -fPIC"
#FEATURES=""
DEFINES="-DxxBIT=64 -DHAS_UNICODE=1 -DUNIX=1 -DWANT_REFCOUNTS=1 -D_DEBUG=1"
INCLUDES="-I./dwa"
FLAGS="-fast -fno-alias -shared -static-intel -Wall -Wno-unused-function"
#FLAGS="-fastsse -shared -fPIC -acc"
FILES="dwa/dwa_fns.c Scratch/blackscholes_tweak.c Scratch/bs_c.c"
OUTPUT="Scratch/blackscholes2.so"
CC=icc
#CC=pgcc
LD_LIBRARY_PATH=/opt/intel/lib/intel64

echo "$CC $FEATURES $DEFINES $INCLUDES $FLAGS -o $OUTPUT $FILES"
$CC $FEATURES $DEFINES $INCLUDES $FLAGS -o $OUTPUT $FILES

