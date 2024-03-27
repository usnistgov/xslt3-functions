#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../../common/subcommand_common.bash"

XPROC_FILE="${SCRIPT_DIR}/xspec-test-batch.xpl"
REPORT_HTML="xspec-test-report.html"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")}

Runs $( echo ${XPROC_FILE##*/} ), returning a summary evaluation of its XSpec test set inputs to the console (STDOUT).

Additionally an HTML report is written to file $( echo ${REPORT_HTML##*/} ).

EOF
}

# old invocation with extra ports, dumping extra ports (not currently defined) and leaving port `determination` for STDOUT
# CALABASH_ARGS="-oxspec-results=/dev/null -osummary=/dev/null -ohtml-report=/dev/null \"${XPROC_FILE}\""

# this invocation provides option $theme='uswds' at runtime and writes an HTML file
CALABASH_ARGS="-ohtml-report=\"${REPORT_HTML}\" \"${XPROC_FILE}\" theme=uswds"

if [ $# -ne 0 ] ; then
  usage
else
  invoke_calabash "${CALABASH_ARGS}"
fi
