NAME := Cleanroom_Engineering_Guide
ROOT := $(DOCROOT)/$(NAME)/
DEPS := linearization_process.xml processes.xml processes/*.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

