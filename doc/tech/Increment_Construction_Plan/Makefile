NAME := Increment_Construction_Plan
DEPS := $(DOCROOT)/$(NAME)/increments/*.xml

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"
