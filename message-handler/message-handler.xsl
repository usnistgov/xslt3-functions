<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:x3f="http://csrc.nist.gov/ns/xslt3-functions"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:param name="x3f:returns_pi" as="xs:boolean" select="false()"/>

    <xsl:template name="x3f:message-handler">
        <xsl:param name="text" as="xs:string"/>
        <xsl:param name="message-type" as="xs:string?"/><!-- e.g., 'Error', 'Warning' -->
        <xsl:param name="error-code" as="xs:string?"/>
        <xsl:param name="terminate" as="xs:boolean" select="false()"/>
        <xsl:param name="returns_pi" as="xs:boolean" select="$x3f:returns_pi"/>
        <xsl:variable name="joined-string" as="xs:string"
            select="string-join(($message-type, $error-code, $text),': ')"/>
        <xsl:choose expand-text="yes">
            <xsl:when test="$returns_pi">
                <xsl:processing-instruction name="message-handler">{
                    if ($terminate) then 'Terminating ' else ''
                    }{
                    $joined-string
                    }</xsl:processing-instruction>
                <!-- Above, line break inside the text value template instead of outside it
                     prevents the output PI from including the line break. -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="{$terminate}">{$joined-string}</xsl:message>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>