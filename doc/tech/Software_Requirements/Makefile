NAME := Software_Requirements
DEPS := $(DOCROOT)/$(NAME)/requirements/*.xml

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"
