RUNROOT := runtime
RUNTIME := $(RUNROOT)/libcodfns.so

CFILES := codfns.c
HFILES := codfns.h

HPATHS := $(HFILES:%.h=$(RUNROOT)/%.h)
CPATHS := $(CFILES:%.c=$(RUNROOT)/%.c)

.PHONY: runtime

runtime: $(RUNTIME)

$(RUNTIME): $(CPATHS) $(HPATHS)
	clang -shared -fPIC ${CFLAGS} -o $(RUNTIME) $(CPATHS)

clean-runtime:
	rm -rf $(RUNTIME)
