CC = clang
CFILES = parse.c
OBJS = parse.o

all: dfns

dfns: ${OBJS}
	${CC} -o dfns ${CFLAGS} ${OBJS}
	
test: dfns
	run-tests

parse.o: grammar.c parse.c
	${CC} -o $@ -c ${CFLAGS} parse.c

grammar.c: grammar.peg
	peg -o $@ $<

${CFILES}: %.c: %.w
	ctangle $*
