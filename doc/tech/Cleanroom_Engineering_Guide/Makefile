NAME := Cleanroom_Engineering_Guide
VPATH := $(DOCROOT)/$(NAME)
DEPS := linearization.xml processes.xml

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

processes.xml: $(DOCROOT)/$(NAME)/processes/*.xml
