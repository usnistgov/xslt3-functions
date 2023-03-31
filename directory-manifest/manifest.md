

# Directory Manifest: `directory-manifest`

March 31 2023 12:11 p.m. - 2023-03-31T12:11:19.227454-04:00 -

Listing files suffixed `xml`, `xpl`, `sch`, `xsl`, `xslt`, `xsd` or `xspec`.

### directory-listing.xsl

XSLT stylesheet version 3.0 (14 templates)

Purpose: Produce an HTML report from polling a set of XML files provided as a directory list

Input: A c:directory document such as is delivered by XProc `p:directory-list` step

Limitations: Built out only for common cases seen so far, YMMV

Note: Logic is extensible to handle analysis/synopsis of any XML document type

### directory-manifest.xpl

XProc pipeline version 1.0 (3 steps)

Output ports - `dirlist`, `html`, `md`

Purpose: Provide a pipeline with ports exposed for debugging generating HTML and Markdown from a set of XML files being polled

Steps: retrieves a directory listing; feeds it to an XSLT producing HTML; feeds this result to a Markdown generator

Output: Markdown suitable for placing into a README or other folder-level documentation

Runtime option `path` 

Reads from (p:document) - `directory-listing.xsl`

Reads from (p:document) - `html-to-markdown.xsl`

### html-to-markdown.xsl

XSLT stylesheet version 3.0 (19 templates)

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

### pom.xml

Document 'project', in no namespace (35 elements)

-----


(end listing)