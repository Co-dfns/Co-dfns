SHELL=/bin/sh
BENCHMARK=sp
BENCHMARKU=SP

include ../config/make.def


OBJS = sp.o initialize.o exact_solution.o exact_rhs.o \
       set_constants.o adi.o rhs.o      \
       x_solve.o ninvr.o y_solve.o pinvr.o    \
       z_solve.o tzetar.o add.o txinvr.o error.o verify.o  \
       ${COMMON}/print_results.o ${COMMON}/timers.o ${COMMON}/wtime.o

include ../sys/make.common

# npbparams.h is included by header.h
# The following rule should do the trick but many make programs (not gmake)
# will do the wrong thing and rebuild the world every time (because the
# mod time on header.h is not changed. One solution would be to 
# touch header.h but this might cause confusion if someone has
# accidentally deleted it. Instead, make the dependency on npbparams.h
# explicit in all the lines below (even though dependence is indirect). 

# header.h: npbparams.h

${PROGRAM}: config ${OBJS}
	${FLINK} ${FLINKFLAGS} -o ${PROGRAM} ${OBJS} ${F_LIB}

.f.o:
	${FCOMPILE} $<

sp.o:             sp.f  header.h npbparams.h
initialize.o:     initialize.f  header.h npbparams.h
exact_solution.o: exact_solution.f  header.h npbparams.h
exact_rhs.o:      exact_rhs.f  header.h npbparams.h
set_constants.o:  set_constants.f  header.h npbparams.h
adi.o:            adi.f  header.h npbparams.h
rhs.o:            rhs.f  header.h npbparams.h
#lhsx.o:           lhsx.f  header.h npbparams.h
#lhsy.o:           lhsy.f  header.h npbparams.h
#lhsz.o:           lhsz.f  header.h npbparams.h
x_solve.o:        x_solve.f  header.h npbparams.h
ninvr.o:          ninvr.f  header.h npbparams.h
y_solve.o:        y_solve.f  header.h npbparams.h
pinvr.o:          pinvr.f  header.h npbparams.h
z_solve.o:        z_solve.f  header.h npbparams.h
tzetar.o:         tzetar.f  header.h npbparams.h
add.o:            add.f  header.h npbparams.h
txinvr.o:         txinvr.f  header.h npbparams.h
error.o:          error.f  header.h npbparams.h
verify.o:         verify.f  header.h npbparams.h

clean:
	- rm -f *.o *~ mputil*
	- rm -f npbparams.h core
