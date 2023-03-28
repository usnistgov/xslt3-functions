#!/bin/bash

# /mnt/c/Users/wap1/Documents/OSS/XMLCalabash/slf4j-simple-1.7.36.jar:
# XML_CALABASH=/mnt/c/Users/wap1/Documents/OSS/XMLCalabash/xmlcalabash-1.5.3-110.jar
XML_CALABASH=/mnt/c/Users/wap1/Documents/OSS/XMLCalabash/slf4j-simple-1.7.36.jar:/mnt/c/Users/wap1/Documents/OSS/XMLCalabash


HEREPATH=$(pwd)
HEREPATH="file://${HEREPATH}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

echo Producing manifest.md for $HEREPATH ...

java -Xmx1024m -cp $XML_CALABASH/slf4j-simple-2.0.7.jar:$XML_CALABASH/xmlcalabash-1.5.3-110.jar com.xmlcalabash.drivers.Main -omd=manifest.md -ohtml=/dev/null -odirlist=/dev/null $SCRIPT_DIR/directory-manifest.xpl path=$HEREPATH

echo ... Done


# java -Xmx1024m -cp $XML_CALABASH_JAR com.xmlcalabash.drivers.Main -?
