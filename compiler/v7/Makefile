CFLAGS=-g -Wall -pedantic -ansi -fPIC
CC=gcc

.SUFFIXES: .pdf .dvi .tex .w

.w.tex:
	${CWEAVE} $*

.tex.pdf:
	pdftex $<
	rm -f $*.{idx,log,out,scn,toc}

.w.c:
	${CTANGLE} $*
	
runtime: libhpapl.so

examples: libhpapl.so examples.o
	${CC} ${CFLAGS} -L. -o examples examples.o -lhpapl

libhpapl.so: runtime.o
	${CC} ${CFLAGS} -fPIC -shared -o libhpapl.so runtime.o
