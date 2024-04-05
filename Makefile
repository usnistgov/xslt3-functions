include common/make_common.mk

# We'd like to descend to each subdirectory (recursively) that has a makefile
# Makefile wildcard function does not support that, so we use the shell
# function with the find utility and examine each Makefile in a child dir
# relative to this one, excluding this one to use with the FOREACH macro.
dirs:=$(shell find '.' ! -wholename ./Makefile -name 'Makefile' -printf "%h\n")

# This enables project-level configuration. Each project's own Makefile
# can arrange its own testing accordingly, while making it easy to expose new tests to
# the CI/CD runtime, by using any of the targets provided for here.

# Make logic modeled after an example provided by NW: we are still learning

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output

# $folder can be passed in as folder=[folder]
folder?=.


# See Makefile configuration in project files for examples of how to set up calls to 'make'
# including wiring XSpec tests and wiring XSpec tests to these (top-level) targets 


.PHONY: test
test: ## Run all tests
	$(call FOREACH_MAKE,$@,$(dirs))


.PHONY: pre-checks
pre-checks: ## Run all "pre checks", enforcing validation contracts across input artifacts
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))


.PHONY: smoke-test
smoke-test: ## Run all "smoke tests", establishing a baseline of sanity across the project
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))


.PHONY: spec-test
spec-test: ## Run all "specification tests", validating an implementation against a spec
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))


.PHONY: unit-test
unit-test: ## Run all unit tests (ci/cd)
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))


.PHONY: clean
clean: ## Remove any generated test or build artifacts
	rm -fr $(output_folder)/*
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))
