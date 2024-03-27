#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../common/subcommand_common.bash"

XSLT_FILE="${SCRIPT_DIR}/XSPEC-SINGLE.xsl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} XSPEC_FILE [ADDITIONAL_ARGS]

Compiles and executes XSpec in Saxon, producing an HTML report of the test results.

As an additional argument, 'theme' may be used to indicate styling in the HTML:
  theme=(clean|classic|toybox|uswds) defaulting to clean

EOF
}

[[ -z "${1-}" ]] && { echo "Error: XSPEC_FILE not specified"; usage; exit 1; }
XSPEC_FILE=$1

ADDITIONAL_ARGS=$(shift 1; echo "${*// /\\ }")

RESULT_FILE="$( echo $(basename "${XSPEC_FILE%.*}") )-result.html"

mkdir -p xspec

SAXON_ARGS="-s:\"$XSPEC_FILE\" -o:\"${RESULT_FILE}\" -xsl:\"${XSLT_FILE}\" -init:org.nineml.coffeesacks.RegisterCoffeeSacks \
                $ADDITIONAL_ARGS"


## show usage if a first argument is '-h', expanding $1 to '' if not set
if [ "${1:-}" = '-h' ] || [ "${1:-}" = '--help' ];

then

  usage

else

  invoke_saxon "${SAXON_ARGS}"

fi