# Obtaining and Installing the Co-dfns Compiler

## Obtaining a copy of the compiler

**Always try to use the latest version release of the compiler if at all possible.**
Official versions of the compiler can be found here:

https://github.com/Co-dfns/Co-dfns/releases

It may also be possible to use the master branch of the repository, but as noted
below, this is not guaranteed to work. If a feature has recently been added to 
master that you wish to use that is not yet in a released version, please 
contact the author requesting a new release be pushed. 

## Release Cycle, Versioning

The Co-dfns compiler follows a "release when it's ready, don't hold back" 
philosophy with semantic versioning. There is only one currently supported 
release, which is the latest version. Compiler versions follow semantic 
versioning, but without the typical expectations that major versions are 
released less frequently.

The `master` branch is expected to track the versioning closely, and so the 
compiler can also be thought of as operating on a running release 
cycle/deployment model. It is important to note that master is considered 
unstable, and should not be relied on unless you are developing Co-dfns. 

## System Requirements

The Co-dfns compiler is fairly self-contained. You will need the following 
software at their latest versions:

1. Dyalog APL 64-bit Unicode edition

2. Your Operating System's host compiler:

    * Visual Studio (Windows)
    * GCC (Linux)
    * Clang (Mac OS X)

3. ArrayFire

You can find the appropriate ArrayFire installation instructions 
for your operating system here:

http://arrayfire.org/docs/installing.htm

The ArrayFire installer prompts you to choose whether or not to set 
paths in your environment. You need to make sure that these paths 
are set. You can allow the installer to do this for you during install, 
or you can read the installation documentation for ArrayFire and add 
these paths yourself. 

## Setting up your build arena

The compiler typically produces objects in your current working directory. 
To prevent conflicts, we recommend that you have a build directory where you 
do you work. Alternatively, you can run from within the tests directory
as a convenience for testing. 

The following sections assume that you are located inside of a build directory 
that you have created inside of the Co-dfns repository root. 

## Loading the compiler

The source code consists of a set of utility functions defined in `ws\` 
to assist in working with the source code. The compiler proper exists in 
`cmp\` and is loaded using the `LOAD` function. 

	]link.import # ..\ws
	LOAD'..'

This will make the `codfns` namespace available to you as well as setting up 
the testing harness.

## Building the runtime

You need to build the runtime for the compiler if you wish to use it. 
By default, the runtime will be linked against the Unifed ArrayFire backend. 
However, if you wish to select a specific backend, you can provide one of the 
following left arguments to MK∆RTM:

	''		Unified Backend (default)
	'cpu'		CPU Backend
	'opencl'	OpenCL (Make sure to have good drivers!)
	'oneapi'	Intel OneAPI
	'cuda'		CUDA backend (Must have a CUDA capable GPU)

Other backends may be possible depending on the specific version of ArrayFire
that you have installed. You can pass any of these as an optional left argument
to the following command to build the runtime:

	codfns.MK∆RTM'..' ⍝ From tests\ or your build directory

This will build the runtime in `rtm/` and also copy the necessary distributables 
to the `tests/` directory so that you can run the test suite.

The runtime distributables must be placed in a location that your operating 
system will search when looking for shared objects. The assumption Co-dfns 
generally makes is that the current working directory is in this lookup path. 

If you are working inside of your own build directory, you can install the runtime
distributables including any headers into your current working directory 
by running the following:

	codfns.INSTALL∆RTM'..'

## Getting Started

At this point, we highly recommend reading the [manual](MANUAL.md) for more
information about how to call the compiler. As a basic example, you can 
use the following to test the compiler by using the `Fix` function, which 
behaves like the `⎕FIX` function. 

	      cd←'sample'codfns.Fix':Namespace sample' 'iota←{⍳⍵}' ':EndNamespace'
	      cd.iota 20
	0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19

## Running the test suite

You can run the test suite by changing into the `tests/` directory and running 
the following command to run a single test:

	TEST 9 ⍝ Run test 9

You can run the entire test suite with the following:

	TEST'ALL'

We assume that you will using ⎕IO←0 during any development and testing, so make 
sure that this is set when doing work with the test suite. 