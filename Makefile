DOCSRC := $(wildcard *.xml)
DOCPDF := $(DOCSRC:.xml=.pdf)
CP  := /usr/share/java/xalan-j2.jar
XSL := /usr/share/sgml/docbook/xsl-ns-stylesheets/fo/docbook.xsl
FOP := -param body.font.master 12 -param generate.toc 'article nop' \
       -param monospace.font.family 'FreeMono for APL' -c fop.xconf

docs: $(DOCPDF)

%.pdf: %.xml
	CLASSPATH=$(CP) fop $(FOP) -xsl $(XSL) -xml $< $@

%.xml: %.md
	pandoc -o $@ -t docbook $<

	