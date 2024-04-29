<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
            xmlns:c="http://www.w3.org/ns/xproc-step"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:t="http://www.jenitennison.com/xslt/xspec"
            xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
            name="xspec-batch"
            type="mx:xspec-batch"
            version="1.0">

   <!-- Study reference: ../lib/xspec/src/harnesses/saxon/saxon-xslt-harness.xproc by Florent Georges -->
   
   <p:input port="xspec"/>
   
   <p:input port="parameters" kind="parameter"/>
   
   <p:option name="theme" select="'clean'"/>
   
   <!--nb unless patched in the imported XSLT, HTML comes with pseudo-output escaping into Unicode PUA
       see ../lib/xspec/src/reporter/format-utils.xsl /*/xsl:function[@name='fmt:disable-escaping'] -->
   <p:serialization port="xspec-result" indent="true" method="html"/>
   <p:output port="xspec-result">
      <p:pipe port="result" step="evaluate-xspec"/>
   </p:output>
   
   <p:serialization port="html-report" indent="false" method="html"/>
   <p:output port="html-report">
      <p:pipe port="result" step="html-report"/>
   </p:output>
   
   <!--<p:serialization port="summary" indent="true"/>
   <p:output port="summary">
      <p:pipe port="result" step="summary"/>
   </p:output>
   
   <p:serialization port="determination" indent="true" method="text"/>
   <p:output port="determination">
      <p:pipe port="result" step="determination"/>
   </p:output>-->
   
   <p:import href="../lib/xspec/src/harnesses/harness-lib.xproc"/>

   <t:compile-xslt name="compile"><!-- thanks to gimsieke for tip on static-base-uri()
     this can be removed when issue is addressed https://github.com/xspec/xspec/issues/1832 -->      
      <p:with-param name="xspec-home" select="resolve-uri('../lib/xspec/',static-base-uri())"/>
   </t:compile-xslt>

   <p:xslt name="evaluate-xspec" template-name="t:main">
      <p:input port="source">
         <p:empty/>
      </p:input>
      <p:input port="stylesheet">
         <p:pipe step="compile" port="result"/>
      </p:input>
      <p:input port="parameters">
         <p:empty/>
      </p:input>
   </p:xslt>

   <p:xslt name="html-report">
      <p:input port="stylesheet">
         <p:document href="xspec-mx-html-report.xsl"/>
      </p:input>
      <p:with-param name="theme" select="$theme"/>
   </p:xslt>
   
   <!--<p:sink/>
      
   <p:xslt name="summary">
      <p:input port="source">
         <p:pipe port="result" step="evaluate-xspec"/>
      </p:input>
      <p:input port="stylesheet">
         <p:document href="xspec-summarize.xsl"/>
      </p:input>
   </p:xslt>
   
   <p:xslt name="determination">
      <p:input port="stylesheet">
         <p:document href="xspec-summary-reduce.xsl"/>
      </p:input>
   </p:xslt>-->
   
</p:declare-step>
