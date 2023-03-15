<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns="http://www.w3.org/1999/xhtml"
  version="3.0" expand-text="true" exclude-result-prefixes="#all">
  
<!-- Reads directory on file system and writes out a manifest of its contents.
  For XSLTs and XProcs, lists file dependencies (echoes calls on xsl:import, xsl:include, document() function etc.)
  Produces simple HTML suitable for auto-conversion into markdown
  e.g., pipeline this with a markdown serializer to produce a file auto-manifest.md
  -->
  
<!-- Next: connect up into pipeline for production of md
     Run and refine (checking against Gitlab)
     
  -->
  
  
    
    <xsl:template match="/">
      <body>
        <xsl:apply-templates select="//c:file"/>
      </body>
    </xsl:template>
    
    <xsl:template match="c:file"/>
    
    <xsl:template match="c:file[ends-with(@name,'md')]"/>
    
    <xsl:template match="c:file[ends-with(@name,'xsl') or ends-with(@name,'xslt') or ends-with(@name,'xpl')]">
      <xsl:variable name="filepath"  select="string(@name)"/>
      <xsl:if test="matches($filepath, '(xml|xpl|sch|xsl|xslt)$')">
        <div>
          <h4>
            <xsl:value-of select="@name"/>
          </h4>
          <xsl:apply-templates select="document($filepath)/*" mode="report"/>
        </div>
      </xsl:if>
    </xsl:template>
    
    <xsl:template match="xsl:stylesheet | xsl:transform" mode="report">
      <xsl:variable name="templatecount" select="count(xsl:template)"/>
      <p>XSLT stylesheet version { @version } ({ $templatecount } { if ($templatecount eq 1) then 'template' else 'templates' })</p>
      <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="xsl:stylesheet/xsl:param" mode="report">
      <p>Runtime parameter <code>{ @name }</code> { @as/(' as ' || .) }</p>
      <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="comment()[matches(.,'^\s*(OSCAL|Purpose|Dependencies|Input|Output|Note|Limitations?):')]"  mode="report">
      <p>
        <xsl:value-of select="normalize-space(.)"/>
      </p>
    </xsl:template>
    
    <xsl:template match="xsl:include | xsl:import" mode="report">
      <p>Compile-time dependency ({ name() }) <code>{ @href }</code></p>
    </xsl:template>
    
    <!--<xsl:template match="xp:declare-step | xp:pipeline" mode="report">
                        <xsl:variable name="stepcount" select="count(.//xp:xslt | .//xp:identity)"/>
                        <p>XProc pipeline version { @version } ({ $stepcount } { if ($stepcount eq 1) then 'step' else 'steps' })</p>
                        <xsl:apply-templates mode="#current"/>
                    </xsl:template>
                    
                    <xsl:template match="xp:document" mode="report">
                        <p>Runtime dependency: <code>{ @href }</code></p>
                    </xsl:template>-->
    
    <xsl:template match="text()" mode="report"/>
    
  
  
</xsl:stylesheet>