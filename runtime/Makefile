CFLAGS=-g -L. -I. -std=c99

.SUFFIXES: .w .c .pdf .o .so

runtime: runtime.pdf runtime.so runtime-test

runtime-test: runtime.so
	cc ${CFLAGS} -o runtime-test runtime-test.c -lruntime

test: runtime-test
	./runtime-test

clean:
	rm -rf *.c
	rm -rf *.h

.w.pdf:
	cweave $<
	xetex -papersize=letter $*
	
.w.c:
	ctangle $<

.c.o:
	cc ${CFLAGS} -o $@ $<
	
.o.so:
	cc ${CFLAGS} -fPIC -shared -o $@ $<