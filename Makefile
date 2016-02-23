# noweave -delay -index codfns.nw > codfns.tex && lualatex codfns && bibtex codfns && lualatex codfns && lualatex codfns

# notangle -R<> codfns.nw > <>

TANGLE_FILES=codfns.dyalog util.dyalog config.dyalog load.dyapp test.dyapp
WEAVE_NAME=codfns.pdf
DISTRIBUTION="../Co-dfns Distribution"

all: tangle weave

tangle: ${TANGLE_FILES}

weave: ${WEAVE_NAME}

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

