# Known Limitations

The Co-dfns compiler is under active development. The following known
limitations exist with the current release.

## General Guidance on Using the Compiler

Generally speaking, the current version of Co-dfns works best if you focus
on writing pure functional programs written in dfns that do not make use 
of :, ::, or recursion and that use classic APL primitives (/ . ∘. and 
so forth) over simple arrays working over data sizes that exceed 1 - 10 MB.

## High Priority Limitations

These limitations are not serious design limitations but represent unfinished 
or outstanding implementation or engineering work that has some recognizable 
and immediate benefit and thus will be considered part of the active set of 
things on which we are working.

* Rotate (⌽ or ⊖) works over scalar left arguments only
* Dyadic Reduce (/ and ⌿) with negative left arguments are not supported
* Reductions with intermediate types different from the result type will not work
* Replicate First (⌿) is not supported
* Expand (\ and ⍀) is not supported
* Laminate (⍪[N]) is supported in special cases only
* Deal (?) is not supported
* Find (⍷) is not supported
* Decode (⊥) only supports special cases right now
* Encode (⊤) only supports special cases right now
* Compose (∘) is not implemented
* Power (⍣) is not implemented
* Rank (⍤) is not implemented
* The Log (⍟) function is not implemented for bitvectors
* Binomial is not implemented for negative and floating point values
* Conditional guards and Error Guards are not supported yet
* Recursive functions are not supported yet
* Assignment inside of an expression is not supported yet
* Fusion does not work with indexed arguments
* Fusion does not work over user-defined functions
* Scalar user-defined functions are not optimized and have overhead
* Only scalar function expressions are fused
* User-defined operators are not supported yet
* Bracket indexing of the form [X;...] is not supported, 
  though a single index array [X] is supported
* Indexed assignment and selective assignment are not supported yet

## Low Priority Limitations

These limitations are considered to be of little importance or very 
difficult to implement with little benefit/gain and thus are not likely 
to be implemented in the near future.

* Sparse arrays are not supported yet
* Nested arrays are not yet supported
* Character types are not supported
* Type promotion on overflow is not supported
* Complex numbers are not supported
* Arbitrary precision integers are not supported
* 128-bit floating point values are not supported
* Objects and nested namespaces are not supported
* `⎕IO` is fixed at 0
* `⎕ML` is fixed at 1
* `⎕CT` is fixed at 0
* Variant (⍠) is not supported
* I-Beam (⌶) is not supported
* Spawn (&) is not supported
* Split (↓) is not supported
* Enclose (⊂) is not supported
* Partitioned Enclose (⊂) is not supported
* Execute (⍎) is not supported
* Matrix divide/inverse (⌹) is not supported
* Format (⍕) is not supported
* The compiler does not support any Dyalog system functions or commands 
  at this time.
* The compiler will handle empty return values strangely at the moment.
* Namespaces with free references are not supported yet
