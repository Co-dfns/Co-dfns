CC = clang
CPP = clang++
CFLAGS = -g `llvm-config --cflags`
CFILES = parse.c generate_llvm.c
OBJS = parse.o generate_llvm.o
DOCS = parse.pdf generate_llvm.pdf

all: dfns

dfns: ${OBJS}
	${CPP} ${OBJS} `llvm-config --libs --cflags --ldflags` -o dfns

test: dfns
	run-tests

parse.o: grammar.c parse.c
	${CC} -o $@ -c ${CFLAGS} parse.c

grammar.c: grammar.peg
	peg -o $@ $<

${DOCS}: %.pdf: %.w
	cweave $*
	pdftex $*

${CFILES}: %.c: %.w
	ctangle $*
