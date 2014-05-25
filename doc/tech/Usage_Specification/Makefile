NAME := Usage_Specification
ROOT := $(DOCROOT)/$(NAME)/
DEPS := sections/*.xml sections/*/*.xml sections/*/*/*.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

