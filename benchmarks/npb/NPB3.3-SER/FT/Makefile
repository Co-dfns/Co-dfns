SHELL=/bin/sh
BENCHMARK=ft
BENCHMARKU=FT

include ../config/make.def

include ../sys/make.common

OBJS = appft.o auxfnct.o fft3d.o mainft.o verify.o \
       ${COMMON}/${RAND}.o ${COMMON}/print_results.o \
       ${COMMON}/timers.o ${COMMON}/wtime.o

${PROGRAM}: config ${OBJS}
	${FLINK} ${FLINKFLAGS} -o ${PROGRAM} ${OBJS} ${F_LIB}



.f.o:
	${FCOMPILE} $<

appft.o:	appft.f  global.h npbparams.h
auxfnct.o:	auxfnct.f  global.h npbparams.h
fft3d.o:	fft3d.f  global.h npbparams.h
mainft.o:	mainft.f  global.h npbparams.h
verify.o:	verify.f  global.h npbparams.h

clean:
	- rm -f *.o *~ mputil*
	- rm -f ft npbparams.h core
