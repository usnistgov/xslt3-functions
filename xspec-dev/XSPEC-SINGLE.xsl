<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   exclude-result-prefixes="xs math"
   version="3.0">
   
   <!-- Like xspec-single-report.xproc, except running as an XSLT
   
   accepts runtime parameter theme=clean|classic|uswds|toybox
   to assign a theme to the output
   
   depends on:
     availability of XSpec Compiler XSLT from its distribution
       bound as $compiler-xslt-path
     imported XSLT xspec-mx-html-report.xsl to provide report formatting

   Goal: a standalone XSLT-only version of an XSpec executable
     among other things so we can make iXML / extensions available
     by running in Saxon whereby we have access to its extensibility
     
   -->  
   
   <!-- conceptual pipeline:
      1. Compiles XSpec into XSLT
      2. Executes XSLT
      3. Formats results in HTML with themed CSS
      
      In the usual XSLT way, this is dispatched in reverse,
      by formatting the results of executing a transformation
        generated from the source data (using a transformation)
   -->
   
   <xsl:param name="compiler-xslt-path" as="xs:string">../lib/xspec/src/compiler/compile-xslt-tests.xsl</xsl:param>
   
   <!-- in no mode, the imported stylesheet makes HTML reports from XSpec execution results -->
   <xsl:import href="xspec-mx-html-report.xsl"/>

   <!-- for debugging -->
   <xsl:template name="compile-xspec">
      <xsl:sequence select="mx:compile-xspec(. (: ,base-uri(.) :) )"/>
   </xsl:template>
   
   <xsl:template match="/">   <!-- change context into the execution results --> 
      <xsl:for-each select="mx:compile-xspec(. (: ,base-uri(.) :) ) => mx:execute-xspec()">
         <!-- apply the imported formatting logic --> 
         <xsl:call-template name="html-report"/>
      </xsl:for-each>
      <xsl:message> ... and formatted a report.</xsl:message>   
   </xsl:template>

   <!-- Accepts an XSpec document and throws it at the compiler -->
   <!-- todo: try/catch? what are the ways this can fail? -->
   <xsl:function name="mx:compile-xspec" as="document-node()?" cache="true">
      <xsl:param name="xspec" as="document-node()"/>
      <!--<xsl:param name="xspec-name" as="xs:anyURI"/>-->
      <xsl:variable name="runtime-params" as="map(xs:QName,item()*)">
         <xsl:map>
            <xsl:map-entry key="QName('', 'xspec-home')" select="resolve-uri('./xspec/', static-base-uri())"/>
         </xsl:map>
      </xsl:variable>
      <xsl:variable name="runtime" as="map(xs:string, item())">
         <xsl:map>
            <xsl:map-entry key="'xslt-version'" select="3.0"/>
            <xsl:map-entry key="'source-node'" select="$xspec"/>
            <!--<xsl:map-entry key="'global-context-item'" select="doc($xspec-name)"/>-->
            <!-- uhoh - presumably this will have been cached?-->
            <xsl:map-entry key="'stylesheet-location'" select="$compiler-xslt-path"/>
            <xsl:map-entry key="'stylesheet-params'" select="$runtime-params"/>
         </xsl:map>
      </xsl:variable>
      
      <!-- https://www.w3.org/TR/xpath-functions-31/#func-transform -->
      <xsl:sequence select="transform($runtime)?output"/>
      <xsl:message> ... compiled XSpec ... </xsl:message>
   </xsl:function>
   
   <!-- Attempts to execute an XSLT produced by compiling an XSpec
        todo: try/catch? -->
   <xsl:function name="mx:execute-xspec" as="document-node()?" cache="true">
      <xsl:param name="xspec-executable" as="document-node()"/>
      <xsl:variable name="runtime-params" as="map(xs:QName,item()*)">
         <xsl:map/>
      </xsl:variable>
      <xsl:variable name="runtime" as="map(xs:string, item())">
         <!-- call template t:main xmlns:t="http://www.jenitennison.com/xslt/xspec"-->
         <xsl:map>
            <xsl:map-entry key="'xslt-version'" select="3.0"/>
            <xsl:map-entry key="'stylesheet-node'" select="$xspec-executable"/>
            <xsl:map-entry key="'initial-template'" select="QName('http://www.jenitennison.com/xslt/xspec', 'main')"/>
            <xsl:map-entry key="'stylesheet-params'" select="$runtime-params"/>
         </xsl:map>
      </xsl:variable>

      <xsl:sequence select="transform($runtime)?output"/>
      <xsl:message> ... executed XSpec ... </xsl:message>
   </xsl:function>
   
</xsl:stylesheet>