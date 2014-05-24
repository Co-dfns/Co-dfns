NAME := Software_Development_Plan
ROOT := $(DOCROOT)/$(NAME)/
DEPS := mission.xml work_products.xml schedule.xml measurement_plan.xml \
        reuse_analysis.xml configuration_management.xml \
        schedule/*.xml measurement_plan/*.xml work_products/*.xml \
        schedule/milestones/*.xml
DEPS := $(addprefix $(ROOT),$(DEPS))

$(DOCROOT)/$(NAME)/$(NAME).pdf: %.pdf: %.xml $(STDDOCDEPS) $(DEPS)
	$(FOP) -xml "$<" -pdf "$@"

