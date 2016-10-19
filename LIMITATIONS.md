# Known Limitations

The Co-dfns compiler is under active development. The following known
limitations exist with the current release.

## Missing or Incomplete Primitives

### Scalar Primitives

* The Log (⍟) function is not implemented for bitvectors
* Binomial is not implemented for negative and floating point values

### Mixed Primitives

Note: We refer only to the specific function in this list, while the 
corresponding dyadic or monadic function, if not listed, is supported.

* Laminate (⍪[N]) is supported in special cases only
* Rotate (⌽ or ⊖) works over scalar left arguments only
* Split (↓) is not supported
* Enclose (⊂) is not supported
* Partitioned Enclose (⊂) is not supported
* Pick (⊃) is not supported
* Replicate First (⌿) is not supported
* Expand (\ and ⍀) is not supported
* Intersection (∩) is not supported
* Membership (∊) is not supported
* Deal (?) is not supported
* Find (⍷) is not supported
* Execute (⍎) is not supported
* Format (⍕) is not supported
* Decode (⊥) only supports special cases right now
* Encode (⊤) only supports special cases right now
* Matrix divide/inverse (⌹) is not supported
* Some mixed primitives will not work over boolean values
* Some mixed primitives will not work over 
  mixed integer/float and boolean values
* Some primitives do not support the full range of input

### Operators

* Reductions with intermediate types different from the result type will not work
* Dyadic Reduce (/ and ⌿) with negative left arguments are not supported
* Compose (∘) is not implemented
* Power (⍣) is not implemented
* Rank (⍤) is not implemented
* Variant (⍠) is not supported
* I-Beam (⌶) is not supported
* Spawn (&) is not supported

## System Commands

The compiler does not support any Dyalog system functions or commands 
at this time.

* `⎕IO` is fixed at 0

## Syntax

* Bracket indexing of the form [X;...] is not supported, 
  though a single index array [X] is supported
* The compiler will handle empty return values strangely at the moment.
* Indexed assignment and selective assignment are not supported yet
* Conditional guards and Error Guards are not supported yet
* Recursive functions are not supported yet
* User-defined operators are not supported yet
* Namespaces with free references are not supported yet
* Assignment inside of an expression is not supported yet

## Data types

* Character types are not supported
* Type promotion on overflow is not supported
* Complex numbers are not supported
* Arbitrary precision integers are not supported
* 128-bit floating point values are not supported
* Objects and nested namespaces are not supported
* Sparse arrays are not supported yet

## Performance

* Fusion does not work with indexed arguments
* Some primitives are implemented on the CPU and will not perform well on the GPU
* Some primitives are GPU optimized and may not perform ideally on the CPU
* Fusion does not work over user-defined functions
* Scalar user-defined functions are not optimized and have overhead
* Only scalar function expressions are fused
