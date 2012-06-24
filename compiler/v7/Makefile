CFLAGS=-g -Wall -pedantic -ansi
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
