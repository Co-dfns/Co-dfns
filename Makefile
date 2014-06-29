CFLAGS := -O3 -g -Wall -pedantic -std=c11

.PHONY: all clean

all: Codfns.dyalog libcodfns.so

libcodfns.so: rt/*.c rt/*.h
	clang -shared -fPIC ${CFLAGS} -o $@ rt/*.c
	
Codfns.dyalog: ns/*.dyalog libcodfns.so
	ns/assemble ns/*.dyalog > Codfns.dyalog

clean:
	rm -rf libcodfns.so Codfns.dyalog

