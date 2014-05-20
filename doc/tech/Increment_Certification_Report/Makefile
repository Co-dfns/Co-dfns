NAME := Increment_Certification_Report
VPATH := $(DOCROOT)/$(NAME)
DEPS := $(STDDOCDEPS)

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"
