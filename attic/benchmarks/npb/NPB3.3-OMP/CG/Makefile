SHELL=/bin/sh
BENCHMARK=cg
BENCHMARKU=CG

include ../config/make.def

OBJS = cg.o ${COMMON}/print_results.o  \
       ${COMMON}/${RAND}.o ${COMMON}/timers.o ${COMMON}/wtime.o

include ../sys/make.common

${PROGRAM}: config ${OBJS}
	${FLINK} ${FLINKFLAGS} -o ${PROGRAM} ${OBJS} ${F_LIB}

cg.o:		cg.f  globals.h npbparams.h
	${FCOMPILE} cg.f

clean:
	- rm -f *.o *~ 
	- rm -f npbparams.h core
	- if [ -d rii_files ]; then rm -r rii_files; fi
