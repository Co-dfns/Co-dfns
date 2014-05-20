NAME := Engineering_Change_Log
VPATH := $(DOCROOT)/$(NAME)

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) summary_table.xml change_list.xml
	$(FOP) -xml "$<" -pdf "$@"

summary_table.xml: $(DOCROOT)/$(NAME)/0*/*_summary.xml

change_list.xml: $(DOCROOT)/$(NAME)/0*/*_entry.xml
