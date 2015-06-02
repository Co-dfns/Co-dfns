#!/bin/sh

FEATURES="-funsigned-bitfields -funsigned-char -fvisibility=hidden -fPIC"
DEFINES="-DxxBIT=64 -DHAS_UNICODE=1 -DUNIX=1 -DWANT_REFCOUNTS=1 -D_DEBUG=1"
INCLUDES="-I./dwa"
FLAGS="-g3 -shared -Wall -Wno-unused-function"
FILES="dwa/dwa_fns.c Scratch/blackscholes.c Scratch/bs_c.c"
OUTPUT="Scratch/blackscholes.so"
CC=cc

echo "$CC $FEATURES $DEFINES $INCLUDES $FLAGS -o $OUTPUT $FILES"
$CC $FEATURES $DEFINES $INCLUDES $FLAGS -o $OUTPUT $FILES

