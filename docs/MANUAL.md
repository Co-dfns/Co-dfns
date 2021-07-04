# Co-dfns Compiler

## Synopsis

	target←<module name> codfns.Fix <namespace script>
	]codfns.compile <namespace> <target> [-af={cpu,opencl,cuda}]
	ast exports symbols source←[env] codfns.ps 'line1' 'line2' ...

## Description

The Co-dfns compiler takes APL code in the dfns syntax and compiles it for use directly in the Dyalog APL interpreter or through a C API. It targets both CPU and GPU architectures and provides users with a straightforward means of running their APL as data-parallel code on vector hardware.

The compiler may be accessed either through the user-command functionality of Dyalog APL or through the namespace interface.

### User-Command Options

Argument  | Description
--------- | -----------
namespace | The name of a compilable namespace defined in the current workspace. The compiler will attempt to compile this namespace.
target    | The name the compiler should give to the compiled Co-dfns module. Upon compilation, a namespace called `<target>` will be created and linked to the compiled module.
-af       | Specify a specific backend to use. Valid options are: cpu, cuda, opencl. If this option is omitted, then the Co-dfns compiled object will attempt to auto-detect the fastest backend to use at runtime.

### Namespace Options and Functions

Expression | Description
---------- | -----------
Fix        | The Fix function is the primary entry into the Co-dfns compiler. It takes a character vector on the left indicating the desired name of the compiled module and the namespace script to compile as the right argument. The format of the namespace script should correspond to the `⎕FIX` format. `Fix` returns a namespace linked to the compiled object.
ps         | The Co-dfns parsing function. It takes a vector of character vectors containing a namespace script and parses the code into an AST.
AF∆LIB     | The character vector containing the name of the backend to use. Defaults to `''`. See the documentation for `-af` above.
AF∆PREFIX  | The location of the ArrayFire library installation for Linux/Mac platforms.
VERSION    | The version of the compiler. Do not modify this value.

## Parser Return Structure

The Co-dfns parser returns a vector of 4 elements, the AST, module exports, symbol table, and the original parsed source.

Field   | Description
------- | -----------
AST     | The AST structure of the parsed tree
Exports | The names and types of the top-level exported bindings
Symbols | The set of unique names (character vectors) and values in the AST (symbols and numbers)
Source  | A character vector of the original parsed source

### AST Structure

A parsed AST is an inverted table of nodes containing the following columns. The nodes in the table are ordered according to their depth-first pre-order traversal.

Name  | Description
----- | -----------
depth | The depth of the node in the AST. Root nodes are depth 0.
type  | The type of the node, as an index into the `N∆` constant.
kind  | The sub-type or kind of the node, as an integer.
name  | A positive integer referencing another node in the table or a negative index into the symbol table.
start | The starting index into the source corresponding to this node.
end   | The exclusive ending index into the source corresponding to this node.

### Exports/Env structure

The exports produced by the parser is a two-column inverted table containing the following fields. This structure is the same for the exports returned from the parser as well as for the optional environment that can be passed to the parser to seed values into the environment used by the parser to lookup variables.

Name | Description
---- | -----------
name | The name of the binding as a character vector
type | The type of the binding as an integer (¯1: Unbound, 0: Array, 1: Function)

## Error Reporting

When the parser fails to successfully parse a given input source, the parser updates ⎕DMX and signals an appropriate error code. Additionally, it updates the `EN` and `DM` variables in the `codfns` namespace to reflect the error. See the official Dyalog APL documentation on `⎕EN` and `⎕DM` for information on the format of these variables.

## Runtime API

Every module that is compiled also exposes additional functionality in the Co-dfns runtime through the Runtime API. This functionality is available inside the `module.∆` namespace, where `module` is the name of the namespace linked to the compiled module. It also initializes the `module.⍙` to contain all of the exported functions declared using the raw C API, allowing for the use of the caching functions without declaring your functions manually.

Expression               | Description
------------------------ | -----------
Init                     | A niladic function to initialize the runtime system. This must be done every time the linked namespace is reloaded.
[Wn] (Fn Display Tst) Z  | Enters a display loop for a newly created graphical window named `Wn`. The operator `Display` has the same basic interface as the `⍣` operator, except that the left-argument to `Fn` will always be the window id. The event loop will continue until either the window is closed, the iteration count has been reached, or the termination condition is true.
Wh Image Z               | Takes a window handle and an image value that is either a rank 2 or rank 3 array and displays the image to the given window handle. A rank 3 array must have its last axis of size 3, and should be a set of color values in the RGB scale. Returns `Z`.
Wh Plot Z                | Takes a window handle and a plot array. It displays the plot in the given window referenced by the window handle. The plot can be either a 2-D or 3-D plot, indicated by the size of the second axis in the given matrix. A plot array must be a matrix whose column count is either 2 or 3. Each row corresponds to a specific point to plot, given by X, Y, and optionally, Z values. Returns `Z`.
Wh Histogram Frq Min Max | Takes a window handle and a triple containing a vector of frequencies, the minimum value, and the maximum value referenced by the frequency vector. It displays the histogram of the values to the given Window Handle.
MKA array                | Returns a pointer to a Co-dfns allocated array that is equivalent to `array`.
EXA ptr                  | Returns a Dyalog APL array that is equivalent to the Co-dfns allocated array pointed to by `ptr`.
FREA ptr                 | Frees the Co-dfns allocated array pointed to by `ptr`.
Sync                     | Waits until all computation on the GPU is complete before returning

## Files

The compiler produces a set of files for each compiled module. The specific files that are generated may differ based on platform, but the following files will always exist:

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
[PERFORMANCE.md](PERFORMANCE.md)          | Suggestions for understanding the performance of Co-dfns compiled code.

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
* Only partial support for arrays of rank > 4
* Only partial support for nested arrays, including some missing nested array primitives
* Character types are not supported
* Selective assignment is not supported yet
* User-defined operators are not supported yet
* Mixed arrays are not supported
* Lexically scoped trad-fns are not supported yet
* Error Guards are not supported yet
* Namespaces with free references are not supported yet
* Nested namespaces are not supported
* Structured Colon Statements are not supported
* Branch (→) is not supported
* Arbitrary precision integers are not supported
* Sparse arrays are not supported yet
* Format (⍕) is not supported
* I-Beam (⌶) is not supported
* Spawn (&) is not supported
* 128-bit floating point values are not supported
* Variant (⍠) is not supported
* Stencil (⌺) is not supported
* Inverse (⍣¯1) is not supported
* Execute (⍎) is not supported
* The compiler does not support any Dyalog system functions or commands
* Objects/Classes are not supported in the system
* Type promotion on overflow is not supported
* Dynamically scoped trad-fns are not supported
* `⎕IO ⎕ML ⎕CT` is fixed at `0 1 0`

## Authors

The Co-dfns compiler is primarily maintained, supported, and developed by Aaron W. Hsu.
