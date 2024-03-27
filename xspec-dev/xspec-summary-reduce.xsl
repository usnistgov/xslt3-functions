<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   xpath-default-namespace="http://www.jenitennison.com/xslt/xspec"
   xmlns="http://www.jenitennison.com/xslt/xspec"
   exclude-result-prefixes="#all"
   expand-text="true"
   version="3.0">
   
   <!-- More could be done to optimize plain-text results
        in view of use cases under CI
   -->
   
   <xsl:template match="/*" priority="50">
      <xsl:copy>
         <xsl:text>&#xA;{ (1 to 14) ! ' ...' }&#xA;</xsl:text>
         <head>XSpec summary report: { mx:enumerate('XSpec',count(report)) }</head>
         <xsl:next-match/>
         <xsl:text>&#xA;{ (1 to 14) ! ' ...' }&#xA;</xsl:text>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="/REPORT-SUMMARY">
      <xsl:apply-templates/>
      <xsl:text>&#xA;&#xA;</xsl:text>
      <SYNOPSIS>SUCCESS - { mx:give-report-counts(.) } - NO FAILURES REPORTED</SYNOPSIS>
   </xsl:template>
   
   <xsl:template priority="20" match="/REPORT-SUMMARY[exists(descendant::fail)]">
      <xsl:apply-templates/>
      <xsl:text>&#xA;&#xA;</xsl:text>
      <SYNOPSIS>FAILURE - { mx:give-report-counts(.) } - { count(descendant::fail) } { mx:pluralize('failure',count(descendant::fail)) => upper-case() } REPORTED</SYNOPSIS>
   </xsl:template>
   
   <xsl:template match="report">
      <xsl:text>&#xA;</xsl:text>
      <report>{ xspec-file ! tokenize(.,'/')[last()] } testing { xslt-file ! tokenize(.,'/')[last()] }: { mx:enumerate('test',@test-count) }, { @pending-count} pending, { mx:enumerate('failure',count(fail)) }</report>
   </xsl:template>
   
   <xsl:function name="mx:give-report-counts" as="xs:string" expand-text="true">
      <xsl:param name="r" as="element(REPORT-SUMMARY)"/>
      <xsl:text> { mx:enumerate('report',count($r/report)) } with { mx:enumerate('test', sum($r/report/@test-count)) } ({ sum($r/report/@pending-count) } pending)</xsl:text>
   </xsl:function>
   
   <!-- mx:enumerate('elephant',1) returns '1 elephant'
        mx:enumerate('elephant',3) returns '3 elephants' -->
   <xsl:function name="mx:enumerate" as="xs:string" expand-text="true">
      <xsl:param name="nom" as="xs:string"/>
      <xsl:param name="c"   as="xs:double"/>
      <xsl:text>{ $c } { mx:pluralize($nom,$c) }</xsl:text>
   </xsl:function>
   
   <xsl:function name="mx:pluralize" as="xs:string">
      <xsl:param name="nom" as="xs:string"/>
      <xsl:param name="c"   as="xs:double"/>
      <xsl:apply-templates select="$nom" mode="pluralize">
         <xsl:with-param name="plural" as="xs:boolean" select="not($c = 1)"/>
      </xsl:apply-templates>
   </xsl:function>
   
   <xsl:template match="." mode="pluralize">
      <xsl:param name="plural" as="xs:boolean" select="false()"/>
      <xsl:text>{ . }{ 's'[$plural] }</xsl:text>
   </xsl:template>
   
</xsl:stylesheet>