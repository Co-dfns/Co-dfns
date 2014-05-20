NAME := Statement_of_Work
VPATH := $(DOCROOT)/$(NAME)
DEPS := $(STDDOCDEPS)

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"
