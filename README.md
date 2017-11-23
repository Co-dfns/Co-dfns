# Co-dfns Compiler

The Co-dfns project aims to provide a high-performance, high-reliability
compiler for a parallel extension of the Dyalog dfns programming language.
The dfns language is a functionally oriented, lexically scoped dialect of
APL. The Co-dfns language extends the dfns language to include explicit task
parallelism with implicit structures for synchronization and determinism. 
The language is designed to enable rigorous formal analysis of programs 
to aid in compiler optimization and programmer productivity, as well as in
the general reliability of the code itself.

Our mission is to deliver scalable APL programming to information and domain
experts across many fields, expanding the scope and capabilities of what
you can effectively accomplish with APL.

## Contributing and Helping

We are seeking to create an open funding model for Co-dfns research through 
user and patron contributions. You can support the project by contributing code, 
feedback, benchmarks, and so forth, but you can also directly support the 
Co-dfns project by funding the author: 

https://www.patreon.com/arcfide

## Getting the compiler

Co-dfns follows a rapid release cycle. Releases can be found here:

https://github.com/arcfide/Co-dfns/releases

## Installing Co-dfns

It is recommended that you install Co-dfns as an User Command. This will 
give you the most convenient access to the compiler functionality no 
matter where you are or what workspace you are using. This also eliminates 
the need for you to copy the codfns namespace into your local workspace 
unless you want some of the specific access to specialized functionality.

Simply copy the `codfns.dyalog` file into your User Commands directory. 
See the User Command documentation in your Dyalog installation for more 
information on using User Commands.

## Runtime Compiler APIs

Normal use of the compiler can be accessed through the User Command 
functionality, and documentation for the User commands is available using 
the `]?codfns`. There are some specific features that require you to have 
a copy of the Co-dfns namespace in your local workspace. These APIs are 
described in this section. 

### Graphics API

The graphics API permits the high-performance display of graphics data, 
including plots, images, and animations. It integrates with the Co-dfns 
compiler to produce good code and utilizes the GPU where possible.

#### codfns.Gfx∆Init

    {} ← codfns.Gfx∆Init Name

Given the `Name` used as the left argument to a `Fix` call, initialize the 
graphics library.

#### codfns.Display

    Z ← WName (F codfns.Display T) Initial

Works like the Power (`⍣`) operator. Derives a function that takes a window 
name as the left hand argument and an initial value as the right hand argument. 
It will iterate F over the right argument for T iterations when T is a value and 
until T is true when T is a function. As a side-effect it will display a new 
window names `WName` and will pass the handle to this window as the left argument
to F.

#### codfns.Image

    Z ← WHandle codfns.Image Z

Takes a window handle and an image value that is either a rank 2 or rank 3 
array and displays the image to the given window handle. A rank 3 array 
must have it's last axis of size 3, and should be a set of color values in 
the RGB scale.

#### codfns.Plot

    Z ← WHandle codfns.Plot Z

Takes a window handle and a plot array. It displays the plot in the given 
window referenced by the window handle. The plot can be either a 2-D or 3-D
plot, indicated by the size of the second axis in the given matrix. A 
plot array must be a matrix whose column count is either 2 or 3. Each row 
corresponds to a specific point to plot, given by X, Y, and optionally, Z 
values.

#### codfns.Histogram

    Z ← WHandle codfns.Histogram Freq Min Max 

Takes a window handle and a triple containing a vector of frequencies, 
the minimum value, and the maximum value referenced by the frequency vector.
It displays the histogram of the values to the given Window Handle.

### Caching API

The caching api allows you to call directly into the Co-dfns compiled 
namespace without using DWA to convert values. You do this by explicitly 
allocating a function and then applying specialized versions of Co-dfns 
compiled functions on those arrays until you are ready to extract the 
result, in which case you can extract them out.

The specialized functions are specialized according to your input types. 
Given input types b, i, and f for Boolean, Integer, and Floating, respectively, 
you can use `⎕NA` to access the function. It's name will be `<name><tr><tr>`
where `<name>` is the name of the function, and `<tr>` and `<tl>` are the types 
of the right and left inputs, respectively.

These specialized functions return the type of the resulting array computation 
as their return value.

#### codfns.MKA

    Codfns_Array ← Name codfns.MKA Array

This allows you to manually obtain a pointer to a Co-dfns array created from 
a given Dyalog DWA Array. 

#### codfns.EXA

    Array ← Name codfns.EXA Codfns_Array

Used to extract an array from Co-dfns. It takes a pointer to a Co-dfns array 
and the type of that array. It returns a normal Dyalog array that is equivalent
to the Co-dfns array.

#### codfns.FREA

    {} ← Name codfns.FREA Codfns_Array

Frees a Co-dfns array pointer obtained from `MKA`. 

## System Requirements

The Co-dfns compiler is fairly self-contained. You will need the following 
software in order to use the compiler:

1. Dyalog APL 16.0 or later 64-bit Unicode edition

2. Your Operating System's host compiler:

    * Visual Studio 2017 (Windows)
    * GCC (Linux)
    * Clang (Mac OS X)

3. ArrayFire (3.5.1+)

You should be able to find the appropriate ArrayFire installer included 
in the release page for a given Co-dfns release. On Windows, if you want 
to use the CUDA backend you will need to make sure that the appropriate 
nvvm64 dll (something like `nvvm64_31_0.dll`) is copied into the directory 
from which you will launch the compiler.

You can find the appropriate installation instructions for your operating
system here:

http://arrayfire.org/docs/installing.htm

4. [Optional] CUDA 8+

If you intend to use the CUDA backend with ArrayFire, you will need to have 
CUDA 8 or greater installed. This will also be necessary if you would like to 
analyze performance of the generated code. 

## Related Projects

There are a number of related initiatives that are based on the Co-dfns 
technology:

* [Mystika](https://github.com/arcfide/mystika):
  a high-level, high-performance cryptographic stack
* [apixlib](https://github.com/arcfide/apixlib): 
  programmable, easy to use image processing

## Publications

[Co-dfns 2017 Report](https://sway.com/mJg0M7qakrJBwP6G?ref=Link)

[APL Style: Patterns and Anti-patterns](https://sway.com/b1pRwmzuGjqB30On?ref=Link)

[Co-dfns Compiler Architecture and Design (Video)](https://youtu.be/gcUWTa16Jc0)

[The Key to a Data Parallel Compiler](http://dl.acm.org/citation.cfm?id=2935331)

[Accelerating Information Experts Through Compiler Design](http://dl.acm.org/citation.cfm?id=2774968)

[Co-dfns: Ancient Language, Modern Compiler](http://dl.acm.org/citation.cfm?id=2627384)

[U11: Using Co-dfns to Accelerate APL Code](http://dyalog.com/user-meetings/dyalog15.htm)

[U07: Co-dfns Report: Performance and Reliability Prototyping](http://dyalog.com/user-meetings/dyalog14.htm)

[I04: Co-dfns Compiler](http://dyalog.com/user-meetings/dyalog13.htm)

[Dyalog 2016 Presentation](https://sway.com/FmRyyaCSqappknRD)
