NAME := Engineering_Change_Log
ROOT := $(DOCROOT)/$(NAME)/
DEPS := summary_table.xml change_list.xml 0*/*_summary.xml 0*/*_entry.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"
