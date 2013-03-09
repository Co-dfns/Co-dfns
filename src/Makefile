CC = clang
CPP = clang++
CFLAGS = -g -pedantic -Wall -ansi -fno-color-diagnostics
OBJS = util.o pool.o stack.o ast.o parser.o lift_constants.o codfns.o

all: codfns

codfns: ${OBJS}
	${CPP} ${OBJS} ${CPPFLAGS} -o codfns

parser.o: grammar.c parser.c
	${CC} -o $@ -c ${CFLAGS} parser.c

grammar.c: grammar.peg
	peg -o $@ $<

clean:
	rm -f ${OBJS}
