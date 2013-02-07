CC = clang
CFLAGS ?= -g
CFILES = parse.c
OBJS = parse.o
DOCS = parse.pdf

all: dfns

dfns: ${OBJS}
	${CC} -o dfns ${CFLAGS} ${OBJS}

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
