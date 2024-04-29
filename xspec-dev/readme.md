# XSpec Development

The initiative focuses on two kinds of assets:

- XProc and XSLT pipelines to orchestrate XSpec evaluation
- Scripts to initiate XProc pipelines

These should be either useful directly, or useful if copied and adjusted, i.e. as templates.

Additionally, this project has new functionality for XSpec provided by an updated **XSpec Report HTML** transformation.

## Project rationale

The logical 'layer' provided sits on on top of the XSpec distribution cleanly, as a way of achieving local goals for unit testing applications at scale, under a set of portable runtimes *accessible to non-experts* in the XML/XSLT stack, while also capitalizing on XSpec.

That is, we need to run XSpec, both at a micro level supporting XSLT developers, but also under CI/CD (continuous integration/continuous deployment) in the hands of developers who need the services of tools (including such tools as are offered in this repository) without the wish or capability to develop or run XSLT and XSpec. A common scenario we envision is that XSLT is being used within application stacks that must be tested and monitored (for conformance and against regressions) by quality and release engineers with only basic debugging skills. XSpec, provided with suitable support, is excellent for this purpose.

XSpec in its current form *nearly* meets this need on its own, but it also has other integration needs as well as priorities. In case anything here may be useful more broadly, the option of migrating code back up to the 'mother project' is being kept open.

Requirements in summary:

- Run interactively and under CI/CD
- For both individual XSpecs and sets
- Works as a 'black box' from the command line with familiar tooling
- Scriptable, with example scripts to copy, clone or emulate
- XML plumbing follows standards and is accessible for study and adaptation

#### Features

- Runs well under either CI/CD or from CL (command line)
- Very configurable
- Seemingly pretty fast
- Portable and easy to set up and run (only Maven and `bash` are really needed)
- Runs unencumbered by licensing (all open-source software)

#### Known limitations:

- Doesn't (yet) do XQuery or Schematron XSpec
- New presentation stylesheet is still in development

## How to use

You need:

