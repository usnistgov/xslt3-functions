<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    
    <p:input port="parameters" kind="parameter"/>
    
    <p:serialization port="html-report" indent="true"/>
    <p:output port="html-report">
        <p:pipe port="result" step="survey"/>
    </p:output>
    
    <p:serialization port="md-report" method="text"/>
    <p:output port="md-report">
        <p:pipe port="result" step="markdown"/>
    </p:output>
    
    <p:directory-list path="."/>
    
    <p:xslt name="survey">
        <p:input port="stylesheet">
            <p:document href="directory-listing.xsl"/>
        </p:input>
    </p:xslt>
    
    <p:xslt name="markdown">
        <p:input port="stylesheet">
            <p:document href="html-to-markdown.xsl"/>
        </p:input>
    </p:xslt>
    
</p:declare-step>