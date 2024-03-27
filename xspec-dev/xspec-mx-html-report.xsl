<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   xmlns:x="http://www.jenitennison.com/xslt/xspec"
   exclude-result-prefixes="#all"
   expand-text="true"
   version="3.0">


   <!-- Not used by XProc -->
   <xsl:output method="html" html-version="5"/>

   <!-- 'clean' is a b/w theme with good contrast
        other available themes are 'uswds', 'classic', and 'toybox'
        or add your own templates in mode 'theme-css' (see below) -->
   <xsl:param name="theme" as="xs:string">clean</xsl:param>
   
   <!-- implementing strip-space by hand since we don't want to lose ws when copying content through -->
   <xsl:template
      match="x:report/text() | x:scenario/text() | x:test/text() | x:call/text() | x:result/text() | x:expect/text() | x:context/text()"/>
   
   
   <!-- Some interesting things about this XSLT:
   
   About half of it is boilerplate CSS and Javascript for the receiving application
   There are templates matching strings, and functions calling templates
   Since attributes emit elements (not attributes, as more usually) they often don't come first inside their parents

   nb: note use of xpath-default-namespace, to be cleaned up in favor of x: prefix
   
   -->
   <xsl:template match="/" name="html-report">
      <xsl:variable name="report-count" select="descendant-or-self::x:report => count()"/>
      <xsl:variable name="result-count" select=".//x:test => count()"/>
      
      <html>
         <head>
            <!-- Paths start at . so as to support building a page for any context, not assuming a root node -->
            <title>XSpec - { $result-count } { if ($result-count eq 1) then 'test' else 'tests'} in { $report-count } { if ($report-count eq 1) then 'report' else 'reports'} </title>
            <xsl:call-template name="page-css"/>
            <xsl:call-template name="page-js"/>
         </head>
         <xsl:apply-templates select="." mode="dispatch"/>
      </html>
   </xsl:template>
   
   <xsl:template match="/" mode="dispatch">
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="/RESULTS" mode="dispatch">
      <xsl:call-template name="html-body"/>
   </xsl:template>
   
   <xsl:template match="x:report" mode="dispatch">
      <body class="{ $theme }">
         <xsl:call-template name="report-section"/>
      </body>
   </xsl:template>
      
   <xsl:template match="/*" name="html-body" priority="101">
      <body class="{ $theme }">
         <!-- Making a toc only for multiple reports -->
         <xsl:for-each-group select="x:report" group-by="true()">
            <ul class="directory">
               <xsl:for-each select="current-group()">
                  <li><a href="#report_{ count(.|preceding-sibling::x:report) }">XSpec Report - <code>{ @xspec }</code></a>
                     <xsl:for-each-group select="descendant::x:test[empty(@pending)][not(@successful='true')]" group-by="true()">
                    <ul>
                       <xsl:apply-templates select="." mode="toc"/>
                    </ul>
                  </xsl:for-each-group>
                  </li>
               </xsl:for-each>
            </ul>
         </xsl:for-each-group>
         <xsl:next-match/>
      </body>
   </xsl:template>
   
   <xsl:template priority="5" match="x:test" mode="toc">
      <li class="failing"><span class="label">FAILING</span>
         <xsl:text> </xsl:text>
         <a class="jump" onclick="javascript:viewSection('{mx:make-id(.)}')">{ ancestor-or-self::*/x:label => string-join(' - ') }</a>
      </li>
   </xsl:template>
   
   <xsl:template match="x:report" name="report-section">
      <section class="xspec-report" id="report_{ count(.|preceding-sibling::x:report)}">
         <div class="iconogram floater">
            <xsl:apply-templates mode="iconogram"/>
         </div>
         <h1>XSpec Report - <code>{ @xspec/replace(.,'.*/','') }</code></h1>
         <xsl:call-template name="make-report"/>
      </section>
   </xsl:template>
   
   <!--Make a details panel when there is more than one report -->
   <xsl:template match="x:report[exists(../x:report except .)]">
      <details open="open" class="xspec-report" id="report_{ count(.|preceding-sibling::x:report) }">
         <summary class=" { (.[descendant::x:test/@successful = 'false']/'failing','passing')[1]}">
            <span class="h1">XSpec Report - <code>{ @xspec/replace(.,'.*/','') }</code></span>
         </summary>
         <div class="iconogram floater">
            <xsl:apply-templates mode="iconogram"/>
         </div>
         <xsl:call-template name="make-report"/>
      </details>
   </xsl:template>
   
   <xsl:template name="make-report">
      <button onclick="javascript:expandSectionDetails(closest('section, details'))">Expand report</button>
      <button onclick="javascript:collapseSectionDetails(closest('section, details'))">Collapse</button>
      <xsl:apply-templates select="@*"/>
      <div class="summary">
         <xsl:apply-templates select="." mode="in-summary"/>
      </div>
      <hr class="hr"/>
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="text()" mode="iconogram"/>
   
   <xsl:template match="x:scenario" mode="iconogram">
      <xsl:variable name="in" select="ancestor-or-self::x:scenario"/>
      <xsl:variable name="oddness" select="('odd'[count($in) mod 2],'even')[1]"/>
      <div class="fence { $oddness }{ child::x:test[@successful != 'true']/' failing'}">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template priority="5" match="x:test" mode="iconogram">
      <a class="jump" onclick="javascript:viewSection('{mx:make-id(.)}')" title="{ ancestor-or-self::*/x:label => string-join(' - ') }">
         <xsl:apply-templates select="." mode="icon"/>
      </a>
   </xsl:template>
   
   <!-- icons indicating test results can also be overridden or themed -->
   <!-- crossed fingers -->
   <xsl:template priority="5" match="x:test[exists(@pending)]" mode="icon">&#129310;</xsl:template>
   
   <!-- thumbs up -->
   <xsl:template match="x:test[@successful='true']" mode="icon">&#128077;</xsl:template>
   
   <!-- thumbs down -->
   <xsl:template match="x:test" mode="icon">&#128078;</xsl:template>
   
   
   <!-- Generic handling for any attribute not otherwise handled -->
   <xsl:template match="@*">
      <p class="{local-name(.)}"><b class="pg">{ local-name(..) }/{ local-name(.) }</b>: <span class="pg">{ . }</span></p>
   </xsl:template>
   
   <xsl:template match="@id" priority="101"/>
   
   <xsl:template priority="20" match="x:report/@xspec | x:report/@stylesheet">
      <p class="{local-name(.)}"><b class="pg">{ local-name(..) }/{ local-name(.) }</b>: <a class="pg" href="{ . }">{ . }</a></p>
   </xsl:template>
   
   <xsl:template priority="20" match="x:report/@date">
      <p class="{local-name(.)}"><b class="pg">{ local-name(..) }/{ local-name(.) }</b>: { format-dateTime(xs:dateTime(.),'[MNn] [D1], [Y0001] [H01]:[m01]:[s01]') } (<code>{.}</code>)</p>
   </xsl:template>
   
   <xsl:template priority="20" match="x:test/@successful"/>
   
   
   <xsl:template match="x:scenario">
      <details class="{ (@pending/'pending',.[descendant::x:test/@successful = 'false']/'failing','passing')[1]}{ child::x:test[1]/' tested' }">
         <xsl:attribute name="id" select="mx:make-id(.)"/>
         <xsl:if test="descendant::x:test/@successful = 'false'">
            <xsl:attribute name="open">open</xsl:attribute>
         </xsl:if>
         <summary>
            <xsl:apply-templates select="." mode="in-summary"/>
         </summary>
         <div class="{ (child::x:scenario[1]/'scenario-results','test-results')[1] }">
           <xsl:apply-templates/>
         </div>
      </details>
   </xsl:template>
   
   
   <xsl:function name="mx:make-id" as="xs:string">
      <xsl:param name="whose"/>
      <xsl:text expand-text="true">{ $whose/ancestor::x:report ! ('report' || count(.|preceding-sibling::x:report || '-' )) }{ $whose/@id }</xsl:text>
   </xsl:function>
         
         
   <xsl:template match="x:scenario/x:label"/>
   
   <xsl:template match="x:report | x:scenario" mode="in-summary">
      <xsl:variable name="here" select="."/>
      <xsl:variable name="subtotal" select="exists(ancestor-or-self::x:report//x:test except descendant::test)"/>
      <xsl:variable name="all-passing" select="empty(descendant::x:test[not(@successful='true')])"/>
      <span class="label">{ self::x:report/'Total tests '}{ child::x:label }</span>
      <xsl:text>&#xA0;</xsl:text><!-- nbsp -->
      <xsl:apply-templates select="self::x:scenario/descendant::x:test" mode="icon"/>
      <span class="result">
      <xsl:iterate select="'passing', 'pending', 'failing','total'[not($subtotal)],'subtotal'[$subtotal]">
         
         <xsl:variable name="this-count">
            <xsl:apply-templates select="." mode="count-tests">
               <xsl:with-param name="where" select="$here"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:text> </xsl:text>
         <span class="{ . }{ ' zero'[$this-count='0']}{ .[.=('total','subtotal')] ! ' passing'[$all-passing]}">
            <b class="pg">{ . }</b>
            <xsl:text>: </xsl:text>
            <xsl:sequence select="$this-count"/>
         </span>
      </xsl:iterate>
      </span>
   </xsl:template>
   
   <xsl:template priority="20" match="x:scenario[exists(child::x:test)]" mode="in-summary">
      <xsl:variable name="here" select="."/>
      <span class="label">{ child::x:label }</span>
      <xsl:text>&#xA0;</xsl:text><!-- nbsp -->
      <xsl:apply-templates select="child::x:test" mode="icon"/>
      <xsl:apply-templates select="child::x:test" mode="#current"/>
      <span class="result { child::x:test/(@pending/'pending', @successful)[1] }">{ (child::x:test/@pending/('Pending ' || .),child::x:test[@successful='true']/'Passes','Fails')[1] }</span>
   </xsl:template>
   
   <xsl:template mode="in-summary" match="x:test">
      <xsl:text> </xsl:text>
      <span class="testing"> Expecting <span class="expecting">{ child::x:label }</span></span>
   </xsl:template>
   
   <xsl:template match="x:result">
      <div class="reported panel">
         <xsl:apply-templates select="." mode="header"/>
         <xsl:apply-templates select="@select"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="x:test">
      <div class="tested panel { if (@successful='true') then 'succeeds' else 'fails' }">
         <xsl:attribute name="id" select="mx:make-id(.)"/>
         
         <xsl:apply-templates select="." mode="header"/>
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="x:test" mode="header">
      <h3>Expecting (testing against)</h3>
   </xsl:template>
   
   <xsl:template match="x:result" mode="header">
      <h3>Producing (actual result)</h3>
   </xsl:template>
   
   <xsl:template match="*" mode="header"/>
   
   <xsl:template match="x:call | x:expect | x:context" priority="3">
         <xsl:apply-templates select="@*"/>
         <xsl:next-match/>
   </xsl:template>
   
   <xsl:template match="x:context[exists(*)]">
      <div class="codeblock { local-name() }" onclick="javascript:clipboardCopy(this);">
         <xsl:call-template name="write-xml"/>
      </div>
   </xsl:template>
   
   <xsl:template match="x:test/x:label" priority="5">
      <h5 class="label">
         <xsl:apply-templates/>
      </h5>
   </xsl:template>
   
   <!-- *** Following templates match in no namespace *** -->
   <xsl:template match="expect-test-wrap/text() | input-wrap/text()"/>
   
   <xsl:template match="input-wrap" mode="header" priority="3">
      <h3>From input</h3>
   </xsl:template>
   
   
   <xsl:template match="expect-test-wrap" mode="header" priority="3">
      <h4>Expecting</h4>
   </xsl:template>
   
   
   <xsl:template match="input-wrap" priority="3"/>
   
   <!-- should match content-wrap in no namespace -->
   <xsl:template match="content-wrap | expect-test-wrap" priority="3" >
      <div class="{ local-name(.) }{ parent::x:scenario/' panel' }">
         <xsl:apply-templates select="." mode="header"/>
         <xsl:next-match/>
         <!--<xsl:copy-of select="child::node()" exclude-result-prefixes="#all" copy-namespaces="false"/>-->
      </div>
   </xsl:template>
   
   <xsl:template match="content-wrap">
      <div class="codeblock { local-name() }" onclick="javascript:clipboardCopy(this);">
         <xsl:call-template name="write-xml"/>
      </div>
   </xsl:template>
   
