# Planning

These are long-term plans since other priorities are expected to intervene.

## More comprehensive approach to XSpec coverage

XSpec has no formal specification, but it does have a test suite. Possibly this could be consulted to show the fuller range of possible outputs.

Running a schema-inferencer across this data set would show interesting results, or really any kind of systematic analysis tracing its boundaries.

Given a more comprehensive map of requirements we can come back to:

* Aggregator XSLT - `xspec-summarize.xsl` currently assumes XSpec for XSLT, but we know we also have XSpec for Schematron and XQuery, at least
* Presentation XSLT - especially wrt internal organization of scenarios

An alternative to this of course is to grow into this more gradually - but if we expect to do that we also need more unit tests! The XSpec repo test set could give us a jump start.

## XSpec project

Along similar lines, we could conceivably work to contribute this work or some of it back up to [the XSpec project](https://github.com/xspec/xspec).
