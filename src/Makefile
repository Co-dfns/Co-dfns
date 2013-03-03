CC = clang
CPP = clang++
CFLAGS = -g -O0 `llvm-config --cflags` -pedantic -Wall -std=c11
CPPFLAGS = -O0 -g `llvm-config --libs --cflags --ldflags`
CFILES = co-dfns.c
OBJS = co-dfns.o

all: co-dfns co-dfns.pdf

co-dfns: ${OBJS}
	${CPP} ${OBJS} ${CPPFLAGS} -o co-dfns

test: co-dfns
	run-tests

co-dfns.o: co-dfns.c grammar.c
	${CC} -o $@ -c ${CFLAGS} co-dfns.c

parse.o: grammar.c parse.c
	${CC} -o $@ -c ${CFLAGS} parse.c

grammar.c: grammar.peg
	peg -o $@ $<

co-dfns.pdf: co-dfns.w grammar.peg
	cweave co-dfns
	pdftex co-dfns

${CFILES}: %.c: %.w
	ctangle $*
