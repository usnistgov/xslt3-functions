# XSLT / XProc Directory Manifest

Writes descriptions of your folder's XML-based contents, dynamically.

Run the XProc providing the path to the subdirectory you want and it writes out a report.

Output ports are defined for HTML and Markdown formats - save either one or both.

Currently the utility attempts to read `xml`, `xsd`, `xsl`, `xslt`, `xpr`, `xsd` and `sch`, providing a lightweight but useful synopsis of file contents.

## Dependencies

The application depends on [XML Calabash](http://xmlcalabash.com), by Norman Walsh.

As a Java application it can be downloaded and run, or run under Maven without prior download and configuration (see below).

## Invocation

### XML Calabash in Java

`xproc-x3f-manifest.sh` - bash script invoking XML Calabash in Java: runs an XProc 1.0 pipeline to produce a directory manifest describing the current directory.

To use -

* Change directories to the folder you want polled and described
* Run the script (with an explicit path to locate it or a setting on your system PATH)
* Inspect the resulting `manifest.md` file

> $ ../path/to/xproc-x3f-manifest.sh

### Under Maven

This is simpler if you have Maven and don't wish to install or wire up for XML Calabash. Maven requires a JDK to run but encapsulates all the dependency management.

`mvn-x3f-manifest.sh` - bash shell script

`mvn-x3f-manifest.bat` - Windows (Powershell) batch file

## Maintenance and extensibility

The XProc pipeline `directory-manifest.xpl` executes three steps:

- Polls the provided directory path for file contents (file name list)
- Processes this poll through a filter, dispatching to each file of several known types
  - Each file is parsed, processed and filtered
  - An HTML file listing is emitted
- The HTML report is passed through a Markdown filter to reduce it to Markdown (text-based) syntax

For any given subdirectory, a File Contents / Resource Manifest may be created by running this process and capturing the HTML or Markdown (final) results.

New capabilities in polling and reporting XML-based file types may be added by providing templates to the XSLT that implements the middle of these three processes: `directory-listing.xsl`. 

For more info, see the [manifest.md](manifest.md).

Interestingly, note that  [directory-manifest.xpl](directory-manifest.xpl) is unable to open and inspect itself.
