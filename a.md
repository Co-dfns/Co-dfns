# Abstract

Quick, how do you write a compiler without branching, conditionals, case
statements, or recursion?

The Co-dfns compiler transforms a parallel extension of the dfns dialect of
APL into C and CUDA code.  It targets the GPU as well as the CPU.  It also
pushes the assumptions of viable application domains for array programming. 
In particular, Co-dfns is implemented in the Co-dfns language.  Furthermore,
an explicit design aesthetic of the compiler style requires that, whenever
possible, all compiler passes have no conditionals, branching, or recursion
in their descriptions.  Surprisingly, not only can this be done, but the
resulting compiler exhibits both consision and simplicity.

Nearly the entire compiler, including the handling of lexical scope,
function lifting, and closure creation, contains no explicit branching,
traditional control structures, or recursion: each compiler pass contains a
simple data flow implementation with almost trivial control flow.  Using
traditional array programming concepts together with insights into how to
encode control flow information into simple data representations, The
Co-dfns compiler demonstrates a novel and interesting approach to compiler
implementation.
