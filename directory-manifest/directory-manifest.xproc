<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
    xmlns:x3f="http://csrc.nist.gov/ns/xslt3-functions"
    type="x3f:directory-manifest" name="directory-manifest">
    
    <!-- Purpose: Provide a pipeline with ports exposed for debugging generating HTML and Markdown from a set of XML files being polled -->
    <!-- Steps: retrieves a directory listing; feeds it to an XSLT producing HTML; feeds this result to a Markdown generator -->
    <!-- Output: Markdown suitable for placing into a README or other folder-level documentation -->
    
    <p:option name="path" select="'.'"/>
    
    <p:input port="parameters" kind="parameter"/>
    
    <p:serialization port="dirlist" method="xml" indent="true"/>
    <p:output port="dirlist" primary="false">
        <p:pipe port="result" step="dirlist"/>
    </p:output>
    
    <p:serialization port="html" method="html" indent="true"/>
    <p:output port="html">
        <p:pipe port="result" step="survey"/>
    </p:output>

    <p:serialization port="md" method="text"/>
    <p:output port="md" primary="true">
        <p:pipe port="result" step="markdown"/>
    </p:output>
    
    <!-- :::::    :::::     :::::    :::::     :::::    :::::     :::::    :::::     :::::    :::::     :::::   -->
    
    <p:directory-list name="dirlist">
        <p:with-option name="path" select="$path"/>
    </p:directory-list>
    
    <!--<p:identity name="survey"/>-->
    <p:xslt name="survey">
        <p:input port="stylesheet">
            <p:document href="directory-listing.xsl"/>
        </p:input>
    </p:xslt>
    
    <!--<p:identity name="markdown"/>-->
    <p:xslt name="markdown">
        <p:input port="stylesheet">
            <p:document href="html-to-markdown.xsl"/>
        </p:input>
    </p:xslt>
    
</p:declare-step>