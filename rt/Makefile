RUNROOT := rt
RUNTIME := $(RUNROOT)/libcodfns.so

CFILES := $(wildcard $(RUNROOT)/*.c)
HFILES := $(wildcard $(RUNROOT)/*.h)

.PHONY: runtime

runtime: $(RUNTIME)

$(RUNTIME): $(CFILES) $(HFILES)
	clang -shared -fPIC ${CFLAGS} -o $(RUNTIME) $(CFILES)

clean-runtime:
	rm -rf $(RUNTIME)
