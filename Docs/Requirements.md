# Co-dfns Compiler Requirements

These requirements define the essential state of the system and the core 
behavior of the system in external terms. They intentionally avoid saying 
how something is achieved, but rather focus on what must be achieved for 
success. 

Good requirements should be independent of one another, and it should be clear 
and obvious when a requirement has or has not been met.

1. The compiler is packaged as a single workspace requiring no external 
   dependencies.
2. The compiler functions as a drop-in replacement for `⎕FIX`.
3. It should accept any valid dfns program.
4. If the compiler signals an error, that error must match the error the 
   interpreter would have given either at runtime or fix time.
5. The output of the compiler includes a C and a CUDA file.
6. A dfns program is considered invalid if the typeclass of a variable 
   changes within the code.
7. The function `Fix` implements the monadic form of `⎕FIX`.
8. A dfns program is invalid if it is not a namespace script.
9. A dfns script is invalid if it contains a free variable.
10. The function `Compile` takes a filename sans-extension as left argument 
    and a namespace script as right argument and returns the top-level 
    bindings and their type.
11. As a side-effect, `Compile` writes a CUDA and a C version of the namespace.
12. The compiler should support the `∥` operator. This operator expects to
    receive a function as its left operand and returns a function which 
    behaves in the exact same was as the function given by the left operand
    except that the value returned is a single-assignment array instead of a
    normal mutable array. The returned function will return immediately, 
    queuing the left operand function to run concurrently. The single 
    assignment array returned is assumed to be equivalent in the sense of `≡` 
    to the value returned by the left operand when applied with the same
    arguments. The single assignment array will be considered to have a 
    pending write operation queued based on the concurrently executing 
    left operand. When the queued left operand application finishes 
    executing, then at some point after this the data of that operand will be
    available as the single-assignment array. Until then the single-assignment
    array will be considered unassigned.
13. The constant `⌾` single-assignment empty array returns an empty vector 
    whose fill element is a single, un-assigned cell.
14. Any element in a single-assignment array may be assigned once and only 
    once.
15. Any attempt to read an un-assigned element of a single-assignment array
    will block, waiting for the array to be assigned; when assigned, the value
    assigned to the element will be returned.
16. The performance of the code should match or exceed handwritten C/CUDA code. 

