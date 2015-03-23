## Hardware

We obtained the following benchmark results using an Intel Core i7-361
0QM @ 2.30GHz with 8 Hyperthreaded cores. The machine contains 16GB of RAM and an NVIDIA GTX 675M graphics card. Results were obtained with the 64-bit Linux version of Dyalog APL.

## Without Optimizations

The previous version of Co-dfns [citation] used its own internal representation for arrays that differed slightly in structure from that used by the Dyalog interpreter. It also did not include explicit inlining of primitives. It did use a reasonably efficient representation of functions, however. The compiler produced code for C and CUDA compilers. 

The CPU based code executed with speedups of roughly 20 - 30% as seen in [figures]. On the GPU, without some specific special implementations of certain parts of the code, the performance actually slightly degraded from the interpreter. However, with the appropriate primitives in place, the performance was the same as that of the CPU, around 20 - 30%. 

In fact, through exploration of various implementation techniques and analyzing the code, we discovered that the most we could expect from the compiler on these sorts of ideal scalar computations with the then-current architecture was about a 30% improvement over the interpreter. Even if the computation happened almost instantly, the cost of transferring data in and out of the interpreter overwhelmed every other runtime cost. Data copy overhead was simply too great.

Unfortunately, there is little way in which to support generalized array operations in and out of the interpreter without incurring these overheads if we wished to stay with our own representation of arrays.

## With Optimizations

In the next version of the compiler, we re-architected the design of the arrays to make use of Dyalog's DWA (Direct Workspace Access) infrastructure, which allows foreign code to operate over native interpreter structures. While somewhat more complicated then the normal FFI function interface, in our case, it provides significant benefits. By designing the compiler to operate over native Dyalog arrays instead of requiring a translation/conversion phase, we completely eliminate the overheads involved in transferring data in and out of the interpreter. When combined with the current optimizations that are in the compiler, including scalar function loop fusion and primitive inlining, we see performance improvements in the range of 50-90% on the CPU. In [figures] we include the alternative of using a handwritten C version of Black Scholes with the standard FFI interface in the Dyalog interpreter to compare the performance of hand-writing the code instead of using the Co-dfns compiler.

## Preliminary GPU results

While we do not have complete results for the GPU yet, we have evaluated the performance potential of the compiler with the DWA interface, and have seen performance in the range of 100 - 200× increase on our hardware compared to the interpreter. This comes close to the expected ideal performance on our graphics card with these problems, we are confident that our ongoing work to include additional optimizations and the new DWA-based architecture will permit information experts operating on large scalar domains to maximize their GPU's capabilities through Dyalog APL and Co-dfns without requiring any changes in their program code.

## Comparing to C

In [figures] the performance of the interpreter and the compiler appear in relation to hand written C code. The hand written C code simulates the process an information expert might use to optimize a particular piece of code that is going too slowly. That is, they would call out to a specific C library call to handle the inner loops, or they might write their own version in C or CUDA and then call into that code from the rest of the interpreter. The graphs here show the dangers of doing so. While the handwritten C code by itself would perform more quickly than the interpreter, it is difficult to use such code inside of an inner loop or just in a single "hot spot" because the overheads of getting data in and out of the foreign functions is too high. Thus, while the performance of the compiled code and the C code are not that far apart, the C code performs much worse in this use case because it does not integrate with the interpreter's data structures. 

An information expert could manually integrate with the interpreter using the same DWA API that Dyalog provides, but this greatly increases the complexity of the code and the overall interfaces, and makes it more difficult to use "off the shelf" tuned libraries. By using the compiler instead, this difficult work of hand-writing optimized code or linking into existing high-performance tuned libraries disappears and the compiler can be relied upon to produce code of similar performance, even using these tuned libraries underneath without any user intervention. 

