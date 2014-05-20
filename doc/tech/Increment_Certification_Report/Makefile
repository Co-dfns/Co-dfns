NAME := Increment_Certification_Report

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS)
	$(FOP) -xml "$<" -pdf "$@"
