<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
            xmlns:c="http://www.w3.org/ns/xproc-step"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:t="http://www.jenitennison.com/xslt/xspec"
            xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
            name="xspec-test-batch"
            type="mx:xspec-test-batch"
            version="1.0">
   
<!-- A model XProc showing how to run a set of XSpec documents in place,
     showing:
   
   'xspec-results' - XSpec results
   'summary' - XML-based summary
   'determination' short synopsis in plain text (for console)
   
   - At a convenient location, copy and rename
        this file
        shell script mvn-xproc-xspec-test-batch.sh
   
   - rewire
       xproc: omit any unwanted ports or serialization settings
              update import link
              bind XSpec documents to the input port
       shell: update names and settings
       
   - run to capture the collected results of those XSpecs together
   
   -->
   
   <!-- XSpecs to run -->
   <p:input port="xspec" sequence="true">
      <p:document href="xspec-shell.xspec"/>
      <p:document href="xspec-basic.xspec"/>
   </p:input>

   <!-- set to 'clean', 'classic', 'uswds' or 'toybox', and/or override in the call -->
   <p:option name="theme" select="'clean'"/>
   
   <p:input port="parameters" kind="parameter"/>
   
   <!-- Any of these output ports can be removed, if unwanted, or redirected to /dev/null -->
   
   <!--<p:serialization port="xspec-results" indent="true"/>
   <p:output port="xspec-results">
      <p:pipe port="xspec-results" step="test-batch"/>
   </p:output>
   
   <p:serialization port="summary" indent="true"/>
   <p:output port="summary">
      <p:pipe port="summary" step="test-batch"/>
   </p:output>-->
   
   <p:serialization port="determination" indent="true" method="text"/>
   <p:output port="determination">
      <p:pipe port="determination" step="test-batch"/>
   </p:output>
   
   <p:serialization port="html-report" indent="false" method="html"/>
   <p:output port="html-report">
      <p:pipe port="html-report" step="test-batch"/>
   </p:output>
   
   <p:import href="../xspec-batch-report.xpl"/>

   <!-- incipit -->
   <mx:xspec-batch name="test-batch">
      <p:with-option name="theme" select="$theme">
         <p:empty/>
      </p:with-option>
   </mx:xspec-batch>
   
</p:declare-step>
