<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:x="http://www.jenitennison.com/xslt/xspec"
   xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   xmlns:err="http://www.w3.org/2005/xqt-errors"
   exclude-result-prefixes="#all"
   version="3.0">
   
   
   <!--Q: redirect STDERR so as not to see runtime messages in the console?
   -->
   
   <!--Main outputs are to be returned to console or file as plain text
   Reports are written as side effects -->
   <xsl:output method="text"/>
   
<!-- NOTE TO DEVS: this is a point of dependency on released XSpec
     If the referenced code moves or changes, this XSLT must be adapted accordingly. -->
   <xsl:param name="junit-reporter-xslt-path"  as="xs:string">./xspec/src/reporter/junit-report.xsl</xsl:param>


   
   <!-- in no mode, the imported stylesheet makes HTML reports from XSpec execution results -->
   <xsl:import href="XSPEC-SINGLE.xsl"/>

<!--
     call template "go" for the full effect - it will do its best
       current impressions are that runtime is fast but no indication of memory consumption
     for diagnostic info including paths to resources that the XSLT will use
       (for reading and writing) use initial template "nogo"
     
     Parameters:
     
     $baseURI (optional, defaults to repository root): a URI indicating a runtime context
       Reset this only if you want a given $folder value (as a URI) to evaluate from a different context
       For example, if a script has baseURI set to the script's file URI, $folder will work relative to the script not the repository
     $folder (optional, defaults to 'src'): a folder, relative to baseURI, where XSpecs are to be found
       By default, the path is directed to all XSpecs in the repo src/ directory
       Or use an absolute (file path) URI (and $baseURI will be ignored)
      
       Reset $folder first (to navigate from the top of the repository), and if it becomes too complex, reset $baseURI
       Alternatively, pass an absolute URI in for $folder and ignore the $baseURI
       Alternatively, give a file path as $baseURI, set $folder to '.' and the evaluation will operate from the file location
      
     $pattern: glob-like syntax for file name matching
       cf https://www.saxonica.com/html/documentation12/sourcedocs/collections/collection-directories.html '?select'
       Use a single file name for a single file
       Use (file1.xspec|file2.xspec|...|fileN.xspec) for file name literals (with URI escaping)
       Defaults to *.xspec (all files suffixed xspec)  
     $recurse (yes|no) identify files recursively - defaults to 'yes'
     $error-on-fail (yes|no) on detecting a failure in test results, terminate the process
       This is useful under CI/CD so a failure in testing 'breaks the build' (note: might terminate early though leaving reports incomplete)
     $stop-on-error (yes|no) hard stop on any failure, or keep going
       Does not stop if a test successfully runs and returns a false result
       Only if tests fail to run for any reason
       Defaults to 'no', but $error-on-fail=yes also sets this to yes
     $report-to - if ends in '.html', a single aggregated report is written to this path relative to the folder (target) path
       otherwise a non-empty $report-to results in each XSpec getting its own report written into a folder of that name
         they will all be together and no precaution is taken for XSpecs with colliding names - take care
         as Saxon will refuse (so rename one of the files or report in aggregate instead)
       if $report is not given, no external reports are written
     $junit-to - if set, with any file suffix (matching regex \..+$), a JUnit report in XML is written to this path relative to folder path
     $theme works as it does in XSPEC-SINGLE.xsl (clean|classic|toybox|uswds)
     
     results:
     
     A failure to read, parse, compile or process any XSpec will drop it with warnings
       unless $stop-on-error=yes in which case the run stops with an error condition
     A run that completes delivers plain text results to -o or STDOUT
     Depending on settings, XSpec reports are formatted and written out as HTML (single or multiple)
     
     -->
   
   <xsl:param name="baseURI" as="xs:string" select="resolve-uri('../..', static-base-uri())"/>
   
   <xsl:param name="folder"  as="xs:string">.</xsl:param>

   <xsl:param name="pattern" as="xs:string">*.xspec</xsl:param>
   
   <xsl:param name="recurse" as="xs:string">no</xsl:param>
   
   <xsl:param name="report-to" as="xs:string?"/>
   <!-- non-null values produce either a single HTML report, when ending in '.html'
        or one report for each XSpec, to a separate file
        nb memory usage may be heavy under the first scenario, untested! -->
   <xsl:variable name="reporting" as="xs:boolean" select="boolean($report-to)"/>
   <xsl:variable name="reporting-aggregate" as="xs:boolean" select="ends-with($report-to,'.html')"/>
   
   <xsl:param name="junit-to" as="xs:string?"/>
   <!-- a path to which an XML file is written -->

   <xsl:param    name="error-on-fail" as="xs:string">no</xsl:param>
   <xsl:variable name="failing-hard" as="xs:boolean" select="$error-on-fail=('yes','true')"/>
   
   <xsl:param    name="stop-on-error" as="xs:string">no</xsl:param>
   <xsl:variable name="stopping-on-error" as="xs:boolean" select="$stop-on-error=('yes','true') or $failing-hard"/>
     
   <xsl:variable name="collection-location" select="resolve-uri($folder, $baseURI)"/>
   
   <xsl:variable name="collection-args" as="xs:string" expand-text="true">
      <xsl:variable name="s">select={$pattern}</xsl:variable>
      <xsl:variable name="r">recurse={ if ($recurse=('no','false')) then 'no' else 'yes' }</xsl:variable>
      <xsl:variable name="e">on-error={ if ($stopping-on-error) then 'fail' else 'warning' }</xsl:variable>
      <xsl:value-of select="($s,$r,$e,'metadata=yes') => string-join(';')"/>
   </xsl:variable>
   
   <xsl:variable name="collection-uri" select="($collection-location, $collection-args) => string-join('?')"/>
   
   <xsl:variable name="collection-in" as="map(*)*">
      
      <xsl:try select="collection( $collection-uri )">
         <xsl:catch>
            <xsl:message terminate="{ if ($stopping-on-error) then 'yes' else 'no' }" expand-text="true">ERROR: Unable to resolve collection at URI {$collection-uri} - getting {$err:code} '{$err:description}'</xsl:message>
         </xsl:catch>
      </xsl:try>
   </xsl:variable>
   
   <xsl:template name="nogo" expand-text="true">
      <xsl:text>Param $baseURI is: { $baseURI }&#xA;</xsl:text>
      <xsl:text>Static base URI is: { static-base-uri() }&#xA;</xsl:text>
      <xsl:text>Collection location is: { $collection-location }&#xA;</xsl:text>
      
   </xsl:template>
   
   <xsl:template name="go">
      <!--<xsl:call-template name="report-locations"/>-->
      <xsl:text expand-text="true">Acquiring collection from { $collection-uri }&#xA;</xsl:text>
      
      <xsl:variable name="all-compiled" as="document-node()*">
         <xsl:iterate select="$collection-in">
            <xsl:variable name="my" as="map(*)" select="."/>
            <!-- we could execute $my?fetch(), except it has the wrong static context and does not produce
                 a viable (self-executing) XSLT stylesheet as the compiled results -
                 the path to the XSLT being tested is broken.
                 Accordingly, we use collection() only to get our name list, then compile
                 each XSpec from its own context. -->
            <xsl:try select="$my?name => xs:anyURI() => mx:compile-xspec-at-uri()">
               <xsl:catch>
                  <xsl:message terminate="{ if ($stopping-on-error) then 'yes' else 'no' }" expand-text="true">ERROR: Unable to compile XSpec at { $my?name } - getting {$err:code} '{$err:description}'</xsl:message>
               </xsl:catch>
            </xsl:try>
         </xsl:iterate>
      </xsl:variable>
      <xsl:variable name="all-executed" as="document-node()*">
            <xsl:iterate select="$all-compiled">
               <xsl:try select="mx:execute-xspec(.)">
                  <xsl:catch>
                     <!--<xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"-->
                     <xsl:message terminate="{ if ($stopping-on-error) then 'yes' else 'no' }" expand-text="true">ERROR:
                        Unable to execute compiled XSpec from { /*/xsl:variable[@name='Q{{http://www.jenitennison.com/xslt/xspec}}xspec-uri'] } - getting {$err:code}
                        '{$err:description}'</xsl:message>
                  </xsl:catch>
               </xsl:try>
            </xsl:iterate>
      </xsl:variable>
      <xsl:variable name="aggregated-results" as="document-node()">
         <xsl:document>
            <RESULTS>
               <xsl:sequence select="$all-executed"/>
            </RESULTS>
         </xsl:document>
      </xsl:variable>

      <xsl:apply-templates select="$aggregated-results/RESULTS" mode="emit-reports"/>
      
      <xsl:call-template name="junit-report">
         <xsl:with-param name="xspec-results" select="$aggregated-results"/>
      </xsl:call-template>
      
      <!-- For completeness we report if we can see that tests were dropped along the way - this goes into main output,
           post summary, not the message stream -->
      <xsl:variable name="reported-xspecs" select="$aggregated-results/RESULTS/*/@xspec"/>
      <xsl:variable name="dropped" select="$collection-in[not(.?name = $reported-xspecs)]"/>
      <xsl:if test="exists($dropped)" expand-text="true">
         <xsl:text>WARNING: of { count($collection-in) } { if (count($collection-in)=1) then 'file' else 'files' }, { count($dropped) } { if (count($dropped) = 1) then 'file selected was' else 'were' } dropped - either unavailable, would not compile (XSpec to XSLT), or would not execute (XSLT):&#xA;</xsl:text>
         <xsl:text expand-text="true">   { $dropped?name => string-join(',&#xA;   ') }&#xA;</xsl:text>
      </xsl:if>
      
      <!-- An aggregated report is produced for -o or STDOUT using transformations xspec-summarize.xsl and xspec-summary-reduce.xsl over $aggregated-results -->
      <xsl:sequence select="$aggregated-results => mx:transform-with(xs:anyURI('xspec-summarize.xsl')) => mx:transform-with(xs:anyURI('xspec-summary-reduce.xsl'))"/>
      
      <xsl:if test="$failing-hard and $aggregated-results//x:test/@successful!='true'">
         <xsl:message terminate="yes">Failures detected - process terminating - </xsl:message>
      </xsl:if>
            
   </xsl:template>

   <xsl:template name="junit-report">
      <xsl:param name="xspec-results" as="document-node()?"/>
      <xsl:if test="boolean($junit-to)">
         <xsl:choose>
            <xsl:when test="matches($junit-to, '\.[^.]+$') and ($junit-to castable as xs:anyURI)">
               <xsl:variable name="junit-reports" select="$xspec-results/RESULTS/x:report ! mx:xspec-junit-report(.)"/>
               
               <xsl:call-template name="write-xml-file">
                  <xsl:with-param name="filename" select="resolve-uri($junit-to, ($collection-location ! replace(.,'([^/])$','$1/')) )"/>
                  <xsl:with-param name="payload" as="element()">
                     <testsuites name="XSpec report - times { count($junit-reports) }">
                        <xsl:call-template name="summary-attributes">
                           <xsl:with-param name="where" select="$junit-reports"/>
                        </xsl:call-template>
                        <xsl:for-each select="$junit-reports/testsuites">
                           <testsuite>
                              <xsl:copy-of select="@*"/>
                              <xsl:call-template name="summary-attributes"/>
                              <xsl:copy-of select="child::node()"/>
                           </testsuite>
                        </xsl:for-each>
                        <!-- each report needs to be processed standalone for the receiving XSLT - enabling threading? -->
                     </testsuites>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
            <xsl:message expand-text="true">WARNING: No JUnit report is written to '{ $junit-to }' - try a file name with suffix</xsl:message>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <!-- interrogates JUnit XML to summarize findings when wrapping -->
   <xsl:template name="summary-attributes">
      <xsl:param name="where" select="." as="node()*"/>
      <xsl:attribute name="tests" select="count($where/descendant::testcase)"/>
      <xsl:attribute name="skipped" select="count($where/descendant::testcase[@status='skipped'])"/>
      <xsl:attribute name="failures" select="count($where/descendant::testcase[@status='failed'])"/>
   </xsl:template>
   
   <xsl:template priority="101" match="RESULTS[not($reporting)]" mode="emit-reports"/>
   
   <xsl:template priority="99" match="RESULTS[$reporting-aggregate]" mode="emit-reports">
      <xsl:call-template name="write-html-file">
         <xsl:with-param name="filename" select="resolve-uri($report-to,$collection-location)"/>
         <!-- nb in this application, html is in no namespace -->
         <xsl:with-param name="payload" as="element(html)">
            <xsl:call-template name="html-report"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template priority="91" match="RESULTS" mode="emit-reports">
      <xsl:apply-templates mode="produce-html" select="*"/>
   </xsl:template>
   
   <xsl:template mode="produce-html" match="x:report">
      <xsl:variable name="xspec-basename" select="@xspec => replace('.*/', '') => replace('\.[^.]*$', '')"/>
      <xsl:variable name="html-filename" expand-text="true">{$report-to}/{$xspec-basename}.html</xsl:variable>
      <xsl:variable name="write-to" select="resolve-uri($html-filename, $collection-location)"/>

      <xsl:call-template name="write-html-file">
         <xsl:with-param name="filename" select="$write-to"/>
         <xsl:with-param name="payload" as="element(html)">
            <xsl:call-template name="html-report"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <xsl:template name="write-html-file">
      <xsl:param name="filename" as="xs:anyURI"/>
      <xsl:param name="payload" as="element(html)"/>
      <xsl:message expand-text="true">Writing report {$filename} ...</xsl:message>
      <xsl:result-document href="{$filename}" method="html" html-version="5.0" indent="yes">
         <xsl:sequence select="$payload"/>
      </xsl:result-document>
   </xsl:template>
   
   <xsl:template name="write-xml-file">
      <xsl:param name="filename" as="xs:anyURI"/>
      <xsl:param name="payload" as="element()"/>
      <xsl:message expand-text="true">Writing report {$filename} ...</xsl:message>
      <xsl:result-document href="{$filename}" method="xml" indent="yes">
         <xsl:sequence select="$payload"/>
      </xsl:result-document>
   </xsl:template>
   
   <xsl:function name="mx:compile-xspec-at-uri" as="document-node()?" cache="true">
      <xsl:param name="xspec-uri" as="xs:anyURI"/>
      <xsl:sequence select="doc($xspec-uri) => mx:compile-xspec()"/>
   </xsl:function>
   
   <xsl:function name="mx:transform-with" as="document-node()?" cache="true">
      <xsl:param name="source" as="document-node()"/>
      <xsl:param name="stylesheet-location" as="xs:anyURI"/>
      
      <xsl:variable name="runtime-params" as="map(xs:QName,item()*)">
         <xsl:map/>
      </xsl:variable>
      <xsl:variable name="runtime" as="map(xs:string, item())">
         <!-- call template t:main xmlns:t="http://www.jenitennison.com/xslt/xspec"-->
         <xsl:map>
            <xsl:map-entry key="'xslt-version'"        select="3.0"/>
            <xsl:map-entry key="'source-node'"         select="$source"/>
            <xsl:map-entry key="'stylesheet-location'" select="$stylesheet-location"/>
            <xsl:map-entry key="'stylesheet-params'"   select="$runtime-params"/>
         </xsl:map>
      </xsl:variable>
      <xsl:sequence select="transform($runtime)?output"/>
   </xsl:function>
 
   <!-- Accepts an XSpec document and throws it at the compiler -->
   <!-- todo: try/catch? what are the ways this can fail? -->
   <xsl:function name="mx:xspec-junit-report" as="document-node()?" cache="true">
      <xsl:param name="xspec-report" as="element(x:report)"/>
      
      <!--<xsl:variable name="xspec-report" as="document-node()">
         <xsl:document>
            <xsl:sequence select="$report"/>
         </xsl:document>
      </xsl:variable>-->
      <!--<xsl:param name="xspec-name" as="xs:anyURI"/>-->
      <xsl:variable name="runtime-params" as="map(xs:QName,item()*)">
         <xsl:map>
            <!--<xsl:map-entry key="QName('', 'xspec-home')" select="resolve-uri('./xspec/', static-base-uri())"/>-->
         </xsl:map>
      </xsl:variable>
      <xsl:variable name="runtime" as="map(xs:string, item())">
         <xsl:map>
            <xsl:map-entry key="'xslt-version'" select="3.0"/>
            <xsl:map-entry key="'source-node'" select="$xspec-report"/>
            <!--<xsl:map-entry key="'global-context-item'" select="doc($xspec-name)"/>-->
            <!-- uhoh - presumably this will have been cached?-->
            <xsl:map-entry key="'stylesheet-location'" select="$junit-reporter-xslt-path"/>
            <xsl:map-entry key="'stylesheet-params'" select="$runtime-params"/>
         </xsl:map>
      </xsl:variable>
      
      <!-- https://www.w3.org/TR/xpath-functions-31/#func-transform -->
      <xsl:sequence select="transform($runtime)?output"/>
   </xsl:function>

</xsl:stylesheet>
