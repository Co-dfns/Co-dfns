SHELL=/bin/sh
BENCHMARK=lu
BENCHMARKU=LU
VEC=

include ../config/make.def

OBJS = lu.o read_input.o \
       domain.o setcoeff.o setbv.o exact.o setiv.o \
       erhs.o ssor$(VEC).o rhs$(VEC).o l2norm.o \
       jacld.o blts$(VEC).o jacu.o buts$(VEC).o error.o syncs.o \
       pintgr.o verify.o ${COMMON}/print_results.o \
       ${COMMON}/timers.o ${COMMON}/wtime.o

include ../sys/make.common


# npbparams.h is included by applu.incl
# The following rule should do the trick but many make programs (not gmake)
# will do the wrong thing and rebuild the world every time (because the
# mod time on header.h is not changed. One solution would be to 
# touch header.h but this might cause confusion if someone has
# accidentally deleted it. Instead, make the dependency on npbparams.h
# explicit in all the lines below (even though dependence is indirect). 

# applu.incl: npbparams.h

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

.f.o :
	${FCOMPILE} $<

lu.o:		lu.f applu.incl npbparams.h
blts$(VEC).o:	blts$(VEC).f
buts$(VEC).o:	buts$(VEC).f
erhs.o:		erhs.f applu.incl npbparams.h
error.o:	error.f applu.incl npbparams.h
exact.o:	exact.f applu.incl npbparams.h
jacld.o:	jacld.f applu.incl npbparams.h
jacu.o:		jacu.f applu.incl npbparams.h
l2norm.o:	l2norm.f
pintgr.o:	pintgr.f applu.incl npbparams.h
read_input.o:	read_input.f applu.incl npbparams.h
rhs$(VEC).o:	rhs$(VEC).f applu.incl npbparams.h
setbv.o:	setbv.f applu.incl npbparams.h
setiv.o:	setiv.f applu.incl npbparams.h
setcoeff.o:	setcoeff.f applu.incl npbparams.h
ssor$(VEC).o:	ssor$(VEC).f applu.incl npbparams.h
domain.o:	domain.f applu.incl npbparams.h
verify.o:	verify.f applu.incl npbparams.h
syncs.o:	syncs.f npbparams.h

clean:
	- /bin/rm -f npbparams.h
	- /bin/rm -f *.o *~
	- if [ -d rii_files ]; then rm -r rii_files; fi
