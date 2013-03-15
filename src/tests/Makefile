# Warning! This file is not meant to be standalone. It is written to
# be included by other makefiles in this source tree, do not try to
# use it alone.

TEST := $(wildcard tests/*.dfn)
TESTSRC := $(TEST:.dfn=.ll) $(TEST:.dfn=_r.c)
TESTOBJ := $(TEST:.dfn=.o) $(TEST:.dfn=_r.o)
TESTRUNS := $(patsubst tests/%.dfn,run_%,$(TEST))

CLEANERS += clean-tests

test_all: $(TESTRUNS)

include $(TEST:.dfn=_r.d)

include tests/driver.d

$(TESTRUNS): run_%: tests/%
	$<

$(TEST:.dfn=): %: %.o %_r.o tests/driver.o runtime.o
	$(CC) -o $@ $*.o $*_r.o tests/driver.o runtime.o

%.ll: %.dfn codfns
	./codfns $< $@

%.s: %.ll
	llc $<

clean-tests:
	rm -f $(TESTOBJ)
	rm -f $(TESTOBJ:.o=.d) tests/driver.d
	rm -f $(TEST:.dfn=)