<!-- *** Now some named templates *** -->
   
   <xsl:template name="write-xml">
      <xsl:sequence select="serialize(child::*, map {'indent': true()}) => replace('^\s+','')"/>
   </xsl:template>
   
  <!-- <xsl:template match="processing-instruction()">
      <xsl:text>&lt;?{ name() }{ string(.) }?></xsl:text>
   </xsl:template>-->
   
   <xsl:template name="page-css">
      <style type="text/css">
<xsl:text  xml:space="preserve" expand-text="false">

body { font-family: 'Calibri', 'Arial', 'Helvetica' }

ul.directory ul li { margin-top: 0.4em; padding: 0.2em; width: fit-content; font-size: 80% }

.floater { float: right; clear: both }

div.iconogram, div.fence { display: flex; border: thin solid grey; margin: 0.1em; padding: 0.1em; flex-wrap: wrap; height: fit-content }

div.iconogram { background-color: white }

div.fence { border: thin dotted grey }

div.fence.failing { border-style: solid }

div.summary { margin-top: 0.6em }

details { outline: thin solid black; padding: 0.4em }
details.tested { outline: thin dotted black }

summary { padding: 0.2em }
summary + * { margin-top: 0.4em }

.passing { background-color: white }
.failing { background-color: gainsboro }
.failing.zero { background-color: inherit } 
.failing .passing { background-color: white }

