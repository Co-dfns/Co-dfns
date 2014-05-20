NAME := Statement_of_Work

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS)
	$(FOP) -xml "$<" -pdf "$@"