- [Apache Maven](https://maven.apache.org/) with a JDK
  - Enables running XML and XSLT tools (Saxon, XML Calabash) without installation
  - Drop-in configuration also requires no Maven expertise
- `bash` command line to run scripts (tested under Ubuntu)
- [GNU `make`](https://www.gnu.org/software/make/manual/make.html) to run 'make' scripted routines (if wanted)

To get started:

- Try any script, with a `--help` option
- Try `make help`
- Inspect readme docs and resources
  - XProc 1.0 for XML processing pipelines / process orchestration
  - XSLT 3.0 for transformations (and pipelines)
  - XSpec for unit and functional tests of transformations
- Write your own XSpec testing your own transformation
- Run it using an available or adapted script
- Configure CI/CD to run it when a PR is created or modified

## Installing `xspec` submodule

After cloning the project, to install the XSpec submodule be sure and run

```
> git submodule update --init --recursive
```

## XML Processing Pipelines

The pipelines in this project depend on prior art in the XSpec repository. Pipelines are currently implemented using XProc 1.0 to be run under XML Calabash, or in pure XSLT 3.0 to be run under Saxon.

[XML Calabash home page](https://xmlcalabash.com/)
[Saxon home page](https://www.saxonica.com/products/products.xml)

XProc 3.0 is planned for a later date.

Five pipelines are provided at the top level. All have dependencies on XSpec [in the XSpec distribution included as a repo submodule](../lib/xspec/src/harnesses/). Rather than forking from XSpec, the aim is eventually to offer these capabilities or derivates from them back into the main project.

Three pipelines rely on XProc 1.0 / XML Calabash (running Saxon internally):

- xspec-single-report.xp1
- xspec-single-xspec-repo-report.xp1
- xspec-batch-report.xp1

Two of these rely on Saxon / XSLT 3.0 only:
- XSPEC-SINGLE.xsl
- XSPEC-BATCH.xsl

A `testing` directory also shows a model pipeline, designed to be copied and modified to deliver functionality (calls on configurable sets of XSpec instances) in a development folder or branch:

- testing/xspec-test-batch.xp1

Additionally, scripts in the directories show how runtime calls of these processors can be instrumented and run, using Apache Maven to manage libraries.

These scripts can be copied and adapted for other scenarios and runtimes, or used as models for scripts on other platforms. The XProc and XSLT should also be conformant with the relevant (standard) specifications, apart from library dependencies.

### Details

`xspec-single-report.xp1` - processes an XSPec input file by applying XSpec execution using the XSpec XProc test harness, then processing its native report to make an HTML page using a *new* presentation stylesheet.

*Limitation*: At present, the presentation stylesheet meets these goals with respect to XSpec testing XSLT - not (yet) testing XQuery, Schematron or other runtimes to which XSpec might be applied.

`xspec-batch-report.xp1` - provides the same set of operations, except instead of a single XSpec (file instance), it can accept any number of XSpec files designated as inputs (either wired in or via XProc port bindings). Results from these tests are *aggregated* into a single report.

This pipeline also demonstrates how reports can be further processed to provide other outputs such as XML summaries (for batches) and simple plain-text summaries.

Additionally, another XProc is included for future diagnostics:

`xspec-single-xspec-repo-report.xp1` - calls the XSpec project XProc (pipeline), delivering an HTML file using the 'regular' XSLT in the XSpec distribution. *Note*: YMMV especially as it regards CSS setup in HTML file results.

This pipeline is essentially a minimal, functionally standalone wrapper around XSpec-native capabilities, made to expose the 'pain points' in using the current resources (which were originally authored and tested over ten years ago). For good results using XProc 1.0 under XML Calabash (itself no longer cutting-edge technology), certain modifications must be made in the XSpec repository libraries:

* Serialization needs to use latest (HTML5) serialization options to deal with character handling, rather than the current 'double reverse' character escaping of markup characters into [the Unicode Private Use Areas (PUA)](https://en.wikipedia.org/wiki/Private_Use_Areas) -- thus effectively requiring a character mapping back, which is not well supported under XProc 1.0.
* CSS handling/deployment needs to be improved or exposed such that generated HTML files have their CSS available.

## 'testing' directory resources

The `testing` directory contains a number of small self-contained XSpecs convenient for testing, along with the small XSLT stylesheets that they test.

### How to batch XSpec - a 'mini' demo

Additionally, `testing` contains an [XProc example](testing/xspec-test-batch.xp1) of how to use the batch pipelining XSpec in your project. This is a useful way of configuring and running a set of XSpecs assuming a listing can be given (i.e. it does not query the file system dynamically). Along with this is a [script for calling it](testing/mvn-xproc-xspec-test-batch.sh) - copy and edit these two resources together to have an entire self-contained runtime.

The advantage of such a 'wrapper' XProc is that it can encapsulate logic for an even simpler interface or runtime for the specific use case (whether running from the command line, under CI/CD, in an IDE etc). Both the batch (the XSpecs to be run) and what to do with the test results can thus be hard-wired, or provided with customized interface controls, depending on your needs.

The ['test batch' XProc](testing/xspec-test-batch.xp1) in this folder can be copied anywhere and adjusted per case, restoring its import link, pointing it to local XSpec file sources, and setting up ports or `p:store` (file save) options as wanted. It then runs in place to execute, as a set, all the XSpecs it points to.

Summary: how to use -

- Copy the XPL (and batch script if wanted) to a convenient location
- Rename and comment both of these for local use, rewiring their configuration, comments, and help messaging according to your design
- In editing the XProc, consider adding or removing any ports or whether to expose output ports vs write file outputs (`p:store`)
- Run the XProc standalone using the script or otherwise

## Scripts calling XProc

The `bash` scriot [mvn-xproc-xspec-html.sh](mvn-xproc-xspec-html.sh) shows how a script can invoke XML Calabash to execute one of these pipelines.

How a particular XProc is used depends on the ports defined in the XProc. XML Calabash provides syntax and interfaces for those ports. Accordingly, a script or command-line invocation typically has to set one or more of the following, for these XProcs:

- input port `xspec` is where XSpec inputs are configured - these must be files accessible on the system
- output port `xspec-report` or `xspec-results`, if any, shows XSpec runtime outputs, with no further processing, as a single (XML) report
- output port `html-report` shows the results, rendered in HTML for viewing in a web browser
- output `summary` shows the XML report reduced to a simple summary form
- output `determination` shows a plain text result for the entire run,with the summary results

Additionally, a runtime option `theme` supports changing the HTML page rendition settings (CSS), including its color palette, as described below.

## XProc alone

A script can be nice for repeated use, but for testing / one-time use, the same commands or their equivalents can be used to run the pipelines directly in XML Calabash, binding the input XSpecs to the `xspec` input port. Assuming `xml-calabash.sh` executes XML Calabash, this syntax will serve to combine execution of `testing_1.xspec` and `testing_2.xspec` into a single runtime:

```bash
./xml-calabash.sh path/to/xspec-batch.xp1 -ixspec=testing_1.xspec -ixspec=testing_2.xspec -oxspec-report=/dev/null -ohtml-report=/dev/null -osummary=/dev/null
```

Since the port `determination` is unnamed, its outputs are echoed to the console. Bindings to `dev/null` have the effect of silencing the other output ports. (They might otherwise be directed to file outputs for inspection.)

See XML Calabash docs for more info on its flags and switches.

## Scripts calling Saxon

Two more `bash` scripts, [mvn-saxon-xspec-batch.sh](mvn-saxon-xspec-batch.sh) and [mvn-saxon-xspec-batch.sh](mvn-saxon-xspec-batch.sh), show how XSpec may be invoked using XSLT only to produce an HTML report for a single XSpec, or a batched report (to console and/or to a result report file or file set) from running sets of XSpec files selected dynamically.

Running Saxon directly has the advantage of exposing a configurability surface allowing the binding of extension functionality into Saxon (via naming an initialization class). This feature permits the execution not only of XSpec, but of XSpec that tests extended functionility in XSLT stylesheets, notably including extension functionality supporting [Invisible XML]()

Use these as follows:

```bash
./mvn-saxon-xspec-html.sh special-testing.xspec
```

In a directory named `xspec`, creates a report file `special-testing.html` in HTML format.

```
./mvn-saxon-xspec-batch.sh folder=src/project report-to=project-report.html
```

In folder `src/project` relative to the repository root, this creates a single HTML report file aggregating runtime results from compiling and executing all XSpecs in that folder.

Other arguments can provide for:

- glob-matching file names for precise selection
- one report per XSpec file instead of a single aggregated report
- processing recursively over folders and subfolders (aggregating all results)
- stopping on parse or processing errors
- or no HTML reports, just console messages showing results
- JUnit XML report production suitable for CI/CD integration

See inline comments in XSLT [XSPEC-BATCH.xsl](XSPEC-BATCH.xsl) for details.

Hint: these scripts can be 'noisy' because they return progress reports. Runtime messages can be silenced by redirecting STDERR outputs, for example using by `2>/dev/null` in the command invoking the script.

```
./mvn-saxon-xspec-batch.sh folder=src/project recurse=yes 2>/dev/null
```

All XSpec files in the folder `src/project` and any subfolders, reporting results to the console (STDOUT) but not creating HTML reports and not echoing warning or error messages to the console.

It is best to silence STDERR only after you are confident that all XSpecs in your file set can be run successfully, especially if the "break early on error" option is set (since you will neither see STDERR nor get any results).

## Enhanced HTML Production

In order to work around limitations in the current XSpec HTML production (details with respect to its deployment under XProc 1.0), a [new HTML production XSLT](xspec-mx-html-report.xsl) is provided here, for use either for standalone XSpec reporting, or for reporting results from several XSpecs in aggregate ("batch").

[This XSLT ](xspec-mx-html-report.xsl) produces standalone HTML including embedded CSS and some lightweight Javascript supporting navigation features.

### Theming HTML from XProc

The XProc files support a runtime option, `theme`, which also exposes control of the theme setting (in the HTML and CSS). This takes the form of an HTML `class` value on the `body` element, along with CSS to be applied to the page on the basis of that setting.

- `theme=clean` (the default) produces a medium-contrast color-neutral format
- `theme=uswds` uses colors for emphasis from the USWDS color scheme
- `theme=classic` uses colors drawn from the good-old XSpec HTML
- `theme=toybox` provides a more extravagant scheme.

New themes can be added in the XSLT or in a new "shell" XSLT importing it, by copying and modifying an appropriate template to match the new theme and give it style. Such an importing XSLT can also modify any other feature of the HTML page result.

