NAME := Increment_Construction_Plan
VPATH := $(DOCROOT)/$(NAME)
DEPS := $(STDDOCDEPS)

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(DEPS) $(DOCROOT)/$(NAME)/increments/*.xml
	$(FOP) -xml "$<" -pdf "$@"
