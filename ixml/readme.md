# Invisible XML support

Aims:

- Demonstrate and document some minimal iXML functionality in XSLT
- Include iXML support in XSpec testing of this XSLT
- Address and document configuration issues in different runtimes (XProc, Ant, Saxon from CL, oXygen)


## To do

iXML in XSLT and XSpec under XProc runtime

See https://github.com/ndw/xmlcalabash1/issues/335

## Test grammar

Included in this folder for testing is a grammar copied from the iXML repository at https://github.com/invisibleXML/ixml/blob/master/samples/ISO-8601-2004/iso8601.ixml

It defines ISO dateTime format such that it can be parsed into an XML representation. For purposes of this testing it does not have to be perfect.

## iXML setup

The Invisible XML Library is made available to an XSLT engine such as Saxon as an extension function library.

Setting up the extension will depend on the processing architecture, whether Ant, XProc, a Java application or calling Saxon directly from the command line.

All configurations entail the following:

### NineML iXML Libraries

For iXML processing inside Saxon, three jar files must be made available on the classpath: **CoffeeGrinder**, **CoffeeFilter** and **CoffeeSacks**, available respectively from

   - https://github.com/nineml/CoffeeGrinder/releases/latest
   - https://github.com/nineml/CoffeeFilter/releases/latest
   - https://github.com/nineml/CoffeeSacks/releases/latest

A bash script in this folder, `download-jars.sh` (cribbed from Norm Walsh) is provided that will download these into a `lib` directory.

### Saxon configuration

An initialization setting is provided to Saxon: `init:org.nineml.coffeesacks.RegisterCoffeeSacks`

How you pass this to Saxon will depend on the tooling.

### iXML in XSLT in oXygen XML

**oXygen XML Editor** (or **Developer**) can run your XSLT and your XSpec, and your iXML with it.

Norm Walsh offers hints here:

https://github.com/nineml/HOWTO/tree/main/oxygen

But when we don't need to parameterize for the inputs, it turns out to be a little simpler than the example depicted:

#### Using a scenario

For running an XSLT like `ixml-demo.xsl`, which
  - Binds the extension namespace
  - Provides a function for each grammar you wish to parse

Configure a Transoformation Scenario for running it

- Add three jar files (as named above) as extensions to the oXygen scenario: **CoffeeGrinder**, **CoffeeFilter**, **CoffeeSacks**
- Set up the Initializer under the Scenario's *Saxon Transformer* options:  `org.nineml.coffeesacks.RegisterCoffeeSacks`

#### iXML in XSpec in oXygen

When writing iXML-based functionality in XSLT, one wishes to be able to test it using XSpec.

Fortunately it is all Java, so the same settings can be provided to Ant for XSpec run under Ant, hence oXygen scenarios using Ant for XSpec can run these tests as well.

Copy the built in **Run XSpec** framework for XSpec in Ant, and adjust its Ant settings:

- The three jar files are added to the libraries (from the button on the bottom right on Options tab)
- The value `init:org.nineml.coffeesacks.RegisterCoffeeSacks` is added to saxon.custom.options` parameter (middle tab)

Your XSpec should run as XPected.
