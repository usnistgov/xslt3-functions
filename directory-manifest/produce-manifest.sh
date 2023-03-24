#!/bin/bash

XML_CALABASH=/mnt/c/Users/wap1/Documents/OSS/XMLCalabash/xmlcalabash-1.5.3-110.jar:/mnt/c/Users/wap1/Documents/OSS/XMLCalabash/lib/slf4j-nop.jar

# /xmlcalabash-1.5.3-110.jar

RESOURCE_DIR=$pwd

java -Xmx1024m -cp $XML_CALABASH com.xmlcalabash.drivers.Main -omd=manifest.md -ohtml=/dev/null directory-manifest.xpl path=$RESOURCE_DIR

# java -Xmx1024m -cp $XML_CALABASH_JAR com.xmlcalabash.drivers.Main -?