.summary-line { margin: 0.6em 0em; font-size: 110% }

.scenario-results { margin-top: 0.2em }
.scenario-results * { margin: 0em }
.scenario-results divx { outline: thin dotted black; padding: 0.2em }
.scenario-results div:first-child { margin-top: 0em }

span.h1 { display: inline-block; padding: 0.1em; font-size: 2em }

.test-results { margin-top: 0.6em; display: grid;
    overflow: hidden;
  grid-template-columns: 1fr 1fr;
  grid-auto-rows: 1fr;
  grid-column-gap: 1vw; grid-row-gap: 1vw }

.panel {  display: flex;
  flex-direction: column  }

.panel.tested { grid-column: 2 }

div.panel .codeblock { font-size: smaller }

.codeblock { width: 100%; box-sizing: border-box;
  outline: thin solid black; padding: 0.4em; background-color: white;
  overflow: auto; resize: both;
  font-family: 'Consolas', monospace;
  white-space: pre }

span.result { float: right; display: inline-block }
span.result span { padding: 0.2em; display: inline-block; outline: thin solid black }

.label { font-weight: bold; background-color: gainsboro; padding: 0.2em; max-width: fit-content; outline: thin solid black }
.pending .label { background-color: inherit; color: black; font-weight: normal; outline: thin solid black }

