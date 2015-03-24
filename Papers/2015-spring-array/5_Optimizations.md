The optimizations currently implemented in the compiler focus on improving the results of financial simulation software, epitomized in the Black Scholes benchmark. This code contains mostly numerical calculations over large arrays, and in particular, scalar computations, instead of heavy manipulations of the shapes of arrays. We implement four major optimizations which significantly improve performance of the compiler.

## Scalar loop fusion

In APL, primitive scalar operations, such as addition or subtraction, operate point-wise over every scalar element in an array argument. In other words, there is an implicit map or fork over each element in an array (which can be nested) to compute addition or subtract on the individual scalar elements of the array. When strung together, as in the following example, the interpreter must iterate over the entire array multiple times:

    5+A×B

If arrays `A` or `B` are large, then these multiple iterations can eliminate the benefits of modern cache hierarchies. This results in poor scaling of the interpreter on these results to large simulations. What should be a near perfect scaling loses ground quickly compared to hand-written C code, despite the use of vectorized operations on the iterations.

The solution to this in the compiler is to recognize these loops and fuse them together. This is a well studied and difficult problem [Darte 2000] for languages like Fortrain, which use things like polyhedral models to fuse arbitrary loops. However, the situation is much better and simpler in APL, because we do not need to recognize explicit loops, but instead can take advantage of the implicit behavior of the scalars. This makes it much easier to recognize when it is safe to fuse these loops. We can thus guarantee that all scalar functions operating over the same set of data will be fused together into a single large loop. We base this fusion on whether two arrays are "shape-dependent" through a flow dependency in the code. 

This optimizations allows us to take advantage of modern cache architectures and to take advantage of other optimizations in vectorization engines available through lower level C and CUDA compilers. We can design these loops to ensure that they are vectorized and if the user desires, automatically parallelized. Generally, parallelization of this sorts works well on the GPU, but vectorization alone is usually better than multi-core parallelism with normal CPUs like the Intel i7 in our experience. 

## Function inlining and allocation

All functions are inlined when possible in the compiler. This is especially true for the operators which take functions as operands. By inlining these operations, it is often possible to reduce significant overheads involed in repeated iterations. Furthermore, becuase Dyalog APL does not permit functions to be returned as values, though they can be passed as operands to operators, there is no need to have a facility for creating closures, as in many other high-level functional programming languages. The current version of the compiler still creates some environments to hold some free variables in the compiler, but the next version of the compiler will be able to mostly eliminate additional environment overheads and almost completely eliminate function call overheads. 

## DWA as an optimization

While the above optimizations are fairly classical, the most surprising and significant optimization for our use case turned out to be the integration of DWA (Direct Workspace Access) [Dyalog 2014] into the compiler. In this case, the compiler operates directly over structures inside of the interpreter, completely eliminating copying and conversion overheads associated with calling foreign code from within the interpreter. Our use cases assume that the information expert will conduct most of their development through the interpereter, and use the compiler as a later optimization stage or to deploy. By eliminating the overhead for calling into foreign functions, we experienced the single largest performance increase among all of these optimizations and the environment in general. 


