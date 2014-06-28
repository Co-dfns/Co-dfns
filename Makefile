CFLAGS := -O3 -g -Wall -pedantic -std=c11

.PHONY: all clean

all: Codfns.dyalog

include rt/Makefile

Codfns.dyalog: $(RUNTIME)

clean: clean-runtime