span.label { display: inline-block }

span.expecting { font-style: italic; font-weight: bold }

.iconogram a { text-decoration: none }

.total, .subtotal { background-color: white }

a.jump { cursor: pointer }

.codeblock:hover { cursor: copy }

</xsl:text>
         <xsl:apply-templates select="$theme" mode="theme-css"/>
      </style>
      
   </xsl:template>

   <!-- Mode theme-css produces CSS per theme, matching on the theme name, a string -->
   <!-- An importing XSLT can provide templates for whatever additional themes are wanted -->
   
   
<!-- Make a new template with new CSS to match a new $theme value, and you have a new theme to use -->
   
   <xsl:template mode="theme-css" priority="1" match=".[.='uswds']">
      <xsl:text xml:space="preserve" expand-text="false"><!-- colors borrowed from USWDS -->
.uswds {
   background-color: #f0f0f0;
   
  .label {    background-color: #1a4480; color: white}
  .pending .label { background-color: inherit; color: black }
  .passing { background-color: #d9e8f6 }
  .pending { background-color: white }
  .failing { background-color: #f8dfe2 }
  .failing .passing { background-color: #d9e8f6 }
  .pending.zero, .failing.zero { background-color: inherit } 
}
</xsl:text>
   </xsl:template>

   <xsl:template mode="theme-css" priority="1" match=".[.=('clean','simple')]"/>
   
   <xsl:template mode="theme-css" priority="1" match=".[.='classic']"><!-- 'classic' theme emulates JT's purple-and-green -->
      <xsl:text xml:space="preserve" expand-text="false">
.classic {
  h1, .h1, .label {   background-color: #606; color: #6f6 }
  h1 { padding: 0.2em }
  .pending .label { background-color: inherit; color: black }
  .passing { background-color: #cfc }
  .pending { background-color: #eee }
  .failing { background-color: #fcc }
  .failing .passing { background-color: #cfc }
  .pending.zero, .failing.zero { background-color: inherit } 
}
</xsl:text>
   </xsl:template>
   
   <xsl:template mode="theme-css" priority="1" match=".[.='toybox']">
      <xsl:text xml:space="preserve" expand-text="false">
.toybox {
   .label {   background-color: black; color: white }
   .failing .label { background-color: darkred }
   .passing .label { background-color: darkgreen }
   .pending .label { background-color: inherit; color: black }
   .passing { background-color: honeydew }
   .pending { background-color: cornsilk }
   .failing { background-color: mistyrose }
   .failing .passing { background-color: honeydew }
   .pending.zero, .failing.zero { background-color: inherit } 
}
</xsl:text>
   </xsl:template>
      
   <xsl:template mode="theme-css" match=".">
      <xsl:message>No template for theme '{ $theme }' - using 'simple'</xsl:message>
   </xsl:template>
   
   <!-- *** Back to page stuff / named templates ***-->
   
   <xsl:template name="page-js">
      <script type="text/javascript">
<xsl:text xml:space="preserve" expand-text="false">
const viewSection = eID => {
     let who = document.getElementById(eID); 
     let openers = getAncestorDetails(who);
     openers.forEach(o => { o.open = true; } );
     who.scrollIntoView( {behavior: 'smooth'} );
}

const getAncestorDetails = el => {
    let ancestors = [];
    while (el) {
      if (el.localName === 'details') { ancestors.unshift(el); }
      el = el.parentNode;
    }
    return ancestors;
}

const expandSectionDetails = inSection => {
    let sectionDetails = [... inSection.getElementsByTagName('details') ];
    sectionDetails.forEach(d => { d.open = true; } );
}
const collapseSectionDetails = inSection => {
    let sectionDetails = [... inSection.getElementsByTagName('details') ];
    sectionDetails.forEach(d => { d.open = false; } );
}

<!-- thanks to https://www.30secondsofcode.org/js/s/unescape-html/ -->
 
const unescapeHTML = str =>
  str.replace(
    /&amp;amp;|&amp;lt;|&amp;gt;|&amp;#39;|&amp;quot;/g,
    tag =>
      ({
        '&amp;amp;': '&amp;',
        '&amp;lt;': '&lt;',
        '&amp;gt;': '>',
        '&amp;#39;': "'",
        '&amp;quot;': '"'
      }[tag] || tag)
  );



const clipboardCopy = async (who) => {
      let cp = unescapeHTML(who.innerHTML);
      try { await navigator.clipboard.writeText(cp); }
      catch (err) { console.error('Failed to copy: ', err); }
    }

</xsl:text>
      </script>
   </xsl:template>

   <!-- Supporting mode 'count-tests' for 'in-summary' mode above -->
   <xsl:mode name="count-tests" on-no-match="fail"/>
   
   <!-- 'Visitor' pattern matches strings to dispatch processing -->
   <xsl:template mode="count-tests" match=".[.='passing']">
      <xsl:param name="where" as="element()"/>
      <xsl:sequence select="count($where/descendant::x:test[@successful='true'])"/>
   </xsl:template>
   
   <xsl:template mode="count-tests" match=".[.='pending']">
      <xsl:param name="where" as="element()"/>
      <xsl:sequence select="count($where/descendant::x:test[exists(@pending)])"/>
   </xsl:template>
   
   <xsl:template mode="count-tests" match=".[.='failing']">
      <xsl:param name="where" as="element()"/>
      <xsl:sequence select="count($where/descendant::x:test[@successful!='true'])"/>
   </xsl:template>
   
   <xsl:template mode="count-tests" match=".[.=('total','subtotal')]">
      <xsl:param name="where" as="element()"/>
      <xsl:sequence select="count($where/descendant::x:test)"/>
   </xsl:template>
   
</xsl:stylesheet>
