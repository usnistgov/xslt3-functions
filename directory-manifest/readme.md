# XSLT / XProc Directory Manifest

Writes descriptions of your folder's XML-based contents, dynamically.

Also provides examples of
  - XProc 1.0 polling the file system
  - XProc 1.0 delivering markup and Markdown outputs
  - XProc 1.0 wrapping a call to XProc 1.0 to encapsulate logic.
  - Simple XProc 3.0 delivering the same results

Run XProc providing the path to the subdirectory you want and it writes out a report.

For the main pipeline, output ports are defined for echoed input, HTML and Markdown formats - save any or all.

For convenience a small 'wrapper' pipeline is also available, hard-coded to produce Markdown (only) and write it to the file system, with a  simpler interface.

Additionally, and looking forward to eventual migration, an *XProc 3.0* version is provided. It is comparatively lightweight, combining the virtues of both the 1.0 variants - while at the same time, the XProc 3.0 variant will support the 1.0 architecture (which exposes more ports for reuse and debugging) with some easy extension.

Currently the utility attempts to read `xml`, `xsd`, `xsl`, `xslt`, `xpr`, `xsd` and `sch`, providing a lightweight but useful synopsis of file contents.

## Dependencies

The XProc 1.0 application has been tested on [XML Calabash](http://xmlcalabash.com), by Norman Walsh. As this software is well tested and distributed by Maven, we consider it the stable version - while we also do not expect the XProc 3.0 to change.

The XProc 3.0 application has been tested using [MorganaXProc-IIIse](http://xml-project.com) (version 1.1.3 atw) by Achim Berndzen.

As open-source Java applications either of these can be downloaded and run; or XML Calabash may be run under Maven without prior download and configuration (see below).

## Invocation

### XML Calabash in Java

`xproc-x3f-manifest.sh` - bash script invoking XML Calabash in Java: runs an XProc 1.0 pipeline to produce a directory manifest describing the current directory.

To configure, install [XML Calabash](http://xmlcalabash.com) and adjust the script as needed to resolve resources on your system.

Optionally, put the script's location on the system path or otherwise configure it to be available from other directories.

To use -

* Change directories to the folder you want polled and described
* Run the script (with an explicit path to locate it or a setting on your system path)
* Inspect the resulting `manifest.md` file

> $ ../path/to/xproc-x3f-manifest.sh

#### Details

A typical XML Calabash call might look like either:

The wrapper (simple interface) pipeline

> java -Xmx1024m -cp $CLASSPATH com.xmlcalabash.drivers.Main /path/to/make-markdown-manifest.xpl dir=$HEREPATH

The core pipieline with options set to the same effect:

> java -Xmx1024m -cp $CLASSPATH com.xmlcalabash.drivers.Main -omd=manifest.md -ohtml=manifest.html -odirlist=/dev/null /path/to/directory-manifest.xpl dir=$HEREPATH

In the core pipeline, `-o` flags indicating output ports for XML Calabash, defined in the pipeline:

- `md` - Markdown results
- `html` HTML results
- `dirlist` directory listing (for debugging)

Note these ports are *not exposed* by the wrapper pipeline, which hence needs no `-o` arguments.

Additionally

- `$CLASSPATH` includes the XML Calabash jar and a jar for logging as necessary
- `$HEREPATH` is a path (as file: URI) to directory to be polled

### Under Maven

This is simpler if you have Maven and don't wish to install or wire up for XML Calabash. Maven requires a JDK to run but encapsulates all the dependency management.

`mvn-x3f-manifest.sh` - bash shell script, produces a Markdown file `manifest.md` in the current directory

`mvn-x3f-manifest.bat` - Windows (Powershell) batch file, ditto

Inspect the scripts to see how the calls to Maven are constructed, including bindings for the XProc output ports noted.

## Morgana XProc

Install the application, adjust paths or scripts, and run the `directory-manifest3.xpl` pipeline.

We had to add a copy of SaxonHE to the classpath so the application could find it. This is a known bug and you may not encounter it.

## Architecture

The XProc pipeline `directory-manifest.xpl` executes three steps:

- Polls the provided directory path for file contents to produce a file name list
- Processes this poll through an XSLT filter, dispatching to each file of several known types
  - Each file is parsed, processed and filtered
  - An HTML file listing is emitted, with poll results
- This HTML report is passed through another XSLT filter to reduce it to Markdown (text-based) syntax

For any given subdirectory, a File Contents / Resource Manifest may be created by running this process and capturing the HTML or Markdown (final) results.

### Maintenance and extensibility

New capabilities in polling and reporting XML-based file types may be added by providing templates to the XSLT that implements the middle of these three processes: `directory-listing.xsl`. 

For an example, see the [manifest.md](manifest.md).

Interestingly, note that  [directory-manifest.xpl](directory-manifest.xpl) is unable to open and inspect itself run under XProc 1.0 / XML Calabash - while the same logic in [directory-manifest3.xpl](directory-manifest3.xpl) functions as expected in XProc 3.0 / Morgana.

### Further development

The application of course leverages XML's transparency in an XML processing context, but it also aims to be lightweight, producing Markdown (suitable for further editing) rather than a 'smarter' more highly structured output -- and not working very hard at inferencing either.

With some extension, the same approach could be used to produce metadata feeds or basically any directory-level metadata containing this info. Elaborations on the input side could take advantage of native documentation and literate-programming apparatus such as embedded XSD or XSLT documentation.
