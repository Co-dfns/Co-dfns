# Co-dfns Compiler

## Synopsis

	target←<module name> codfns.Fix <namespace script>
	codfns.Compile 'file.apln'
	codfns.Exec 'file.apln'
	]codfns.compile <namespace> <target>
        (parent depth type kind name lex varbind src_start src_end) exports symbols source←codfns.PS 'line1' 'line2'
        (parent depth type kind name lex varbind src_start src_end) exports symbols source←codfns.PS 'source code...'

## Description

The Co-dfns compiler takes APL code in the dfns syntax and compiles it for use directly in the Dyalog APL interpreter or through a C API. It targets both CPU and GPU architectures and provides users with a straightforward means of running their APL as data-parallel code on vector hardware.

The compiler may be accessed either through the user-command functionality of Dyalog APL or through the namespace interface.

### User-Command Options

Argument  | Description
--------- | -----------
namespace | The name of a compilable namespace defined in the current workspace. The compiler will attempt to compile this namespace.
target    | The name the compiler should give to the compiled Co-dfns module. Upon compilation, a namespace called `<target>` will be created and linked to the compiled module.

### Namespace Options and Functions

Expression | Description
---------- | -----------
Fix        | The Fix function is the primary entry into the Co-dfns compiler. It takes a character vector on the left indicating the desired name of the compiled module and the namespace script to compile as the right argument. The format of the namespace script should correspond to the `⎕FIX` format. `Fix` returns a namespace linked to the compiled object.
Compile    | The `Compile` function takes a path to a file and compiles a standalone executable
Exec       | Runs the given file path by `Compile`-ing the code and then executing it via the shell
TK         | The Co-dfns tokenizing function. It takes a vector of character vectors containing a namespace script and tokenizes the code.
PS         | The Co-dfns parsing function. It takes the output of `TK` and parses the code into an AST.
AF∆PREFIX  | The location of the ArrayFire library installation for Linux/Mac platforms, used by MK∆RTM.
VERSION    | The version of the compiler. Do not modify this value.
VS∆PATH    | The path to your Microsoft Visual Studio installation

## Parser Return Structure

The Co-dfns parser returns a vector of 4 elements, the AST, module exports, symbol table, and the original parsed source.

Field   | Description
------- | -----------
AST     | The AST structure of the parsed tree
Exports | The names and types of the top-level exported bindings
Symbols | The set of unique names (character vectors) and values in the AST (symbols and numbers)
Source  | A character vector of the original parsed source

### AST Structure

A parsed AST is an inverted table of nodes containing the following columns. The nodes in the table are ordered according to their depth-first pre-order traversal.

Name    | Description
------- | ----------
parent  | The parent node of the node in the AST. Root nodes are their own parents.
depth   | The depth of the node in the AST. Root nodes are depth 0.
type    | The type of the node, as an index into the `N∆` constant.
kind    | The sub-type or kind of the node, as an integer.
name    | A positive integer referencing another node in the table or a negative index into the symbol table.
lex     | An indicator of the scope of a given variable/node
varbind | The binding site or definition of the current node
start   | The starting index into the source corresponding to this node.
end     | The exclusive ending index into the source corresponding to this node.

### Node Types and Kinds

type | kind   | name     | Children        | Description
---- | ------ | -------- | --------------- | -----------
A    | 0      | Symbol   | ---             | Niladic APL symbol
A    | 1      | Symbol   | ---             | Flat Literal; character or number
A    | 7      | ---      | Arr+            | Stranded array
B    | 1      | ---      | AV Arr          | Array Binding
B    | 2      | ---      | V Fun           | Function Binding
B    | 3      | ---      | V Mop           | Monadic Operator Binding
B    | 4      | ---      | V Dop           | Dyadic Operator Binding
C    | 1      | Symbol   | T V*            | Niladic Closure
C    | 2      | Symbol   | FT{1, 2} V*     | Function Closure
C    | 3      | Symbol   | FT{2, 4} V*     | Monadic Operator Closure
C    | 4      | Symbol   | FT{4, 8} V*     | Dyadic Operator Closure
E    | 1      | ---      | Fun Arr         | Monadic Expression
E    | 2      | ---      | Arr Fun Arr     | Dyadic Expression
E    | 4      | ---      | AENV Fun Arr    | Assignment Expression
E    | 6      | ---      | Arr+            | Bracket Expression ([...])
F    | 0      | Symbol   | ABCEGNOPV*[H]   | Namespace Module
F    | 2..15  | ---      | ABEGNPV*        | D-fn
G    | 0      | ---      | Arr Arr         | Guarded Expression
H    | 0..2*9 | 65536⊥NM | PV*             | Trad-fn Header NMSARLZXY
L    | 0      | Symbol   | ---             | Label
N    | 1      | ---      | Arr Arr         | Array Namespace Reference
N    | 2      | ---      | Arr Fun         | Function Namespace Reference
N    | 3      | ---      | Arr Mop         | Mon. Operator Namespace Ref.
N    | 4      | ---      | Arr Dop         | Dya. Operator Namespace Ref.
O    | 1      | ---      | Arr Mop         | Monadic Operator Expression
O    | 2      | ---      | Fun Mop         | Monadic Operator Expression
O    | 4      | ---      | Arr Dop Arr     | Dyadic Operator Expression
O    | 5      | ---      | Fun Dop Arr     | Dyadic Operator Expression
O    | 7      | ---      | Arr Dop Fun     | Dyadic Operator Expression
O    | 8      | ---      | Fun Dop Fun     | Dyadic Operator Expression
P    | 1      | Symbol   | ---             | Array Primitive
P    | 2      | Symbol   | ---             | Function Primitive
P    | 3      | Symbol   | ---             | Mon. Oper. Primitive
P    | 4      | Symbol   | ---             | Dya. Oper. Primitive
T    | 1..15  | Symbol   | HABCEGNOPV*     | Trad-fn
V    | 1      | Symbol   | ---             | Array Variable
V    | 2      | Symbol   | ---             | Function Variable
V    | 3      | Symbol   | ---             | Mon. Oper. Variable
V    | 4      | Symbol   | ---             | Dya. Oper. Variable
V    | 5      | Symbol   | ---             | Schizophrenic Variable
Z    | ¯2     | ---      | *               | Syntax Error

