NAME := Increment_Test_Plan
ROOT := $(DOCROOT)/$(NAME)/
DEPS := statistical_and_coverage_test_cases.xml usage_model_overview.xml \
        testing_plan_and_procedures.xml tables/*.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

