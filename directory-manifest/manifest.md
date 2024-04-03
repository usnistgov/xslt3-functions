

# Directory Manifest: `directory-manifest`

April 3 2024 4:34 p.m. - 2024-04-03T16:34:19.5578974-04:00 -

Listing files suffixed `xml`, `xpl`, `sch`, `xsl`, `xslt`, `xsd` or `xspec`.

### directory-listing.xsl

XSLT stylesheet version 3.0 (15 templates)

Purpose: Produce an HTML report from polling a set of XML files provided as a directory list

Input: A c:directory document such as is delivered by XProc `p:directory-list` step

Limitations: Built out only for common cases seen so far, YMMV

Note: Logic is extensible to handle analysis/synopsis of any XML document type

### directory-manifest.xpl

Document 'c:directory' in namespace http://www.w3.org/ns/xproc-step (14 elements)

### html-to-markdown.xsl

XSLT stylesheet version 3.0 (20 templates)

Purpose: Cast HTML into Markdown notation

Input: More or less any HTML in the XHTML namespace

Output: A block of Markdown, to be serialized using the 'text' method

Note: Aims for Github Markdown more or less, but subject to adjustment, adaptation and extension

### make-markdown-manifest.xpl

XProc pipeline version 1.0 (3 steps)

Stores - `$path || '/manifest.md'`

Purpose: Produce a directory manifest in Markdown, called `manifest.md`

Description: This is a wrapper XProc around 'directory-manifest.xpl' hiding its ports and writing to (named) file output

Output: a Markdown file 'manifest.md' in the current directory

Runtime option `path` 

Reads from (p:import) - `directory-manifest.xpl`

### make-markdown-manifest3.xpl

XProc pipeline version 3.0 (4 steps)

Stores - `manifest.md`

Purpose: Same as make-markdown-manifest.xpl, except using XProc 3.0

Runtime option `path` 

Reads from (p:with-input) - `directory-listing.xsl`

Reads from (p:with-input) - `html-to-markdown.xsl`

### markdown-from-html.xspec

Document 'x:description' in namespace http://www.jenitennison.com/xslt/xspec (29 elements)

### pom.xml

Document 'project', in no namespace (35 elements)

-----


(end listing)