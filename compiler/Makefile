# Note! Do not run this makefile directly. It is included
# in the top-level directory and relies on other external
# information.

DOCROOT := compiler

DOCNAMES := Co-dfns_Compiler
DOCPDF := $(addsuffix .pdf,$(DOCNAMES))
DOCPDF := $(DOCPDF:%=$(DOCROOT)/%)

XSL := conf/fo.xsl
XCONF := conf/fop.xconf
TITLECONF := conf/titlepage.templates.xml

TITLEPAGE := $(DOCROOT)/titlepage.xsl
TITLEXSL := $(DBSTYLES)/template/titlepage.xsl
EXTS := $(DBSTYLES)/extensions/xalan27.jar
FOP := env CLASSPATH=${CLASSPATH}:$(EXTS) fop -c $(XCONF) -xsl $(XSL)

DEPS := $(XSL) $(XCONF) $(TITLEPAGE) \
        */*.xml */*/*.xml */*/*/*.xml */*/*/*/*.xml

.PHONY: docs

docs: $(DOCPDF)

$(DOCPDF): %.pdf: %.xml $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

$(TITLEPAGE): $(TITLECONF)
	xsltproc --output "$@" $(TITLEXSL) $(TITLECONF)

clean-docs:
	rm -rf $(TITLEPAGE)
	rm -rf $(DOCPDF)
