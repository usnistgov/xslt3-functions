include ../common/make_common.mk

# XML Calabash prefers absolute paths

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=test_output


.PHONY: test
test: spec-test ## Run all tests


# binding xspec-tests to spec-test brings it under CI/CD when that task is run from above
.PHONY: spec-test
spec-test: xspec-tests ## Run specification tests (currently xspec-tests)


.PHONY: xspec-tests
xspec-tests: ## Run XSpecs found in tests folder
	mkdir -p $(output_folder)
	mvn --quiet \
   	-f "../common/pom.xml" \
   	exec:java \
   	-Dexec.mainClass="net.sf.saxon.Transform" \
   	-Dexec.args="-it:go -xsl:\"../xspec-dev/XSPEC-BATCH.xsl\" -init:org.nineml.coffeesacks.RegisterCoffeeSacks stop-on-error=yes folder=random-util/tests"

.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*
