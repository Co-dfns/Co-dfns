.PHONY: all clean

include conf/mk.conf

all: docs CoDfns.dyalog

include doc/tech/Makefile

CoDfns.dyalog: libcodfns.so

libcodfns.so: codfns.h codfns.c
	clang -shared -fPIC -o libcodfns.so codfns.c

clean: clean-docs
	rm -f libcodfns.so
