<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   exclude-result-prefixes="math"
   xpath-default-namespace="http://www.jenitennison.com/xslt/xspec"
   xmlns="http://www.jenitennison.com/xslt/xspec"
   expand-text="true"
   version="3.0">
   
  <!-- Accepts as input either an `x:report` document or any document collecting x:report elements
      produces a REPORT-SUMMARY in no namespace
      process these results with xspec-summary-reduce.xsl to produce plain text -->
   
   <!--<RESULTS><report xmlns="http://www.jenitennison.com/xslt/xspec"
          xspec="....xspec" stylesheet="....xsl" date="2023-12-08T15:55:17.79518-05:00">-->
      
      <xsl:template match="/*">
         <xsl:variable name="reports" select="self::report | child::report"/>
         
         <REPORT-SUMMARY report-count="{count($reports)}">
            <xsl:if test="exists($reports[2])">
               <xsl:attribute name="from" select="min($reports/(@date ! xs:dateTime(.)))"/>
               <xsl:attribute name="t0" select="max($reports/(@date ! xs:dateTime(.)))"/>
            </xsl:if>
            <xsl:apply-templates select="$reports" mode="report-report"/>
         </REPORT-SUMMARY>
      </xsl:template>
   
   <!-- nb: so far we assume all XSpec to be XSLT
      - tbd is expanding this logic to cover Schematron, XQuery or what have you
        this will not be difficult once we have examples / (tests) -->
   <xsl:template match="report" mode="report-report">
      <report date="{ @date }" test-count="{ count(descendant::test) }" pending-count="{ count(descendant::test[matches(@pending,'\S')]) }">
         <xspec-file>{ @xspec }</xspec-file>
         <xslt-file>{ @stylesheet }</xslt-file>
         <xsl:apply-templates/>
      </report>
   </xsl:template>
   
   <xsl:template match="test[@successful='false']">
      <fail id="{@id}">{ ancestor-or-self::*/child::label => string-join(' : ') }</fail>
   </xsl:template>
   
   <xsl:template match="text()"/>
   
</xsl:stylesheet>