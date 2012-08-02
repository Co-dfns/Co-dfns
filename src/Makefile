CFLAGS=-g -Wall -pedantic -std=c99 -fPIC
CC=gcc
EX=4

.SUFFIXES: .pdf .dvi .tex .w

.w.tex:
	${CWEAVE} $*

.tex.pdf:
	pdftex $<
	rm -f $*.{idx,log,out,scn,toc}

.w.c:
	${CTANGLE} $*
	
all: runtime.pdf examples.pdf libhpapl.so examples

run: examples
	LD_LIBRARY_PATH=. ./examples ex${EX}

debug: examples
	LD_LIBRARY_PATH=. gdb examples
	
examples: libhpapl.so examples.o
	${CC} ${CFLAGS} -L. -o examples examples.o -lhpapl -lqthread

libhpapl.so: runtime.o
	${CC} ${CFLAGS} -shared -o libhpapl.so runtime.o -lqthread

clean: 
	rm -f *.o hpapl.h libhpapl.so runtime.pdf examples.pdf examples
