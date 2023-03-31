<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0"
    xmlns:x3f="http://csrc.nist.gov/ns/xslt3-functions"
    type="x3f:directory-manifest" name="directory-manifest">
    
    <!-- Purpose: Same as make-markdown-manifest.xpl, except using XProc 3.0 -->
    
    <!--
    Experimental XProc 3 version of directory-manifest.xpl
    Tested with Morgana XProc see https://www.xml-project.com/morganaxproc-iiise.html
       
    To run: provide a URI to a directory
    Like its XProc 1.0 original, the pipeline
      - retrieves a directory listing,
      - feeds it to an XSLT producing HTML
      - feeds this result to a Markdown generator
    
    The result is Markdown suitable for placing into a README or other folder-level documentation
    listing XSLT and XProc instances
    
    following a convention for listing and annotating these to produce an HTML report
    (codified in XSLT directory-listing.xsl)
    
    -->
    
    <!-- The 'path' option indicates which directory to poll, as a file:/ URI -->
    <p:option name="path" select="'.'"/>
    
    <!-- :::::    :::::     :::::    :::::     :::::    :::::     :::::    :::::     :::::    :::::     :::::   -->
    
    <p:directory-list name="dirlist">
        <p:with-option name="path" select="$path"/>
    </p:directory-list>
    
    <!--<p:identity name="survey"/>-->
    <p:xslt name="survey">
        <p:with-input port="stylesheet" href="directory-listing.xsl"/>
        <!--<p:with-option name="parameters" select="map { 'path': $path }"/>-->
    </p:xslt>
    
    <!--<p:identity name="markdown"/>-->
    <p:xslt name="markdown">
        <p:with-input port="stylesheet" href="html-to-markdown.xsl"/>
    </p:xslt>
    
    <p:store href="manifest.md" serialization="map { 'method': 'text' }"/>
    
</p:declare-step>