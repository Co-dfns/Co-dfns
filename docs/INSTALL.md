# Obtaining and Installing the Co-dfns Compiler

## Release Cycle, Versioning

The Co-dfns compiler follows a "release when it's ready, don't hold back" philosophy with semantic versioning. There is only one currently supported release, which is the latest version. Compiler versions follow semantic versioning, but without the typical expectations that major versions are released less frequently.

The `master` branch is expected to track the versioning closely, and so the compiler can also be thought of as operating on a running release cycle/deployment model. 

## Obtaining a copy of the compiler

Always try to use the latest version of the compiler if at all possible. Official versions of the compiler can be found here:

https://github.com/Co-dfns/Co-dfns/releases

It may also be possible to use the master branch of the repository, but as noted above, this is not guaranteed to work. If a feature has recently been added to master that you wish to use that is not yet in a released version, please contact the author requesting a new release be pushed. 

## System Requirements

The Co-dfns compiler is fairly self-contained. You will need the following 
software at their latest versions:

1. Dyalog APL 64-bit Unicode edition

2. Your Operating System's host compiler:

    * Visual Studio (Windows)
    * GCC (Linux)
    * Clang (Mac OS X)

3. ArrayFire

You should be able to find the appropriate ArrayFire installer included 
in the release page for a given Co-dfns release. You can find the 
appropriate installation instructions for your operating
system here:

http://arrayfire.org/docs/installing.htm

## Loading the compiler

To load the compiler, you can load the src directory into your workspace using
link:

	]link.import # src
	
This will make the `codfns` namespace available to you as well as setting up 
the testing harness.

## Building the runtime

You need to build the runtime for the compiler if you wish to use it. 

	MK∆RTM'.' ⍝ From the top-level of the Co-dfns repository

This will build the runtime in `rtm/` and also copy the necessary distributables 
to the `tests/` directory so that you can run the test suite.

## Compiling a namespace

You can compile a namespace script using the following:

	'module_name'codfns.Fix <namespace script>

Where `<namespace script>` is the same as the output of `⎕SRC` on a scripted 
namespace (vector of character vectors).

## Running the test suite

You can run the test suite by changing into the `tests/` directory and running 
the following command:

	TEST'ALL'

