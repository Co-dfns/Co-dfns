TANGLE_FILES=codfns.dyalog util.dyalog config.dyalog load.dyapp test.dyapp
WEAVE_NAME=codfns.pdf
DISTRIBUTION="../Co-dfns Distribution"
TEST_NAMES=ravel shape reshape catenate
TEST_FILES=$(TEST_NAMES:%=Testing/%_tests.dyalog)

all: tangle weave tests

tangle: ${TANGLE_FILES}

weave: ${WEAVE_NAME}

tests: $(TEST_FILES)

distribution: tangle weave
	cp ${TANGLE_FILES} ${WEAVE_NAME} ${DISTRIBUTION}
	mkdir -p ${DISTRIBUTION}/Testing
	cp ${TEST_FILES} ${DISTRIBUTION}/Testing

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
