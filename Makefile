include common/make_common.mk

# Each subdirectory (recursively) that has a makefile
# Makefile wildcard function does not support that, so we use the shell
# function with the find utility and look ever Makefile in a child dir
# relative to this one, but exclude this one to use with the FOREACH macro.
dirs:=$(shell find '.' ! -wholename ./Makefile -name 'Makefile' -printf "%h\n")


module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output

xspec_script:=./xspec-dev/mvn-saxon-xspec-batch-quiet.sh
xspec_ci_script:=./xspec-dev/mvn-saxon-xspec-batch.sh

# $folder can be passed in as folder=[folder]
folder?=.

# Two different ways to use the testing infrastructure
# - throw any XSpec into a 'tests' directory, and it will be processed
# - OR, place a Makefile in the project directory
#     providing scripts for targets smoke-test, spec-test and unit-test as wanted


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
