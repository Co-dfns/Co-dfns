DOCSRC := Cleanroom_Engineering_Guide.xml Software_Architecture.xml \
          Engineering_Change_Log.xml Software_Development_Plan.xml \
          Function_Specification.xml Software_Requirements.xml \
          Increment_Certification_Report.xml Statement_of_Work.xml \
          Increment_Construction_Plan.xml Statistical_Testing_Report.xml \
	  Increment_Test_Plan.xml Usage_Specification.xml Project_Record.xml
DOCPDF := $(DOCSRC:.xml=.pdf)
XSL := fo.xsl
XCONF := fop.xconf
TITLEXSL := ~/Libraries/Docbook5-XSL/template/titlepage.xsl

all: docs CoDfns.dyalog

docs: $(DOCPDF)

CoDfns.dyalog: libcodfns.so

libcodfns.so: codfns.h codfns.c
	clang -shared -fPIC -o libcodfns.so codfns.c

$(DOCPDF): %.pdf: %.xml $(XSL) $(XCONF) titlepage.xsl
	fop -c $(XCONF) -xsl $(XSL) -xml "$<" -pdf "$@"

titlepage.xsl: titlepage.templates.xml
	xsltproc --output "$@" ${TITLEXSL} titlepage.templates.xml
