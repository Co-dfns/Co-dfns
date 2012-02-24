CFLAGS=-g -L. -I. -std=c99

.SUFFIXES: .w .c .pdf .o .so

runtime: runtime.pdf runtime.so 
	cp runtime.so libruntime.so.1.0

runtime-test: runtime
	cc ${CFLAGS} -o runtime-test runtime-test.c -lruntime

test: runtime-test
	./runtime-test

clean:
	rm -rf *.c *.h *.scn *.idx *.log *.loc *.tex *.dvi *.pdf *.toc

.w.pdf:
	cweave $<
	xetex -papersize=letter $*
	
.w.c:
	ctangle $<

.c.so:
	cc ${CFLAGS} -fPIC -shared -o $@ $<
	
