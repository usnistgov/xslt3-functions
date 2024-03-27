#!/bin/bash

# This script attempts to download MorganaXProcIII


mkdir -p lib

pushd lib

morgana=MorganaXProc-IIIse-1.3.6

morgana_download="https://sourceforge.net/projects/morganaxproc-iiise/files/${morgana}/${morgana}.zip/download"

if [ ! -f "${morgana}.zip" ]; then
    echo "Downloading Morgana XProc III SE ..."
    curl -L -o "${morgana}.zip"  "${morgana_download}"
    unzip -qo "${morgana}.zip" -x __MACOSX/**
fi


if [ ! -f MorganaXProc-IIIse-1.3.6/MorganaXProc-IIIse_lib/saxon-he-12.3.jar ]; then
    echo "Downloading Saxon 12.3 ..."
    curl -s -L -o SaxonHE12-3J.zip https://www.saxonica.com/download/SaxonHE12-3J.zip
    unzip -q -o SaxonHE12-3J.zip "*.jar"
    rm -f SaxonHE12-3J.zip saxon-he-test*.jar saxon-he-xqj*.jar lib/*
    rmdir lib
    mv -f saxon-he-12.3.jar MorganaXProc-IIIse-1.3.6/MorganaXProc-IIIse_lib

fi

# C:\Users\wap1\Documents\usnistgov\metaschema-xslt\support\lib\MorganaXProc-IIIse-1.3.6\MorganaXProc-IIIse_lib

popd

