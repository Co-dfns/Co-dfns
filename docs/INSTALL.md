# Obtaining and Installing the Co-dfns Compiler

## Release Cycle, Versioning

The Co-dfns compiler follows a rapid release cycle. That means there is only one currently supported release, which is the latest version. Compiler versions follow semantic versioning, but without the typical expectations that major versions are released less frequently.

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

4. [Optional] CUDA 9.2+

Please make sure that the version of CUDA that you install is 
the same as the version of CUDA used by the ArrayFire package you installed.

## Installing and using the `codfns.dws` workspace

The `codfns.dws` workspace includes a `codfns` namespace that encapsulates the compiler functionality. The workspace may be installed anywhere that is convenient, and the codfns namespace may be copied via the `)copy` system command as convenient. It is also reasonable to simply create a copy of the codfns workspace wherever convenient and use it as desired.

## Installing the Co-dfns User Command

The compiler may also be used through the Dyalog user-command functionality. To install the Co-dfns compiler as an user command, copy the `codfns.dyalog` file into one of the user-command paths (see Dyalog documentation for more information on setting up the user-command system). After doing so, the Co-dfns compiler functionality can be examined through the `]?codfns` help command. 
