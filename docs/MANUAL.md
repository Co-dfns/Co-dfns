# Co-dfns Compiler

## Synopsis

	target←<module name> codfns.Fix <namespace script>
	]codfns.compile <namespace> <target> [-af={cpu,opencl,cuda}]

## Description

The Co-dfns compiler takes APL code in the dfns syntax and compiles it for use directly in the Dyalog APL interpreter or through a C API. It targets both CPU and GPU architectures and provides users with a straightforward means of running their APL as data-parallel code on vector hardware. 

The compiler may be accessed either through the user-command functionality of Dyalog APL or through the namespace interface. 

### User-Command Options

Argument  | Description
--------- | -----------
namespace | The name of a compilable namespace defined in the current workspace. The compiler will attempt to compile this namespace.
target    | The name the compiler should give to the compiled Co-dfns module. Upon compilation, a namespace called <target> will be created and linked to the compiled module.
-af       | Specify a specific backend to use. Valid options are: cpu, cuda, opencl. If this option is omitted, then the Co-dfns compiled object will attempt to auto-detect the fastest backend to use at runtime.

### Namespace Options and Functions

Expression | Description
---------- | -----------
Fix        | The Fix function is the primary entry into the Co-dfns compiler. It takes a character vector on the left indicating the desired name of the compiled module and the namespace script to compile as the right argument. The format of the namespace script should correspond to the `⎕FIX` format. `Fix` returns a namespace linked to the compiled object.
AF∆LIB     | The character vector containing the name of the backend to use. Defaults to `''`. See the documentation for `-af` above.
AF∆PREFIX  | The location of the ArrayFire library installation for Linux/Mac platforms.
VERSION    | The version of the compiler. Do not modify this value.

## Runtime API

Every module that is compiled also exposes additional functionality in the Co-dfns runtime through the Runtime API. This functionality is available inside the `module.∆` namespace, where `module` is the name of the namespace linked to the compiled module. It also initializes the `module.⍙` to contain all of the exported function declared using the raw C api, allowing for the use of the caching functions without declaring your functions manually.

Expression               | Description
------------------------ | -----------
Init                     | A niladic function to initialize the runtime system. This must be done every time the linked namespace is reloaded.
[Wn] (Fn Display Tst) Z  | Enters a display loop for a newly created graphical window named `Wn`. The operator `Display` has the same basic interface as the `⍣` operator, except that the left-argument to `Fn` will always be the window id. The event loop will continue until either the window is closed, the iteration count has been reached, or the termination condition is true.
Wh Image Z               | Takes a window handle and an image value that is either a rank 2 or rank 3 array and displays the image to the given window handle. A rank 3 array must have it's last axis of size 3, and should be a set of color values in the RGB scale. Returns `Z`.
Wh Plot Z                | Takes a window handle and a plot array. It displays the plot in the given window referenced by the window handle. The plot can be either a 2-D or 3-D plot, indicated by the size of the second axis in the given matrix. A plot array must be a matrix whose column count is either 2 or 3. Each row corresponds to a specific point to plot, given by X, Y, and optionally, Z values. Returns `Z`.
Wh Histogram Frq Min Max | Takes a window handle and a triple containing a vector of frequencies, the minimum value, and the maximum value referenced by the frequency vector. It displays the histogram of the values to the given Window Handle.
MKA array                | Returns a pointer to a Co-dfns allocated array that is equivalent to `array`. 
EXA ptr                  | Returns a Dyalog APL array that is equivalent to the Co-dfns allocated array pointed to by `ptr`.
FREA ptr                 | Frees the Co-dfns allocated array pointed to by `ptr`.
Sync                     | Waits until all computation on the GPU is complete before returning

## Files

The compiler produces a set of files for each compiled module. The specific files that are generated my differ based on platform, but the following files will always exist:

File                  | Description
--------------------- | -----------
module.log            | A log of the backend messages and compiler output, indicating any issues encountered during the compilation of the backend code.
module.{so,dll,dylib} | The shared object of the module.
module.cpp            | The generated intermediate source code for the module.

## Examples

Compile an empty namespace (useful for accessing the graphics functionality):

	ns←'gfx'codfns.Fix ':Namespace' ':EndNamespace'

Compile a namespace for CUDA only using the user-command:

	_←⎕NS⍬
	]compile _ ns -af=cuda

## See Also

Reference                                 | Description
----------------------------------------- | -----------
[help.dyalog.com](http://help.dyalog.com) | Documentation for the Dyalog language and systems.
[FAQ.md](FAQ.md)                          | Frequently asked questions about the compiler.
[LIMITATIONS.md](LIMITATIONS.md)          | Current known limitations of the compiler.
[PERFORMANCE.md](PERFORMANCE.md)          | Suggestions for understanding the performance of Co-dfns compiled code.
[WISHLIST.md](WISHLIST.md)                | A current wishlist of features for the compiler.

## Known Limitations

Generally speaking, Co-dfns works best if you focus on writing pure, 
functional programs written in dfns that make limited use 
of `:` or recursion and that use classic APL primitives (/ . ∘. and 
so forth) over simple numeric arrays working over data sizes that 
exceed 1 - 10 MB. While recursion and guards are supported, it is best if 
you restrict their use to outer-most functions, since they are significantly 
less efficient on the GPU than APL primitives. 

The following limitations are known to exist:

* Binomial is not implemented correctly for some values
* Arrays of rank > 4 are not supported
* Character types are not supported
* Nested arrays are not yet supported
* Enclose (⊂) is not supported
* Partitioned Enclose (⊂) is not supported
* Indexed assignment and selective assignment are not supported yet
* User-defined operators are not supported yet
* Lexically scoped trad-fns are not supported yet
* Error Guards are not supported yet
* Namespaces with free references are not supported yet
* Colon Statements are not supported
* Branch (→) is not supported
* Arbitrary precision integers are not supported
* Sparse arrays are not supported yet
* Format (⍕) is not supported
* I-Beam (⌶) is not supported
* Spawn (&) is not supported
* Nested namespaces are not supported
* 128-bit floating point values are not supported
* Variant (⍠) is not supported
* Mixed arrays are not supported
* Stencil (⌺) is not supported
* Inverse (⍣¯1) is not supported
* Execute (⍎) is not supported

The following are some current "fundamental" limitations that represent
current design decisions that are likely to remain this way for the 
foreseeable future and can be thought of as hard lines around the project.

* The compiler does not support any Dyalog system functions or commands
  and will probably try to avoid providing these
* Objects/Classes are not supported in the system
* Type promotion on overflow is not supported; this is a design decision 
  for performance that will not likely change. In the future we may provide 
  some safety metrics for handling overflows or some exact numerics, 
  but automatic type promotion in the style of Dyalog APL will not likely 
  be supported because of severe performance issues
* Dynamically scoped trad-fns will not be supported
* `⎕IO ⎕ML ⎕CT` is fixed at `0 1 0`; note that we are not likely to ever 
  allow dynamic changes of these values inside of a Co-dfns computation 
  or namespace. We may, however, be persuaded by many forces to enable 
  changing these values globally at compile time.


## Authors

The Co-dfns compiler is primarily maintained, supported, and developed by Aaron W. Hsu.
