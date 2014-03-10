.PHONY: all clean

include conf/mk.conf

all: docs CoDfns.dyalog

include doc/tech/Makefile
include runtime/Makefile

CoDfns.dyalog: $(RUNTIME)

clean: clean-docs clean-runtime
