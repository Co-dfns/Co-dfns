NAME := Cleanroom_Engineering_Guide
ROOT := $(DOCROOT)/$(NAME)/
DEPS := processes.xml */*.xml */*/*.xml */*/*/*.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

