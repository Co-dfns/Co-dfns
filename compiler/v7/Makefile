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
	
all: runtime.pdf examples.pdf libhpapl.so examples
	
examples: libhpapl.so examples.o
	${CC} ${CFLAGS} -L. -o examples examples.o -lhpapl

libhpapl.so: runtime.o
	${CC} ${CFLAGS} -shared -o libhpapl.so runtime.o

clean: 
	rm -f *.o hpapl.h libhpapl.so runtime.pdf examples.pdf examples
