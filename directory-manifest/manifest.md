

# Directory Manifest: `directory-manifest`

April 30 2024 5:10 p.m. - 2024-04-30T17:10:56.132367-04:00 -

Listing files suffixed `xml`, `xpl`, `sch`, `xsl`, `xslt`, `xsd` or `xspec`.

### directory-listing.xsl

XSLT stylesheet version 3.0 (15 templates)

Purpose: Produce an HTML report from polling a set of XML files provided as a directory list

Input: A c:directory document such as is delivered by XProc `p:directory-list` step

Limitations: Built out only for common cases seen so far, YMMV

Note: Logic is extensible to handle analysis/synopsis of any XML document type

### directory-manifest.xproc

Document 'c:directory' in namespace http://www.w3.org/ns/xproc-step (13 elements)

### html-to-markdown.xsl

XSLT stylesheet version 3.0 (20 templates)

Purpose: Cast HTML into Markdown notation

Input: More or less any HTML in the XHTML namespace

Output: A block of Markdown, to be serialized using the 'text' method

Note: Aims for Github Markdown more or less, but subject to adjustment, adaptation and extension

### make-markdown-manifest.xproc

XProc pipeline version 1.0 (3 steps)

Stores - `$path || '/manifest.md'`

Purpose: Produce a directory manifest in Markdown, called `manifest.md`

Description: This is a wrapper XProc around 'directory-manifest.xproc' hiding its ports and writing to (named) file output

Output: a Markdown file 'manifest.md' in the current directory

Runtime option `path` 

Reads from (p:import) - `directory-manifest.xproc`

### make-markdown-manifest3.xpl

XProc pipeline version 3.0 (4 steps)

Stores - `manifest.md`

Purpose: Same as make-markdown-manifest.xproc, except using XProc 3.0

Runtime option `path` 

Reads from (p:with-input) - `directory-listing.xsl`

Reads from (p:with-input) - `html-to-markdown.xsl`

### markdown-from-html.xspec

Document 'x:description' in namespace http://www.jenitennison.com/xslt/xspec (29 elements)

### pom.xml

Document 'project', in no namespace (35 elements)

-----


(end listing)