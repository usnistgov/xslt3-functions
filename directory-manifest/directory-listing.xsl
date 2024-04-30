<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  version="3.0"
  exclude-result-prefixes="#all"
  expand-text="true">

  <!-- Purpose: Produce an HTML report from polling a set of XML files provided as a directory list -->
  <!-- Input: A c:directory document such as is delivered by XProc `p:directory-list` step -->
  <!-- Limitations: Built out only for common cases seen so far, YMMV -->
  <!-- Note: Logic is extensible to handle analysis/synopsis of any XML document type -->

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

  <xsl:template match="c:file[matches(@name, '\.(xml|xpl|xproc|xp1|xp3|sch|xsl|xslt|xsd|xspec)$')]">
    <xsl:variable name="filepath" select="parent::c:directory/@xml:base || string(@name)"/>
    <xsl:variable name="file-document">
      <xsl:try select="document($filepath,.)">
        <xsl:catch>
          <err:error>Failure reading file { @name } ::: [{ $err:code }] { $err:description }</err:error>
        </xsl:catch>
      </xsl:try>
    </xsl:variable>
    <div>
      <h3>{ @name }</h3>
      <!--<h5>path: { $filepath }:{ doc-available($filepath) } # { document($filepath,.)/*/name() }</h5>-->
      <xsl:apply-templates select="$file-document/*" mode="report"/>
    </div>
  </xsl:template>

  <!-- Any comments starting with a keyword indicated are picked up -->
  <xsl:template mode="report" match="comment()[matches(., '^\s*(Purpose|Dependenc(y|ies)|Input|Output|Note|Description|Steps?|Limitations?):')]">
    <p>
      <xsl:value-of select="normalize-space(.)"/>
    </p>
  </xsl:template>

  <xsl:template match="/err:error" mode="report" priority="1">
    <p>{ . }</p>
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
  </xsl:template>

  <xsl:template match="xsl:include | xsl:import" mode="report">
    <p>Compile-time dependency ({ name() }) <code>{ @href }</code></p>
  </xsl:template>

  <xsl:template match="p:declare-step | p:pipeline" mode="report" priority="1">
    <xsl:variable name="steps" select="child::* except (p:input | p:output | p:sink | p:serialization | p:option)"/>
    <xsl:variable name="stepcount" select="count($steps)"/>
    <p>XProc pipeline version { @version } ({ $stepcount } { if ($stepcount eq 1) then 'step' else 'steps' })</p>
    <xsl:for-each-group select="p:output" group-by="true()">
      <p>
        <xsl:text>Output { if (count(current-group()) eq 1) then 'port' else 'ports' } - </xsl:text>
        <xsl:for-each select="current-group()">
          <xsl:if test="position() gt 1">, </xsl:if>
          <code>{ @port }</code>
        </xsl:for-each>
      </p>
    </xsl:for-each-group>
    <xsl:for-each-group select="//p:store" group-by="true()">
      <p>
        <xsl:text>Stores - </xsl:text>
        <xsl:for-each select="current-group()">
          <xsl:if test="position() gt 1">, </xsl:if>
          <code>{ @href | p:with-option[@name='href']/@select }</code>
        </xsl:for-each>
      </p>
    </xsl:for-each-group>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="p:document | p:import | p:with-input[exists(@href)]" mode="report">
    <p>Reads from ({ name() }) - <code>{ @href }</code></p>
  </xsl:template>

  <xsl:template match="p:option" mode="report">
    <p>Runtime option <code>{ @name }</code> { @as/(' as ' || .) }</p>
  </xsl:template>
  
  
  <xsl:template match="xs:schema" mode="report" priority="1">
    <xsl:variable name="element-count" select="count(//xs:element)"/>
    <xsl:variable name="top-level-count" select="count(/*/xs:element)"/>
    <p>XML Schema Definition instance ({ $element-count } { if ($element-count eq 1) then 'element' else 'elements' }, { $top-level-count} at top level)</p>
    <!--<xsl:apply-templates mode="#current"/>-->
  </xsl:template>

  <xsl:template match="text()" mode="report"/>

  <xsl:template match="/*" mode="report" expand-text="true" priority="-0.1">
    <p>Document '{ name() }'{ if (namespace-uri(.)) then (' in namespace ' || namespace-uri(.)) else ', in no namespace'} ({ count(//*) } { if (empty(/*/*)) then ' element' else ' elements' })</p>
    <!--<xsl:apply-templates mode="#current"/>-->
    <!--<p>{ serialize(.) }</p>-->
  </xsl:template>
  
</xsl:stylesheet>
