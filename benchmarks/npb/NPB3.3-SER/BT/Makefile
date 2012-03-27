SHELL=/bin/sh
BENCHMARK=bt
BENCHMARKU=BT
VEC=

include ../config/make.def


OBJS = bt.o  initialize.o exact_solution.o exact_rhs.o \
       set_constants.o adi.o  rhs.o      \
       x_solve$(VEC).o y_solve$(VEC).o solve_subs.o  \
       z_solve$(VEC).o add.o error.o verify.o \
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

${PROGRAM}: config
	@if [ x$(VERSION) = xvec ] ; then	\
		${MAKE} VEC=_vec exec;		\
	elif [ x$(VERSION) = xVEC ] ; then	\
		${MAKE} VEC=_vec exec;		\
	else					\
		${MAKE} exec;			\
	fi

exec: $(OBJS)
	${FLINK} ${FLINKFLAGS} -o ${PROGRAM} ${OBJS} ${F_LIB}

.f.o:
	${FCOMPILE} $<


bt.o:             bt.f  header.h npbparams.h
initialize.o:     initialize.f  header.h npbparams.h
exact_solution.o: exact_solution.f  header.h npbparams.h
exact_rhs.o:      exact_rhs.f  header.h npbparams.h
set_constants.o:  set_constants.f  header.h npbparams.h
adi.o:            adi.f  header.h npbparams.h
rhs.o:            rhs.f  header.h npbparams.h
x_solve$(VEC).o:  x_solve$(VEC).f  header.h work_lhs$(VEC).h npbparams.h
y_solve$(VEC).o:  y_solve$(VEC).f  header.h work_lhs$(VEC).h npbparams.h
z_solve$(VEC).o:  z_solve$(VEC).f  header.h work_lhs$(VEC).h npbparams.h
solve_subs.o:     solve_subs.f  npbparams.h
add.o:            add.f  header.h npbparams.h
error.o:          error.f  header.h npbparams.h
verify.o:         verify.f  header.h npbparams.h

clean:
	- rm -f *.o *~ mputil*
	- rm -f  npbparams.h core
