include ../common/make_common.mk

# XML Calabash prefers absolute paths

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=test_output


xspec_script:=../xspec-dev/mvn-saxon-xspec-batch-quiet.sh
xspec_ci_script:=../xspec-dev/mvn-saxon-xspec-batch.sh

xspec-args:="folder=tests stop-on-error=yes theme=toybox report-to=xpec-test-results.html"

.PHONY: test
test: xspec-tests ## Run all tests


.PHONY: xspec-tests
xspec-tests: ## Run XSpecs found in 'tests' folder
	mkdir -p $(output_folder)
	LOGFILE="$(output_folder)/xspec-tests.log" $(xspec_script) \
		"baseURI=file:$(module_path)/" \
		"folder=tests" \
		"report-to=$(output_folder)" \
		"stop-on-error=no" \
		"recurse=yes"

.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*
