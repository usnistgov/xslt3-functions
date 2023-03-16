<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    
    <!-- To run: provide a URI to a directory
    The pipeline:
    - retrieves a directory listing
    - feeds it to an XSLT producing HTML
    - feeds this result to a Markdown generator
    
    The result is Markdown suitable for placing into a README or other folder-level documentation
    listing XSLT and XProc instances
    
    following a convention for listing and annotating these to produce an HTML report
    (codified in XSLT directory-listing.xsl)
    
    -->
    
    
    <p:option name="path" select="'.'"/>
    
    <p:input port="parameters" kind="parameter"/>
    
    <p:serialization port="html-report" indent="true"/>
    <p:output port="html-report">
        <p:pipe port="result" step="survey"/>
    </p:output>
    
    <p:serialization port="md-report" method="text"/>
    <p:output port="md-report">
        <p:pipe port="result" step="markdown"/>
    </p:output>
    
    <p:directory-list>
        <p:with-option name="path" select="$path"/>
    </p:directory-list>
    
    <p:xslt name="survey">
        <p:input port="stylesheet">
            <p:document href="directory-listing.xsl"/>
        </p:input>
        <p:with-param name="path" select="$path"/>
    </p:xslt>
    
    <p:xslt name="markdown">
        <p:input port="stylesheet">
            <p:document href="html-to-markdown.xsl"/>
        </p:input>
    </p:xslt>
    
</p:declare-step>