# Invisible XML support


For more on Invisible XML:
  - https://invisiblexml.org/
  - https://github.com/usnistgov/ixml-breadboard

Aims:

- Demonstrate and document some minimal iXML functionality in XSLT v3
- Include iXML support in XSpec testing of this XSLT
- Address and document configuration issues in different runtimes (e.g.: XProc, Ant, Saxon from CL, oXygen XML)


## To do

iXML in XSLT and XSpec under XProc runtime

See https://github.com/ndw/xmlcalabash1/issues/335


## Test grammar

Included in this folder for testing is a grammar copied from the iXML repository at https://github.com/invisibleXML/ixml/blob/master/samples/ISO-8601-2004/iso8601.ixml

It defines ISO dateTime format such that it can be parsed into an XML representation. For purposes of this testing it does not have to be perfect.

## iXML setup

To support Invisible XML (iXML), libraries from NineML can be made available to an XSLT engine such as Saxon as an extension function library. NineML, a set of Invisible XML tools by Norm Walsh, is documented at http://nineml.org. It is selected here because of platform compatibility with Saxon.

Setting up the extension will depend on the processing architecture, whether Ant, XProc, a Java application or calling Saxon directly from the command line.

All configurations entail the following:

### NineML iXML Libraries

For iXML processing inside Saxon, three jar files must be made available on the classpath: **CoffeeGrinder**, **CoffeeFilter** and **CoffeeSacks**, available respectively from

   - https://github.com/nineml/CoffeeGrinder/releases/latest
   - https://github.com/nineml/CoffeeFilter/releases/latest
   - https://github.com/nineml/CoffeeSacks/releases/latest

A bash script in this folder, `download-jars.sh` (cribbed from Norm Walsh) is provided that will download these into a `lib` directory.

### Saxon configuration

An initialization setting must be provided to Saxon: `init:org.nineml.coffeesacks.RegisterCoffeeSacks`

How you pass this to Saxon will depend on the tooling.

### iXML in XSLT in oXygen XML

**oXygen XML Editor** (or **Developer**) can run your XSLT and your XSpec, and your iXML with it.

Norm Walsh offers [some hints](https://github.com/nineml/HOWTO/tree/main/oxygen). However, when we don't need to parameterize to handle inputs, it turns out to be a little simpler than the example depicted:

#### Using a scenario

For running [an XSLT like `ixml-demo.xsl`](ixml-demo.xsl), which
  - binds the extension namespace
  - includes or references one or more iXML grammars
  - using the extension, provides functions supporting syntax defined by those grammars

Configure a Transformation Scenario for running it

- Locate three jar files (as named above): **CoffeeGrinder**, **CoffeeFilter**, **CoffeeSacks**
- Create an XSLT Scenario for applying your XSLT with appropriate settings
- Add each of these as a Library under Extensions on this scenario (XSLT tab)
- Under the Transformation Scenario's *Saxon Transformer* options, list the Initializer:  `org.nineml.coffeesacks.RegisterCoffeeSacks`
- Save the Scenario

This scenario will be able to execute CoffeeSacks functions supporting iXML parsing in your XSLT.

#### iXML in XSpec in oXygen

When writing iXML-based functionality in XSLT, one wishes to be able to test it using XSpec.

Fortunately it is all Java, so the same settings can be provided to Ant for XSpec run under Ant, hence oXygen scenarios using Ant for XSpec can run these tests as well.

Create a new Scenario in oXygen by copying the built-in **Run XSpec Test** Ant Transformation Scenario. Open the **Configure Transformation Scenarios** dialog (Ctrl-Shift-C) and find **Run XSpec Test** under XSpec, and select Duplicate. Give your new scenario a new name.

Then:

- Add the three jar files to the set of libraries (from the button on the bottom right on Options tab)
- Add the value `init:org.nineml.coffeesacks.RegisterCoffeeSacks` to the `saxon.custom.options` parameter (middle tab)

Again your XSpec should run as XPected.
