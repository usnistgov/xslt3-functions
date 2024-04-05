# Testing xslt3-functions

This repository is being developed incrementally, in stages. While never ruling out a complete overhaul of organization and resources, we intend most changes to be either at the edges, or isolated within projects. Accordingly, we need a testing model that is both robust and stable enough to be dependable, while also adaptable enough so that any contributor working on a project can use as much or as little of the overall testing infrastructure as seems appropriate.

Testing of utilities offered in this repository includes both informal, interactive testing per project, and in some projects, formal automoated testing of XSLT functionalities using [XSpec](https://github.com/xspec/xspec). Over time it is our hope that all testing will improve by virtue of each project's being able to emulate good practices developed in the context of others.

To ensure the integrity of our tests we rely on code review as well as other means.

The full testing stack (all XSpec files unless excluded) will be run on all PRs before any git merge; the same tests should first be run off line to help reduce noise in the commit history.

## Dependencies

- [Apache Maven](https://maven.apache.org/) must be [installed and available on your path](https://maven.apache.org/install.html), supported with a JDK.

<small>We give no link for Java Development Kit installation options are available and anything that works with Maven is fine.</small>

*Further options*: Additionally, at developers' discretion, projects in the repo may deploy scripts supporting runtimes in GNU `bash` syntax, Windows batch scripts or others considered appropriate. These tests and runtimes are not currently provided for under CI/CD, but they are nonetheless encouraged in the spirit of *more testing*. See the testing.md or readme.md documentation of any project for more details.

## Guidelines (tl/dr)

- Write unit tests for XSLT using [XSpec](https://github.com/xspec/xspec). The repository already includes some excellent XSpec to study for examples of its use.
- Save your XSpec file as `*.xspec` to be found by the test runner. Place it in a directory named `xspec/pending` (in your project) if you actually wish to hide it.
- In development, you can run the tests in an IDE (make inquiries or search for more details).
- The CI/CD test run is initiated using `mvn tests` from the top. This will execute all XSpec files in the repository that are not excluded by the configuration.
- In the test run, any failure of any XSpec test in an executed XSpec that is not marked as 'pending' is considered a blocking error.
- For more granular testing or testing beyond XSpec, consider using `bash` and `make` as illustrated in project directories such as [`xspec-dev`](xspec-dev/)

## Details

### Verify your JDK installation

If your JDK is installed and configured (JAVA_HOME) you should be able to execute

```
javac --version
```

And a version of the Java Compiler is announced.

If you run into trouble, see Maven documentation for JDK requirements.

### Verify your Maven installation

Once it is installed and on the system path, try

```
> mvn --help
```

A working Maven installation will tell you about itself.


### Repository CI/CD setup

[Under CI/CD we are currently configured](.github/workflows/maven.yml) to run the 'tests target defined in the top-level [Maven configuration pom.xml](pom.xml) file.

With Maven and a JDK installed and the command prompt open at the repository root, run all these tests using

```
> mvn tests
```

The configuration executes *all XSpec test suites in the repository*, unless subject to exclusion rules given in the pom.xml.

An exclusion for files matching `**/xspec/pending/**` permits developers to create an `xspec/pending` directory at any time and place XSpec files there that will *not* be run under CI/CD.

### More about XSpec

[XSpec](https://github.com/xspec/xspec) is a unit testing framework for XSLT supporting [behavior-driven development](https://github.com/xspec/xspec/wiki/What-is-XSpec). It was originated by Jeni Tennison and has been developed as a community-based project since 2016.

### More about more options

Projects in this repository also take advantage of scripts and the GNU **make** build utility to provide testing (or other) runtimes. Because they are run unless specifically designed not to, any XSpec files in place will be executed in CI/CD even while other testing utilities and harnesses can also use (or ignore) them.

In particular, the `xspec-dev` project provides scripts that make its (XSpec-oriented) functionalities available to developers and quality engineers as black box utilities (i.e., no "XML" anywhere, just files) for running tests in more complex configurations.

For simplicity and to reduce the burden on all contributors to this repository, these functions are not being used in the repository CI/CD - while other repositories using this one as a submodule may do so.

At the same time, contributors with `bash` and `make` support on their systems may wish to try

```
> make help
```

from within any directory containing a `Makefile`.

For convenience, the top level file configures a recursive descent into the file system, so all testing configured under `make` (not the same as CI/CD) can be run using

```
> make tests
```

Note to developers: the `make` configuration has its [own pom.xml](common/pom.xml) file in the [common directory](common/).

