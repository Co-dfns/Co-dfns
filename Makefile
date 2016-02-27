TANGLE_FILES=codfns.dyalog util.dyalog config.dyalog load.dyapp test.dyapp
WEAVE_NAME=codfns.pdf
DISTRIBUTION="../Co-dfns Distribution"
TEST_FILES=ravel_tests.dyalog shape_tests.dyalog reshape_tests.dyalog

all: tangle weave tests

tangle: ${TANGLE_FILES}

weave: ${WEAVE_NAME}

tests: $(TEST_FILES:%=Testing/%)

distribution: tangle weave
	cp ${TANGLE_FILES} ${WEAVE_NAME} ${DISTRIBUTION}

%.pdf: %.nw
	noweave -delay -index $*.nw > $*.tex
	lualatex $*
	bibtex $*
	lualatex $*
	lualatex $*
	xdg-open $@

%.dyalog: codfns.nw
	notangle -R$@ codfns.nw > $@

%.dyapp: codfns.nw
	notangle -R$@ codfns.nw > $@

Testing/%_tests.dyalog: codfns.nw
	notangle -R$(notdir $(subst _,\\_,$@)) codfns.nw > $@
