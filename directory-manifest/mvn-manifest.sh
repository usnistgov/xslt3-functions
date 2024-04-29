#!/usr/bin/env bash
# Driver script for calling directory manifest pipeline
# using XML Calabash under Maven

# Thanks NW for the script to model this on

# bash flags for early fail
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}")

Runs the XSLT Directory Manifest process in the current working directory, writing the results of the poll to a Markdown file named 'manifest.md'.

EOF
}

if ! [ -x "$(command -v mvn)" ]; then
  echo 'Error: Maven (mvn) is not in the PATH, is it installed?' >&2
  exit 1
fi

HEREPATH=$(pwd)
HEREPATH="file://${HEREPATH}"

# echo $HEREPATH

echo Producing directory manifest ...

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POM_FILE="${SCRIPT_DIR}/pom.xml"
PIPELINE="${SCRIPT_DIR}/make-markdown-manifest.xproc"

mvn -q \
    -f $POM_FILE \
    exec:java \
    -Dexec.mainClass="com.xmlcalabash.drivers.Main" \
    -Dexec.args="$PIPELINE path=$HEREPATH"

echo See $HEREPATH/manifest.md