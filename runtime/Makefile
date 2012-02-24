CFLAGS=-g -L. -I. -std=c99

.SUFFIXES: .w .c .pdf .o .so

runtime: runtime.pdf runtime.so 
	cp runtime.so libruntime.so

runtime-test: runtime
	cc ${CFLAGS} -o runtime-test runtime-test.c -lruntime

test: runtime-test
	LD_LIBRARY_PATH=. ./runtime-test

clean:
	rm -rf *.c *.h *.scn *.idx *.log *.loc *.tex *.dvi *.pdf *.toc *.so

.w.pdf:
	cweave $<
	xetex -papersize=letter $*
	
.w.c:
	ctangle $<

.c.so:
	cc ${CFLAGS} -fPIC -shared -o $@ $<
	
