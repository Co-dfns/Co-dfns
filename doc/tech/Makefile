# Note! Do not run this makefile directly. It is included
# in the top-level directory and relies on other external
# information.

DOCROOT := doc/tech

DOCNAMES := Engineering_Change_Log Cleanroom_Engineering_Guide \
            Increment_Certification_Report \
            Increment_Test_Plan \
            Statement_of_Work \
            Software_Requirements \
            Project_Record \
            Software_Development_Plan \
            Software_Architecture \
            Statistical_Testing_Report \
            Usage_Specification \
            Increment_Construction_Plan
DOCPDF := $(addsuffix .pdf,$(DOCNAMES))
DOCPDF := $(join $(addsuffix /,$(DOCNAMES)),$(DOCPDF))
DOCPDF := $(DOCPDF:%=$(DOCROOT)/%)

XSL := conf/fo.xsl
XCONF := conf/fop.xconf
TITLECONF := conf/titlepage.templates.xml

TITLEPAGE := $(DOCROOT)/titlepage.xsl
TITLEXSL := $(DBSTYLES)/template/titlepage.xsl
EXTS := $(DBSTYLES)/extensions/xalan27.jar
STDDOCDEPS := $(XSL) $(XCONF) $(TITLEPAGE)
FOP := env CLASSPATH=${CLASSPATH}:$(EXTS) fop -c $(XCONF) -xsl $(XSL)

.PHONY: docs

docs: $(DOCPDF)

include $(addprefix $(DOCROOT)/,$(DOCNAMES:%=%/Makefile))

$(TITLEPAGE): $(TITLECONF)
	xsltproc --output "$@" $(TITLEXSL) $(TITLECONF)

clean-docs:
	rm -rf $(TITLEPAGE)
	rm -rf $(DOCPDF)
