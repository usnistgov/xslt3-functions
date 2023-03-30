<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns="http://www.w3.org/1999/xhtml" version="3.0" expand-text="true"
  exclude-result-prefixes="#all">


  <!-- Reads directory on file system and writes out a manifest of its contents.
  For XSLTs and XProcs, lists file dependencies (echoes calls on xsl:import, xsl:include, document() function etc.)
  Produces simple HTML suitable for auto-conversion into markdown
  e.g., pipeline this with a markdown serializer to produce a file auto-manifest.md
  -->

  <!-- Next: connect up into pipeline for production of md
     Run and refine (checking against Gitlab)
     
  -->

  <xsl:strip-space elements="*"/>
  
  <xsl:variable name="path" select="/c:directory/@xml:base"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>Directory Manifest: { $path }</title>
      </head>
      <body data-path="{$path}">
        <h1>Directory Manifest: <code>{ tokenize($path,'/')[last() - 1] }</code></h1>
        <p class="timestamp">{ current-dateTime() => format-dateTime('[MNn] [D0] [Y] [h0]:[m01] [P]') } - { current-dateTime() } -</p>
        <p>Listing files suffixed <code>xml</code>, <code>xpl</code>, <code>sch</code>, <code>xsl</code>, <code>xslt</code>, <code>xsd</code> or <code>xspec</code>.</p>
        <xsl:apply-templates select="//c:file">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <hr class="hr"/>
        <p>(end listing)</p>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="c:file"/>

  <xsl:template match="c:file[ends-with(@name, 'md')]"/>

  <xsl:template match="c:file[matches(@name, '\.(xml|xpl|sch|xsl|xslt|xsd|xspec)$')]">
    <xsl:variable name="filepath" select="parent::c:directory/@xml:base || string(@name)"/>
    <div>
      <h3>{ @name }</h3>
      <!--<h5>path: { $filepath }:{ doc-available($filepath) } # { document($filepath,.)/*/name() }</h5>-->
      <xsl:apply-templates select="document($filepath,.)/*" mode="report"/>
    </div>
  </xsl:template>

  <xsl:template match="xsl:stylesheet | xsl:transform" mode="report" priority="1">
    <xsl:variable name="templatecount" select="count(xsl:template)"/>
    <xsl:variable name="functioncount" select="count(xsl:function)"/>
    <p>XSLT stylesheet version { @version } ({ $templatecount } { if ($templatecount eq 1) then
      'template' else 'templates' }{ if ($functioncount eq 1) then
      ', 1 function' else $functioncount[. gt 0]!(', ' || . || ' functions') })</p>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="xsl:stylesheet/xsl:param" mode="report">
    <p>Stylesheet parameter <code>{ @name }</code> { @as/(' as ' || .) }</p>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template mode="report" match="comment()[matches(., '^\s*(Purpose|Dependencies|Input|Output|Note|Limitations?):')]">
    <p>
      <xsl:value-of select="normalize-space(.)"/>
    </p>
  </xsl:template>

  <xsl:template match="xsl:include | xsl:import" mode="report">
    <p>Compile-time dependency ({ name() }) <code>{ @href }</code></p>
  </xsl:template>

  <xsl:template match="p:declare-step | p:pipeline" mode="report" priority="1">
    <xsl:variable name="steps" select="child::* except (p:input | p:output | p:sink | p:serialization)"/>
    <xsl:variable name="stepcount" select="count($steps)"/>
    <p>XProc pipeline version { @version } ({ $stepcount } { if ($stepcount eq 1) then 'step' else 'steps' })</p>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="p:document | p:import" mode="report">
    <p>Runtime dependency ({ name() }): <code>{ @href }</code></p>
  </xsl:template>

  <xsl:template match="xs:schema" mode="report" priority="1" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:variable name="element-count" select="count(//xs:element)"/>
    <xsl:variable name="top-level-count" select="count(/*/xs:element)"/>
    <p>XML Schema Definition instance ({ $element-count } { if ($element-count eq 1) then 'element' else 'elements' }, { $top-level-count} at top level)</p>
    <!--<xsl:apply-templates mode="#current"/>-->
  </xsl:template>

  <xsl:template match="text()" mode="report"/>

  <xsl:template match="/*" mode="report" expand-text="true" priority="-0.1">
    <p>Document '{ name() }'{ if (namespace-uri(.)) then (' in namespace ' || namespace-uri(.)) else ', in no namespace'} ({ count(//*) } { if (empty(/*/*)) then ' element' else ' elements' })</p>
    <xsl:apply-templates mode="#current"/>
    <!--<p>{ serialize(.) }</p>-->
  </xsl:template>
  
</xsl:stylesheet>
