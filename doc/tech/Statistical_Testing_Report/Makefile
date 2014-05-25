NAME := Statistical_Testing_Report
ROOT := $(DOCROOT)/$(NAME)/
DEPS := increments/*.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

