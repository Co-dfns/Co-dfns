# Co-Dfns Compiler

This is the developer's repository for the Co-Dfns compiler project. 
The Co-Dfns project aims to provide a high-performance, high-reliability 
compiler for a super-set of the Dyalog D-fns programming language. 
The D-fns language is a functionally oriented, lexically scoped dialect 
of APL. The Co-Dfns language extends the D-fns language to include 
explicit task parallelism with implicit structures for synchronization 
and determinism. The language is designed to enable rigorous formal 
analysis of programs to aid in compiler optimization and programmer 
productivity, as well as in the general reliability of the code itself.

## Overview of Directories

The following is an overview of each of the top-level directories in the 
project. 

src/

	Contains the primary sources and tests for the compiler and runtime.

isabelle/

	Contains the formal treatment of the Co-Dfns compiler and the environments 
	necessary for doing formal reasoning about Co-Dfns programs.

research/

	Contains copies of research papers and documents related to the 
	development of Co-Dfns

doc/

	Contains the project documentation in various forms.
