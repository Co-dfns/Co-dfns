SHELL=/bin/sh
BENCHMARK=cg
BENCHMARKU=CG

include ../config/make.def

OBJS = cg.o ${COMMON}/print_results.o  \
       ${COMMON}/${RAND}.o ${COMMON}/timers.o

include ../sys/make.common

${PROGRAM}: config ${OBJS}
	${FLINK} ${FLINKFLAGS} -o ${PROGRAM} ${OBJS} ${FMPI_LIB}

cg.o:		cg.f  mpinpb.h npbparams.h timing.h
	${FCOMPILE} cg.f

clean:
	- rm -f *.o *~ 
	- rm -f npbparams.h core



