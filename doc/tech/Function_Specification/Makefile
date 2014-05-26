NAME := Function_Specification
ROOT := $(DOCROOT)/$(NAME)/
DEPS := tables/*.xml black_box_definitions.xml canonical_sequence_analysis.xml \
        derived_requirements.xml expression_enumeration.xml function_enumeration.xml \
        function_expression_enumeration.xml module_invocation_enumeration.xml \
        overview.xml software_boundaries.xml specification_functions.xml \
        stimuli_and_responses.xml top-level_enumeration.xml  \
        properties/*.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

