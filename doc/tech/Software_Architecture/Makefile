NAME := Software_Architecture
ROOT := $(DOCROOT)/$(NAME)/
DEPS := asset_analysis.xml asset_analysis/*.xml \
        runtime_design.xml runtime_design/*.xml \
        top_level_structure.xml top_level/*.xml top_level/*/*.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

