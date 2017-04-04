# Known Limitations

The Co-dfns compiler is under active development. The following known
limitations exist with the current release.

## General Guidance on Using the Compiler

Generally speaking, the current version of Co-dfns works best if you focus
on writing pure functional programs written in dfns that do not make use 
of :, ::, or recursion and that use classic APL primitives (/ . ∘. and 
so forth) over simple numeric arrays working over data sizes that 
exceed 1 - 10 MB.

## High Priority Limitations

These limitations are not serious design limitations but represent unfinished 
or outstanding implementation or engineering work that has some recognizable 
and immediate benefit and thus will be considered part of the active set of 
things on which we are working.

* Laminate is not supported
* Dyadic Transpose does not permit duplicate axes
* Binomial is not implemented for negative and floating point values
* Recursive functions are not supported yet
* Bracket indexing of the form [X;...] is not supported, 
  though a single index array [X] is supported
* User-defined operators are not supported yet
* Assignment inside of an expression is not supported yet
* Indexed assignment and selective assignment are not supported yet

## Low Priority Limitations

These limitations are considered to be of little importance or very 
difficult to implement with little benefit/gain and thus are not likely 
to be implemented in the near future.

* Arrays of rank > 4 are not supported
* Sparse arrays are not supported yet
* Nested arrays are not yet supported
* Character types are not supported
* Complex numbers are not supported
* Arbitrary precision integers are not supported
* Nested namespaces are not supported
* Variant (⍠) is not supported
* I-Beam (⌶) is not supported
* Spawn (&) is not supported
* Enclose (⊂) is not supported
* Partitioned Enclose (⊂) is not supported
* Matrix divide/inverse (⌹) is not supported
* Format (⍕) is not supported
* The compiler will handle empty return values strangely at the moment.
* Namespaces with free references are not supported yet
* 128-bit floating point values are not supported
* Error Guards are not supported yet

## Fundamental Limitations

The following are some current "fundamental" limitations that represent
current design decisions that are likely to remain this way for the 
foreseeable future and can be thought of as hard lines around the project.

* Execute (⍎) is not supported and likely will not be supported
* The compiler does not support any Dyalog system functions or commands
  and will probably try to avoid providing these
* Objects/Classes are not supported in the system
* Type promotion on overflow is not supported; this is a design decision 
  for performance that will not likely change. In the future we may provide 
  some safety metrics for handling overflows or some exact numerics, 
  but automatic type promotion in the style of Dyalog APL will not likely 
  be supported because of severe performance issues
* Trad-fns and dynamic scope will not be supported
* `⎕IO ⎕ML ⎕CT` is fixed at `0 1 0`; note that we are not likely to ever 
  allow dynamic changes of these values inside of a Co-dfns computation 
  or namespace. We may, however, be persuaded by many forces to enable 
  changing these values globally at compile time.
