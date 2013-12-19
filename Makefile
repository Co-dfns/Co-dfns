DOCSRC := Cleanroom\ Engineering\ Guide.xml Software\ Architecture.xml \
          Engineering\ Change\ Log.xml Software\ Development\ Plan.xml \
          Function\ Specification.xml Software\ Requirements.xml \
          Increment\ Certification\ Report.xml Statement\ of\ Work.xml \
          Increment\ Construction\ Plan.xml Statistical\ Testing\ Report.xml \
					Increment\ Test\ Plan.xml Usage\ Specification.xml Project\ Record.xml
DOCPDF := $(DOCSRC:.xml=.pdf)
XSL := fo.xsl
XCONF := fop.xconf

all: docs CoDfns.dyalog

docs: $(DOCPDF)

CoDfns.dyalog: libcodfns.so

libcodfns.so: codfns.h codfns.c
	clang -shared -fPIC -o libcodfns.so codfns.c

%.pdf: %.xml $(XSL) $(XCONF)
	fop -c $(XCONF) -xsl $(XSL) -xml "$<" -pdf "$@"
