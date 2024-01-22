<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:cs="http://nineml.com/ns/coffeesacks" extension-element-prefixes="cs"
   xmlns:x3f="http://csrc.nist.gov/ns/xslt3-functions"
   exclude-result-prefixes="#all" version="3.0">

   <!--
    
    CoffeeSacks demo XSLT
    Adapted from https://github.com/nineml/HOWTO/blob/main/saxon/style/dates.xsl
    

    
    
  -->

   <xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

   <xsl:param name="isoDateGrammarPath" as="xs:string">iso8601.ixml</xsl:param>

   <xsl:variable name="dateTime_parser" select="cs:load-grammar($isoDateGrammarPath)"/>

   <xsl:variable name="tests" xmlns="http://csrc.nist.gov/ns/xslt3-functions">
      <dateTime>1962-06-28</dateTime>
      <dateTime>1963-11-04</dateTime>
      <dateTime>2024-02-30</dateTime>
      <dateTime>2024-02-99</dateTime>
      <dateTime>2024-01-17T17:26:38.416457100-05:00</dateTime>
      <dateTime>2024-02-300</dateTime>
      <dateTime>2025-12-25 </dateTime>
      <dateTime>2025-12-31T</dateTime>
   </xsl:variable>

   <xsl:template match="/" name="xsl:initial-template">
      <x3f:TESTING>
         <xsl:apply-templates select="$tests/*"/>
      </x3f:TESTING>
   </xsl:template>

   <xsl:template match="x3f:dateTime">
      <x3f:test in="{ . }">
         <xsl:sequence select="x3f:date_or_bust(.)"/>
      </x3f:test>
   </xsl:template>

   <xsl:function name="x3f:date_or_bust" as="element()">
      <xsl:param name="maybeDateTime" as="item()"/>
      <xsl:try>
         <xsl:sequence select="$dateTime_parser(string($maybeDateTime))/*"/>
         <xsl:catch expand-text="true">
            <x3f:ERROR>BUST on '{ $maybeDateTime }'</x3f:ERROR>
         </xsl:catch>
      </xsl:try>
   </xsl:function>


</xsl:stylesheet>
