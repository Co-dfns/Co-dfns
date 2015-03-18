# Title

Accelerating Information Experts through Compiler Design

# Abstract

Dyalog APL is a tool of thought for information experts, enabling rapid and 
effective development of domain-centric software without the costly software 
engineering feedback loop that is required for other programming environments. 
The interpreted nature of the Dyalog APL environment, however, introduces 
constraints on the performance characteristics of the system that hinders 
the rapid exploration and analysis of large data sets, especially on modern, 
highly-parallel computing architectures. The Co-dfns compiler project aims 
to greatly reduce the overheads involved in creating high-performance scalable 
code in APL. In particular, the compiler focuses on integrating with the 
environment already familiar to users of Dyalog APL. It compiles a familiar 
subset of the entire Dyalog APL language, and delivers significant performance 
improvements and platform independence to information experts without requiring 
them to rewrite or rework their code into another language. 

We discuss the design of the Co-dfns compiler, which is itself an APL program, 
and in particular, we discuss the unique implementation architecture that 
allows us to write the compiler without branching, recursion, or other complex 
forms of control flow, as well as the specific optimizations used to deliver 
performance on par with hand-written C code in the domain of financial 
simulations. We discuss preliminary results of platform independence that 
demonstrates significant performance independence of APL programs between 
traditional CPUs and GPU platforms, allowing information experts to take their 
code unmodified and obtain performance equivalent to handwritten C or CUDA 
code. We also discuss ongoing work to improve these numbers further, and 
improve the design of the compiler itself, with the eventual goal of expanding 
the domains for which array programming is not only a possible solution, but 
a compelling one as well.

