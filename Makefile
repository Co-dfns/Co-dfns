CFLAGS := -O3 -g -Wall -pedantic -std=c11

.PHONY: all clean unit acceptance

all: Codfns.dyalog

unit: Codfns.dyalog ut.dyalog
	LD_LIBRARY_PATH=. mapl ws/unit

acceptance: Codfns.dyalog at.dyalog
	LD_LIBRARY_PATH=. mapl ws/acceptance

clean:
	rm -rf libcodfns.so Codfns.dyalog ut.dyalog at.dyalog

libcodfns.so: rt/*.c rt/*.h
	clang -shared -fPIC ${CFLAGS} -o $@ rt/*.c
	
Codfns.dyalog: ns/*.dyalog libcodfns.so
	echo ':Namespace Codfns' > Codfns.dyalog
	bin/assemble ns/*.dyalog >> Codfns.dyalog

ut.dyalog: ut/*.dyalog
	echo ':Namespace ut' > ut.dyalog
	bin/assemble ut/*.dyalog >> ut.dyalog

at.dyalog: at/*.dyalog
	echo ':Namespace at' > at.dyalog
	bin/assemble at/*.dyalog >> at.dyalog

