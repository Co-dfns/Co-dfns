CFLAGS=-g -Wall -pedantic -ansi -fPIC
CC=gcc

.SUFFIXES: .pdf .dvi .tex .w

.w.tex:
	${CWEAVE} $*

.tex.pdf:
	pdftex $<

.w.c:
	${CTANGLE} $*

runtime: runtime.o
	${CC} ${CFLAGS} -fPIC -shared -o libhpapl.so runtime.o
	
examples: runtime examples.o
	${CC} ${CFLAGS} -L. -o examples examples.o -lhpapl
