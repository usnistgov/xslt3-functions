#!/bin/bash

# Reset XML Calabash home and classpath as needed
XML_CALABASH=/mnt/c/Users/user/Documents/OSS/XMLCalabash
CLASSPATH=$XML_CALABASH/slf4j-simple-1.7.36.jar:$XML_CALABASH/xmlcalabash-1.5.3-110.jar

HEREPATH=$(pwd)
HEREPATH="file://${HEREPATH}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

echo Producing manifest.md for $HEREPATH ...

java -Xmx1024m -cp $CLASSPATH com.xmlcalabash.drivers.Main -omd=manifest.md -ohtml=/dev/null -odirlist=/dev/null $SCRIPT_DIR/directory-manifest.xpl path=$HEREPATH

echo ... Done
