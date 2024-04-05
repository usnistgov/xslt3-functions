# NIST/ITL/CSD XSLT3 Functions

Courtesy of NIST ITL/CSD (Information Technology Laboratory, Computer Security Division), a library of general-use XSLT functions.

Tested and available for XSLT 3.0 and potentially related languages.

## Software description

This repository offers a library of XSLT stylesheets and pipelines supporting generalized operations such as producing random UUIDs, comparing custom datatypes, validating against (dynamic or static) constraints, or other potential uses to be developed.

It is motivated primarily by the need to make available to the community and public logic that we have coded for use in our projects, but that could (more or less easily) be refitted to uses elsewhere.

The development model for the repository is to aim for a state of punctuated equilibrium, in which a stable code base remains unchanged functionally even while supporting ongoing development and innovation. Each project in this repository should be maintained and documented independently, with its own readme and testing documents. Thus the place to start with any project is the project itself.

At the same time, the different projects will, over the long term, be able to borrow logic from one another to support testing, unit testing, and runtime interfaces supporting broader distribution.

To use these transformations a conformant XSLT 3.0 transformation engine is required such as [Saxon 12](https://saxonica.com/documentation12/documentation.xml) from Saxonica (see [Github](https://github.com/Saxonica/Saxon-HE/) or [Maven](https://central.sonatype.com/artifact/net.sf.saxon/Saxon-HE?smo=true) for the free-to-use HE version), which is available on several platforms and sometimes bundled with commercial software. Outside that practical requirement, this library is free to use and open for contributions.

###  Project purpose and maturity

Some of this code originates with the [OSCAL project](https://pages.nist.gov/OSCAL), which has published XSLT since 2018. Over this time it has grown in complexity and refactored into several supporting repositories, including this one.

Future development of this resource depends largely on uptake and engagement from users who find it valuable. If you have an interest in keeping this code base viable, please make your needs and ideas known to the developers. Demonstrations that take us further into features of XSLT 3 that are demonstrably useful, whether in functionality or architecture (e.g., packaging), are particularly welcome.

See the readme in each project to gauge its scope of application, approach to design, and level of testing. Several of the applications are also accompanied by test suites using the [XSpec XSLT Unit Testing framework](https://github.com/xspec/xspec/).

##  Repository contents

See the subdirectory list for projects and applications currently supported.

Additionally to the project folders are resources at the top level:


- `.github` - for Github CI/CD
- `common` - holds common `bash` scripting - utilities for reuse
- `lib` - contains submodules, dynamic resources and libraries (or scripts for downloading them)

## Running and building on applications

As a 4GL, XSLT is well suited for certain types of applications, as it is hoped this site demonstrates. The resources offered here can be used and adapted for many different platforms and runtimes. While an effort has been made to create no dependendencies on tooling that is costly, encumbering in any way, or hard to acquire, at the same time the applications and interfaces offered and described here should not be considered to be normative or necessary, but as examples for evaluation only.

## `make` support

This repository supports command-line access to its tools via `make`, configured in each folder (when supported) by a `Makefile` configuration.

From any directory, `make --help` from a `bash` command line will show scripted logic for that directory, if any is available.

Make tasks with certain target designations can be run under CI/CD - tbd

## CI/CD

Currently CI/CD is set to use an XProc configuration that runs all available XSpec instances.

It can be run locally on any platform with a configured Maven installation, using the `test` target:

> mvn test

Scripts for more granular or targeted application of XSpec under CI/CD are also available in the [XSpec-dev](xspec-dev/) application, requiring `bash` and `make`.

### Rights and license

See the [LICENSE.md](LICENSE.md) file. As work product of a Bureau of the Department of Commerce (U.S. Government), or of volunteers working in support of our projects, code in this repository is in the public domain unless specifically marked otherwise.

To confirm the currency of the license, see the NIST Open license page at https://www.nist.gov/open/license#software.

###  Installation and use

#### Notes on using this library

If you are using this library, you should probably be able to skip the next subsection. Presumably you are developing XSLT of your own and wish to embed these capabilities (or extend them), not simply apply them for the purpose of capturing outputs.

#### Notes on running and testing XSLT

Generally speaking these are XSLT applications, either single transformations, stacked transformations (in which imported layers provide fallbacks and importing layers, customizations), or pipelines of transformations, requiring XSLT versions as recent as [XSLT Version 3.0](https://www.w3.org/XML/Group/qtspecs/specifications/xslt-30/html/) with [XPath Version 3.1](https://www.w3.org/TR/xpath-31/).

As such they will run on any platform supporting this industry-standard, publicly available and externally specified language. The leading open-source XSLT implementation currently is Saxon from [Saxonica](https://saxonica.com/welcome/welcome.xml), available for several platforms and frequently bundled with XML editors or IDE software. However, we also welcome reports respecting other XSLT implementations supporting the appropriate XSLT version (generally 3.0).

See each project for details on its runtime requirements. Most often, single and stacked XSLTs can be executed using simple calls from a command prompt, or easily configured within tools. Pipelines may be implemented in XSLT 3.0, or may be supported via [XProc](https://xproc.org/), or both.

## Contact information

Principal software engineers responsible for these projects are

- Wendell Piez, w e n d e l l (dot) p i e z (at) n i s t (dot) g o v
- David Waltermire, d a v i d (dot) w a l t e r m i r e (at) n i s t (dot) g o v

In the case of applications with significant contributions from community members there may be further contact information in the project `readme`.

(Note however that not all contributions are credited in documentation or provided with contact info. We eagerly welcome valuable community contributions even anonymous ones.)

For help with invocation, configuration, or diagnostics, consider using the [OSCAL Gitter chat channel](https://gitter.im/usnistgov-OSCAL/Lobby) (requires Github login), where community members can offer assistance often synchronously.

Feature requests, bug reports, and ideas for further development can be submitted to the [repository Issues board](https://github.com/usnistgov/xslt3-functions/issues).

## Citation

Cite this repository as:

Piez, Wendell, David Waltermire, et al. *XSLT3 Functions*. https://github.com/usnistgov/xslt3-functions.

## Related Material

### OSCAL

This project supports the [OSCAL project](https://pages.nist.gov/OSCAL), a family of data models supporting activities in the domain of Systems Security, which entails not only securing systems and designing and deploying secure systems; but also the assessment, documentation and validation of security.

- [OSCAL web site](https://pages.nist.gov/OSCAL)
- [OSCAL repository](https://github.com/usnistgov/OSCAL)
- [OSCAL tools site](https://pages.nist.gov/oscal-tools) and [repository](https://github.com/usnistgov/oscal-tools) (with [client-side XSLT demos](https://pages.nist.gov/oscal-tools/demos/csx))

### XSLT

XSLT, [Extensible Stylesheet Language Transformations](https://www.w3.org/XML/Group/qtspecs/specifications/xslt-30/html/), is a [fourth-generation programming language](https://en.wikipedia.org/wiki/Fourth-generation_programming_language) designed for the task of expediting tree-to-tree data transformations, where the trees concerned are abstracted representations of XML documents. That is, in addition to in-memory query, copy and manipulation, they are capable of being routinely and reliably produced by parsing XML, and persisted -- saved and exchanged across the system -- by serializing XML.

Version 1.0 of XSLT was released in 1999. Originally intended for the purpose of making human-legible output formats such as PDF or HTML, XSLT also has more general uses, in data extraction and acquisition, normalization, rules enforcement (validation), code generation and transpiling, literate programming, middleware and more. While maintaining its heritage as a declarative, functional language well-suited for prototyping, rapid deployment and agile development, the most recent version, XSLT 3.1, adds features such as higher-order functions and pseudo-random number generation.

The XSLT community can be found on the [XML.com Slack channel](https://www.xml.com/news/2020-04-slack-workspace-for-the-xml-community/) and in venues such as the [XSL-List](https://www.mulberrytech.com/xsl/xsl-list/index.html) listserv (email).
