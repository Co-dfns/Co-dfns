Dyalog APL [Dyalog 2015] is a modern, interpreted language which follows in the tradition of APL systems by providing a "tool of thought" [Iverson 2007] that enables information experts to rapidly develop and explore solutions without requiring significant early investment in external software engineering resources. Its mathematically oriented language is concise and it encourages data exploration through array programming. The performance of the APL interpreter is surprisingly good, and many good applications have been designed that outperform more traditional systems by a large margin [Grosvenor 2013]. However, there are limitations to the performance of an interpreter.

The Co-dfns compiler project [Hsu 2014] is an effort to provide a highly integrated compiler into the Dyalog APL environment that enables turnkey performance for information experts using Dyalog APL, while retaining the rapid development environment that such experts prefer. In particular, we leverage the high-level nature of APL in order to deliver platform independent performance of data parallel applications, enabling information experts to scale their models written in APL to larger data sets and a wider array of hardware.

In addition to this, Co-dfns as a project hopes to expand and push the boundaries of what most users think of as "suitable" array programming domains. By implementing the compiler in a purely data-parallel fashion using nothing but the dfns APL dialect we demonstrate the feasability of writing a compiler in this fashion. Moreover, we demonstrate the effectiveness of this approach, as the compiler remains simple and direct, without complex encoding schemes. We also intend to demonstrate some of the benefits of using array programming for such software, including the increased parallelism and analysis opportunities that arise from the intentionally restricted and simplified language subset from which the compiler is constructed. 

Our recent efforts have delivered a completely data-parallel compiler modulo the parser (written using parser combinators) and some aspect of code generation. The compiler produces code that integrates directly with the Dyalog APL interpreter through the use of the DWA [Dyalog 2014] infrastructure. The performance of the code produced exceeds that of traditional hand-written C program integrated using the Dyalog APL foreign function interface alone, while also possessing platform independence, compiling to GPU and CPU targets from the same code, unmodified, with significant performance improvements in both cases. 

We make the following contributions:

* We describe the high-level architecture of a purely data-parallel compiler written without recursion, branching, or other complex control flow, providing a demonstration of the feasibility of such a compiler and the relative compactness and directness with which it can be written.

* We provide performance analysis of the costs of integrating foreign code into the Dyalog APL environment by comparing the performance of hand-written C code against the Co-dfns compiler, which integrates more completely with the host environment.

* We have built a compiler which delivers device independent performance gains in the range of 50 - 10,000% over the base interpreter by allowing unmodified APL programs to be compiled for the CPU and GPU. These gains are possible in part from the high-level nature of the APL language.

* We describe the set of optimizations necessary to deliver increased performance on scalar heavy computational code when written in APL and other array-oriented notations. 

* We make a small case for array programming as a compelling general purpose programming model which, given suitable discipline, provides benefits in terms of platform neutrality and complexity analysis.

