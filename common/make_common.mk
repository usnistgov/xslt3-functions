# Common makefile utilities for the metaschema-xslt project
# Note: any makefile including this file will have the following side-effects:
# 1. The SHELL will be set to bash.
# 2. A "help" target will be added. If the include statement is at the top the
#   default target will become "help" unless overridden with .DEFAULT_GOAL.
# 3. The environment will be populated with the variables seen below

# Gratefully adapted from an original by NW

SHELL:=/usr/bin/env bash

.PHONY: help
# Run "make" or "make help" to get a list of user targets
# Adapted from https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# To include a target in the help text, follow the following format:
#   <target(s)>: [dependencies] ## Comment
help: ## Show this help message
	@grep --no-filename -E '^[a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | awk 'BEGIN { \
	 FS = ":.*?## "; \
	 printf "\033[1m%-30s\033[0m %s\n", "TARGET", "DESCRIPTION" \
	} \
	{ printf "\033[32m%-30s\033[0m %s\n", $$1, $$2 }'

# The path to the pom directory
pom_path:=./pom.xml

define EXEC_MAVEN
	mvn --quiet -f "${pom_path}" exec:java \
    	-Dexec.mainClass="$1" \
		-Dexec.args="$2"
endef

# XML Calabash helper macro
define EXEC_CALABASH
	$(call EXEC_MAVEN,com.xmlcalabash.drivers.Main,$1)
endef

# Saxon helper macro
define EXEC_SAXON
	$(call EXEC_MAVEN,net.sf.saxon.Transform,$1)
endef

define FOREACH
	for $1 in $2; do {\
		$3 ;\
	} done
endef

# Run a Makefile target for each directory, requiring each directory to have a given target
define FOREACH_MAKE
	@echo Running makefile target \'$1\' on all subdirectory makefiles
	@$(call FOREACH,dir,$2,$(MAKE) -C $$dir $1)
endef

# Run a Makefile target for each directory, skipping directories whose Makefile does not contain a rule
define FOREACH_MAKE_OPTIONAL
	@echo Running makefile target \'$1\' on all subdirectory makefiles that contain the rule
	@$(call FOREACH,dir,$2,$(MAKE) -C $$dir -n $1 &> /dev/null && $(MAKE) -C $$dir $1 || echo "Makefile target '$1' failed or does not exist in "$$dir". Continuing...")
endef
