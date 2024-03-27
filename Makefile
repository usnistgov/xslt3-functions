include common/make_common.mk

# Each subdirectory (recursively) that has a makefile
# Makefile wildcard function does not support that, so we use the shell
# function with the find utility and look ever Makefile in a child dir
# relative to this one, but exclude this one to use with the FOREACH macro.
dirs:=$(shell find '.' ! -wholename ./Makefile -name 'Makefile' -printf "%h\n")

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
spec-test: ## Run all "specification tests", validating this implementation against the Metaschema spec
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))

.PHONY: unit-test
unit-test: ## Run all unit tests
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))

.PHONY: clean
clean: ## Remove any generated test or build artifacts
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))
