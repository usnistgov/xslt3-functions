#!/bin/bash

# This script attempts to download NineML libraries needed to provide support in oXygen XML
# NOTNEEDED (disabled clause) includes calls for other components not needed by oXygen

mkdir -p lib

download() {
    proj=$1
    lcproj=`echo $proj | tr '[:upper:'] '[:lower:]'`
    uri="https://github.com/nineml/$lcproj/releases/latest"
    ver=`curl -sI $uri | grep -i location: | sed "s#^.*/tag/##" | tr -d '\n\r'`
    if [ ! -f "lib/$proj-$ver.jar" ]; then
        echo "Downloading $proj ..."
        rm -f lib/$proj-*.jar
        uri="https://github.com/nineml/$lcproj/releases/download/$ver/$lcproj-$ver.zip"
        curl -s -L -o lib/$lcproj-$ver.zip $uri
        cd lib
        unzip -q -j $lcproj-$ver.zip "*.jar"
        rm $lcproj-$ver.zip
        cd ..
    fi
}

download CoffeeGrinder
download CoffeeFilter
download CoffeeSacks

: <<'NOTNEEDED'
if [ ! -d lib/xmlcalabash1-coffeepress.jar ]; then
    echo "Downloading CoffeePress ..."
    curl -s -L -o coffeepress.zip \
         https://github.com/ndw/xmlcalabash1-coffeepress/releases/download/1.0.0/xmlcalabash1-coffeepress-1.0.0.zip
    unzip -q -j coffeepress.zip "*.jar"
    mv *.jar lib/
    rm -f coffeepress.zip
fi

if [ ! -d xmlcalabash-1.5.7-120 ]; then
    echo "Downloading XML Calabash ..."
    curl -s -L -o xmlcalabash.zip \
         https://github.com/ndw/xmlcalabash1/releases/download/1.5.7-120/xmlcalabash-1.5.7-120.zip
    unzip -q xmlcalabash.zip
    rm -f xmlcalabash.zip
fi

if [ ! -f saxon-he-12.3.jar ]; then
    echo "Downloading Saxon 12.3 ..."
    curl -s -L -o SaxonHE12-3J.zip https://www.saxonica.com/download/SaxonHE12-3J.zip
    unzip -q -o SaxonHE12-3J.zip "*.jar"
    rm -f SaxonHE12-3J.zip saxon-he-test*.jar saxon-he-xqj*.jar
fi
NOTNEEDED
