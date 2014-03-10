# Note! Do not run this makefile directly. It is included
# in the top-level directory and relies on other external
# information.

DOCROOT := doc/tech

DOCSRC := Cleanroom_Engineering_Guide.xml Software_Architecture.xml \
          Engineering_Change_Log.xml Software_Development_Plan.xml \
          Function_Specification.xml Software_Requirements.xml \
          Increment_Certification_Report.xml Statement_of_Work.xml \
          Increment_Construction_Plan.xml Statistical_Testing_Report.xml \
          Increment_Test_Plan.xml Usage_Specification.xml Project_Record.xml
DOCPDF := $(DOCSRC:%.xml=$(DOCROOT)/%.pdf)

XSL := conf/fo.xsl
XCONF := conf/fop.xconf
TITLECONF := conf/titlepage.templates.xml

TITLEPAGE := $(DOCROOT)/titlepage.xsl
TITLEXSL := $(DBSTYLES)/template/titlepage.xsl

.PHONY: docs

docs: $(DOCPDF)

$(DOCPDF): %.pdf: %.xml $(XSL) $(XCONF) $(TITLEPAGE)
	fop -c $(XCONF) -xsl $(XSL) -xml "$<" -pdf "$@"

$(TITLEPAGE): $(TITLECONF)
	xsltproc --output "$@" $(TITLEXSL) $(TITLECONF)

clean-docs:
	rm -rf $(TITLEPAGE)
	rm -rf $(DOCPDF)
