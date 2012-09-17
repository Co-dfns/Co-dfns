CFLAGS=-g -O3 -Wall -pedantic -std=c99 -fPIC
CC=gcc
EX=4
VALGOPTS="--tool=memcheck"
PROCS=1
ENV=QTHREAD_NUM_SHEPHERDS=${PROCS} LD_LIBRARY_PATH=.

.SUFFIXES: .pdf .dvi .tex .w .czw .ss

.w.tex:
	${CWEAVE} $*

.czw.tex:
	chezweave $<

.czw.ss:
	cheztangle $<

.tex.pdf:
	pdftex $<
	rm -f $*.{idx,log,out,scn,toc}

.w.c:
	${CTANGLE} $*
	
all: runtime.pdf examples.pdf libhpapl.so examples

run: examples
	${ENV} ./examples ex${EX}

debug: examples
	${ENV} gdb examples

check:
	${ENV} valgrind ${VALGOPTS} ./examples ex${EX}
	
examples: libhpapl.so examples.o
	${CC} ${CFLAGS} -L. -o examples examples.o -lhpapl -lqthread

libhpapl.so: runtime.o
	${CC} ${CFLAGS} -shared -o libhpapl.so runtime.o -lqthread

clean: 
	rm -f *.o hpapl.h libhpapl.so runtime.pdf examples.pdf examples