### Exports/Env structure

The exports produced by the parser is a two-column inverted table containing the following fields. This structure is the same for the exports returned from the parser as well as for the optional environment that can be passed to the parser to seed values into the environment used by the parser to lookup variables.

Name | Description
---- | -----------
name | The name of the binding as a character vector
type | The type of the binding as an integer (¯1: Unbound, 0: Ambiguous, 1: Array, 2: Function)

## Error Reporting

When the parser fails to successfully parse a given input source, the parser updates ⎕DMX and signals an appropriate error code. Additionally, it updates the `EN` and `DM` variables in the `codfns` namespace to reflect the error. See the official Dyalog APL documentation on `⎕EN` and `⎕DM` for information on the format of these variables.

## Files

The compiler produces a set of files for each compiled module. The specific files that are generated may differ based on platform, but the following files will always exist:

File                  | Description
--------------------- | -----------
module.log            | A log of the backend messages and compiler output, indicating any issues encountered during the compilation of the backend code.
module.{so,dll,dylib} | The shared object of the module.
module.c              | The generated intermediate source code for the module.
module{.exe}          | The executable generated by `Compile` and `Exec`

## Examples

Compile an empty namespace:

	ns←'gfx'codfns.Fix ':Namespace' ':EndNamespace'

Compile a namespace using the user-command:

	_←⎕NS⍬
	]compile _ ns

Compile a basic function to see the system working:

	ns←'test'codfns.Fix ':Namespace' 'F←{+⌿⍺+⍵}' ':EndNamespace'
	3 ns.F ⍳5

## See Also

Reference                                 | Description
----------------------------------------- | -----------
[help.dyalog.com](http://help.dyalog.com) | Documentation for the Dyalog language and systems.
[FAQ.md](FAQ.md)                          | Frequently asked questions about the compiler.
[PERFORMANCE.md](PERFORMANCE.md)          | Suggestions for understanding the performance of Co-dfns compiled code.

## Language Support

Generally speaking, Co-dfns works best if you focus on writing pure,
functional programs written in dfns that make limited use
of `:` or recursion and that use classic APL primitives (/ . ∘. and
so forth) over simple numeric arrays working over data sizes that
exceed 1 - 10 MB. While recursion and guards are supported, it is best if
you restrict their use to outer-most functions, since they are significantly
less efficient on the GPU than APL primitives.

We compile under the assumption that ⎕IO ⎕ML ⎕CT←0 1 0. 

### Known limitations

The following limitations are known to exist:

* Format (⍕) is only partially supported
* Modified bracket assignment does not support duplicate indices
* Structured Colon Statements are supported only in the parser
* Trad-fns support is limited to the parser
* Error Guards are not supported yet
* User-command interface does not work with namespace global variables
* We do not make DWA or C wrappers for User-defined operators
* Trains are not currently supported
* Binomial is not implemented correctly for some values
* Selective assignment is not supported yet
* Namespaces with free references are not supported yet
* Nested namespaces are not supported
* Branch (→) is not supported
* Spawn (&) is not supported
* 128-bit floating point values are not supported
* Variant (⍠) is not supported
* Inverse (⍣¯1) is not supported
* Execute (⍎) is not supported
* Only ⎕NC, ⎕SIGNAL, and ⎕DR are supported Dyalog system functions
* Objects/Classes are not supported in the system

## Authors

The Co-dfns compiler is primarily maintained, supported, and developed by Aaron W. Hsu.
