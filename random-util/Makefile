include ../common/make_common.mk

# XML Calabash prefers absolute paths

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=test_output


xspec_script:=../xspec-dev/mvn-saxon-xspec-batch-quiet.sh
xspec_ci_script:=../xspec-dev/mvn-saxon-xspec-batch.sh

.PHONY: test
test: spec-test ## Run all tests


# binding xspec-tests to spec-test brings it under CI/CD when that task is run from above
.PHONY: spec-test
spec-test: xspec-tests ## Run specification tests (currently xspec-tests)


.PHONY: xspec-tests
xspec-tests: ## Run XSpecs found in 'tests' folder
	mkdir -p $(output_folder)
	LOGFILE="$(output_folder)/xspec-tests.log" $(xspec_script) \
		"baseURI=file:$(module_path)/" \
		"folder=tests" \
		"report-to=$(output_folder)" \
		"stop-on-error=no" \
		"recurse=yes" \
		"theme=toybox"


.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*
