⍝ CoDfns Namespace: Increment 5

:Namespace CoDfns

  ⎕IO ⎕ML←0 1

⍝ Platform Configuration
⍝
⍝ The following variables must be set correctly for the appropriate platform

Target←'X86'
TargetTriple←'x86_64-slackware-linux-gnu'
CoDfnsRuntime←'runtime/libcodfns.so'
LLVMCore←'libLLVM-3.4.so'
LLVMExecutionEngine←'libLLVM-3.4.so'
LLVMX86Info←'libLLVM-3.4.so'
LLVMX86CodeGen←'libLLVM-3.4.so'
LLVMX86Desc←'libLLVM-3.4.so'

⍝ Fix
⍝
⍝ Intended Function: Accept a valid namespace script and return an
⍝ equivalent namespace script, possibly exporting a module at the same
⍝ time to the file named in the optional left argument.

Fix←{
  _←FFI∆INIT                           ⍝ Initialize FFI; Fix ← Yes
  ~1≡≢⍴⍵:⎕SIGNAL 11                    ⍝ Input is vector?
  ~∧/1≥≢∘⍴¨⍵:⎕SIGNAL 11                ⍝ Elements are vectors?
  ~∧/∊' '=(⊃0⍴⊂)¨⍵:⎕SIGNAL 11          ⍝ Elements are characters?
  ⍺←⊢ ⋄ obj←⍺⊣''                       ⍝ Identify Obj property
  IsFnb obj:⎕SIGNAL 11                 ⍝ Handle Fnb, Fnf, Fne stimuli
  mod nms←Compile ⍵                    ⍝ Get LLVM Module
  ns←nms ModToNS mod                   ⍝ Namespace to return
  ''≡obj:ns                            ⍝ No optional object file output
  ns⊣obj ModToObj mod                  ⍝ Export Mod to object file
}

⍝ IsFnb
⍝
⍝ Intended Function: Determine whether the given input is a valid
⍝ filename or not.

IsFnb←{
  ~(∧/∊' '=⊃0⍴⊂⍵)∧(1≡≢⍴⍵)∧(1≡≡⍵) ⍝ Is simple, character vector?
}

⍝ Compile
⍝
⍝ Intended Function: Compile the given Fix input into an LLVM Module.

Compile←{
  tks←Tokenize ⍵
  ast names←Parse   tks
  ast←KillLines     ast
  ast←DropUnreached ast
  ast←LiftConsts    ast
  ast←LiftBound     ast
  ast←AnchorVars    ast
  ast←LiftFuncs     ast
  ast←ConvPrims     ast
  mod←GenLLVM       ast
  mod names
}

⍝ ModToNS
⍝
⍝ Intended Function: Create an observationally equivalent namespace from
⍝ a given LLVM Module.

ModToNS←{
  ⎕NS⍬                                 ⍝ Create an Empty Namespace
  jc←1 ⍵ 0 1                           ⍝ Params: JIT Ov, Mod, OptLevel, Err Ov
  jc←CreateJITCompilerForModule jc     ⍝ Make JIT compiler
  0≠⊃jc:(ErrorMessage ⊃⌽jc)⎕SIGNAL 99  ⍝ Error handling, C style
  ee←1⊃jc                              ⍝ Extract exec engine on success
  syserr←{'FFI ERROR'⎕SIGNAL 99}
  fn←{                                 ⍝ Op to build ns functions
    0≠⊃zp←ffi_make_array 1,4⍴0:syserr⍬ ⍝ Temporary result array
    lp←(≢⍴⍺)(≢,⍺)(⍴⍺)(,⍺)              ⍝ Fields of left argument
    0≠⊃lp←ffi_make_array 1,lp:syserr⍬  ⍝ Array to match left argument
    rp←(≢⍴⍵)(≢,⍵)(⍴⍵)(,⍵)              ⍝ Fields of right argument
    0≠⊃rp←ffi_make_array 1,rp:syserr⍬  ⍝ Array to match right argument
    args←1⊃¨zp lp rp                   ⍝ Pass only the res, left and right args
    z←RunFunction ⍺⍺ ⍵⍵ 3 args         ⍝ Eval function in module
    z←GenericValueToInt z 1            ⍝ Get something we can use
    0≠z:⎕SIGNAL z                      ⍝ Signal an error if there is one
    res←ConvertArray ⊃args             ⍝ Convert result array
    _←array_free¨args                  ⍝ Free up the arrays
    _←free¨args                        ⍝ Free up the array headers
    res⊣DisposeGenericValue z          ⍝ Clean return value and return
  }
  fp←{                                 ⍝ Fn to get function pointer
    c fpv←FindFunction ee ⍵ 1          ⍝ Get function from LLVM Module
    0=c:fpv                            ⍝ Function pointer on success
    'FUNCTION NOT FOUND'⎕SIGNAL 99     ⍝ System error on failure
  }
  addf←{                               ⍝ Fn to insert func into namespace
    ∧/' '=⍵:0                          ⍝ No name is no-op
    f←ee fn (fp ⍵)                     ⍝ Get function
    0⊣⍎'Ns.',⍵,'←f ⋄ 0'                ⍝ Store function using do oper trick
  }
  ns⊣addf¨(2=1⌷⍉⍺)/0⌷⍉⍺                ⍝ Add all functions
}

⍝ ConvertArray
⍝
⍝ Intended Function: Convert an array from the Co-dfns compiler into an
⍝ array suitable for use in the Dyalog APL Interpreter.

ConvertArray←{
  s←ffi_get_size ⍵                     ⍝ Get the number of data elements
  d←ffi_get_data_int s ⍵               ⍝ We assume that we have only integer types
  r←ffi_get_rank ⍵                     ⍝ Get the number of shape elements
  p←ffi_get_shape r ⍵                  ⍝ Get the shapes
  p⍴d                                  ⍝ Reshape based on shape
}

⍝ ModToObj
⍝
⍝ Intended Function: Generate a compiled object to the file given the LLVM Module

ModToObj←{
  r err←PrintModuleToFile ⍵ ⍺ 1        ⍝ Print to the file given
  1=r:(ErrorMessage ⊃err)⎕SIGNAL 99    ⍝ And error out with LLVM errr on failure
  0 0⍴⍬                                ⍝ Best to return something that isn't seen
}

⍝ ErrorMessage
⍝
⍝ Intended Function: Return an array of the LLVM Error Message

ErrorMessage←{
  len←strlen ⍵                         ⍝ Length of C string
  res←cstring len ⍵ len                ⍝ Convert using memcpy
  res⊣DisposeMessage ⍵                 ⍝ Cleanup and return
}

⍝ Tokenize
⍝
⍝ Intended Function: Convert a vector of character vectors or scalars to a valid
⍝ AST with a Tokens root that is lexically equivalent modulo spaces.

Tokenize←{
  vc←'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'     ⍝ Upper case characters
  vc,←'abcdefghijklmnopqrstuvwxyz'     ⍝ Lower case characters
  vc,←'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß' ⍝ Accented upper case
  vc,←'àáâãäåæçèéêëìíîïðñòóôõöøùúûüþ'  ⍝ Accented lower case
  vc,←'∆⍙'                             ⍝ Deltas
  vc,←'ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ'     ⍝ Underscored alphabet
  vcn←vc,nc←'¯0123456789'              ⍝ Numbers
  tc←'←{}:⋄+-÷×|*⍟⌈⌊<≤=≠≥>⍺⍵⍴⍳,⌷¨'     ⍝ Single Token characters
  ac←vcn,' 	⍝⎕.',tc                ⍝ All characters
  ~∧/ac∊⍨⊃,/⍵:⎕SIGNAL 2                ⍝ Verify we have only good characters
  i←⍵⍳¨'⍝' ⋄ t←i↑¨⍵ ⋄ c←i↓¨⍵           ⍝ Divide into comment and code
  t←((⌽∘(∨\)∘⌽¨t)∧∨\¨t←' '≠t)/¨t       ⍝ Strip leading/trailing whitespace
  nsb←t∊':Namespace' ':EndNamespace'   ⍝ Mask of Namespace tokens
  nsl←nsb/t ⋄ nsi←nsb/⍳⍴t              ⍝ Namespace lines and indices
  ti←(~nsb)/⍳⍴t ⋄ t←(~nsb)/t           ⍝ Token indices and non ns tokens
  at←{2 2⍴'name'⍵'class' 'delimiter'}  ⍝ Fn for namespace attributes
  nsl←{,⊂2 'Token' '' (at ⍵)}¨nsl      ⍝ Tokenize namespace elements
  t←{                                  ⍝ Tokenize other tokens
    0=≢t:⍬                             ⍝ Special empty case
    t←{(m/2</0,m)⊂(m←' '≠⍵)/⍵}¨t       ⍝ Split on and remove spaces
    t←{(b∨2≠/1,b←⍵∊tc)⊂⍵}¨¨t           ⍝ Split on token characters
    t←{⊃,/(⊂⍬),⍵}¨t                    ⍝ Recombine lines
    lc←+/l←≢¨t                         ⍝ Token count per line and total count
    t←⊃,/t                             ⍝ Convert to single token vector
    fc←⊃¨t                             ⍝ First character of each token
    iv←(sv←fc∊vc,'⍺⍵')/⍳lc             ⍝ Mask and indices of variables
    ii←(si←fc∊nc)/⍳lc                  ⍝ Mask and indices of numbers
    ia←(sa←fc∊'←⋄:')/⍳lc               ⍝ Mask and indices of separators
    id←(sd←fc∊'{}')/⍳lc                ⍝ Mask and indices of delimiters
    ipm←(spm←fc∊'+-÷×|*⍟⌈⌊,⍴⍳')/⍳lc    ⍝ Mask and indices of monadic primitives
    iom←(som←fc∊'¨')/⍳lc               ⍝ Mask and indices of monadic operators
    ipd←(spd←fc∊'<≤=≠≥>⎕⌷')/⍳lc        ⍝ Mask and indices of dyadic primitives
    tv←1 2∘⍴¨↓(⊂'name'),⍪sv/t          ⍝ Variable attributes
    tv←{1 4⍴2 'Variable' '' ⍵}¨tv      ⍝ Variable tokens
    ncls←{('.'∊⍵)⊃'int' 'float'}       ⍝ Fn to determine Number class attr
    ti←{'value'⍵'class'(ncls ⍵)}¨si/t  ⍝ Number attributes
    ti←{1 4⍴2 'Number' '' (2 2⍴⍵)}¨ti  ⍝ Number tokens
    tpm←{1 2⍴'name' ⍵}¨spm/t           ⍝ Monadic Primitive name attributes
    tpm←{⍵⍪'class' 'monadic axis'}¨tpm ⍝ Monadic Primtiive class
    tpm←{1 4⍴2 'Primitive' '' ⍵}¨tpm   ⍝ Monadic Primitive tokens
    tom←{1 2⍴'name' ⍵}¨som/t           ⍝ Monadic Operator name attributes
    tom←{⍵⍪'class' 'operator'}¨tom     ⍝ Monadic Operator class
    tom←{1 4⍴2 'Primitive' '' ⍵}¨tom   ⍝ Monadic Operator tokens
    tpd←{1 2⍴'name' ⍵}¨spd/t           ⍝ Dyadic primitive name attributes
    tpd←{⍵⍪'class' 'dyadic axis'}¨tpd  ⍝ Dyadic primitive class
    tpd←{1 4⍴2 'Primitive' '' ⍵}¨tpd   ⍝ Dyadic primitive tokens
    ta←{1 2⍴'name' ⍵}¨sa/t             ⍝ Separator name attributes
    ta←{⍵⍪'class' 'separator'}¨ta      ⍝ Separator class
    ta←{1 4⍴2 'Token' '' ⍵}¨ta         ⍝ Separator tokens
    td←{1 2⍴'name' ⍵}¨sd/t             ⍝ Delimiter name attributes
    td←{⍵⍪'class' 'delimiter'}¨td      ⍝ Delimiter class attributes
    td←{1 4⍴2 'Token' '' ⍵}¨td         ⍝ Delimiter tokens
    t←tv,ti,tpm,tom,tpd,ta,td          ⍝ Reassemble tokens
    t←t[⍋iv,ii,ipm,iom,ipd,ia,id]      ⍝ In the right order
    t←(⊃,/l↑¨1)⊂t                      ⍝ As vector of non-empty lines of tokens
    t←t,(+/0=l)↑⊂⍬                     ⍝ Append empty lines
    t[⍋((0≠l)/⍳⍴l),(0=l)/⍳⍴l]          ⍝ Put empty lines where they belong
  }⍬
  t←(nsl,t)[⍋nsi,ti]                   ⍝ Add the Namespace lines back
  t←c{                                 ⍝ Wrap in Line nodes
    ha←1 2⍴'comment' ⍺                 ⍝ Head comment
    h←1 4⍴1 'Line' '' ha               ⍝ Line node
    0=≢⍵:h ⋄ h⍪⊃⍪/⍵                    ⍝ Wrap it
  }¨t
  0 'Tokens' '' MtA⍪⊃⍪/t               ⍝ Create and return tokens tree
}

⍝ Utility Constants

MtA←0 2⍴⊂''                            ⍝ An empty attribute table for AST
MtAST←0 4⍴0 '' '' MtA                  ⍝ An empty AST
MtNTE←0 2⍴'' 0                         ⍝ An Empty (Name, Type) Environment

⍝ Utility Functions

⍝ Attr Prop AST: A vector of the values of a specific attribute
⍝
⍝ Prop is used to take an AST (⍵) and extract the values of
⍝ an attribute (⍺) from all the nodes in the AST. It returns a
⍝ vector of these values.

Prop←{(¯1⌽P∊⊂⍺)/P←(⊂''),,↑⍵[;3]}

⍝ AST ByElem NodeName: All nodes of the AST named NodeName
⍝
⍝ ByElem extracts a matrix of all the nodes of the AST (⍺)
⍝ by the node name (⍵).

ByElem←{(⍺[;1]∊⊂⍵)⌿⍺}

⍝ AST ByDepth Depth: All nodes of a specific depth
⍝
⍝ ByDepth obtains a matrix of all the nodes of the AST (⍺)
⍝ that have a given depth (⍵).

ByDepth←{(⍵=⍺[;0])⌿⍺}

⍝ Name Bind AST: Take the root node and attach a new name to it
⍝
⍝ Bind describes an AST (⍵) adjusted to include Name (⍺) as another
⍝ name in the 'name' attribute of the node.

Bind←{
  Ni←(A←0⌷⍉⊃0 3⌷Ast←⍵)⍳⊂'name'
  Ni≥⍴A:Ast⊣(⊃0 3⌷Ast)⍪←'name' ⍺
  Ast⊣((0 3)(Ni 1)⊃Ast){⍺,⍵,⍨' ' ''⊃⍨0=⍴⍺}←⍺
}

⍝ Comment: Currently stubbed out

Comment←{⍺}

⍝ Env VarType Var: Type of Var in Env
⍝
⍝ Gives back the type of a variable in the environment

VarType←{(⍺[;1],0)[⍺[;0]⍳⊂⍵]}

⍝ Depth Kids Ast: Children of root node of AST
⍝
⍝ Obtain subtrees of a depth relative to the depth
⍝ of the first node of the tree.

Kids←{((⍺+⊃⍵)=0⌷⍉⍵)⊂[0]⍵}

⍝ Fn Eachk AST: Each over children
⍝
⍝ Applies (cid Fn kid) where cid is the child id (1-based) and
⍝ kid is a member of 1 Kids ⍵.

Eachk←{
  km←+\(⊃=⊢)0⌷⍉k←1↓⍵ ⍝ Map of children
  (1↑⍵)⍪⊃⍪/km(⊂⍺⍺)⌸k ⍝ Must enclose the intermediate results
}

⍝ map f Sel g Sel h arg: case selection
⍝
⍝ Utility from Phil Last for doing case selection based on a
⍝ boolean map to choose which function to apply to arg.

Sel←{~∨/⍺:⍵ ⋄ g←⍵⍵⍣(⊢/⍺) ⋄ 2=⍴⍺:⍺⍺⍣(⊣/⍺)g ⍵ ⋄ (¯1↓⍺)⍺⍺ g ⍵}

⍝ Split str: Split name list on spaces

Split←' '∘((≠(/∘⊢)1,1↓¯1⌽=)⊂≠(/∘⊢)⊢)

⍝ Parse
⍝
⍝ Intended Function: Convert a Tokens AST to a Namespace AST that is
⍝ structurally equivalent and that preserves comments and line counts.
⍝ Provide a table of the top-level name bindings and their types.

Parse←{
  0=+/⍵[;1]∊⊂'Token':⎕SIGNAL 2         ⍝ Deal with Eot Stimuli, Table 233
  fl←⊃1 ¯1⍪.↑⊂⍵ ByDepth 2              ⍝ First and last leafs
  ~fl[;1]∧.≡⊂'Token':⎕SIGNAL 2         ⍝ Must be tokens
  nms←':Namespace' ':EndNamespace'     ⍝ Correct names of first and last
  ~nms∧.≡'name' Prop fl:⎕SIGNAL 2      ⍝ Verify correct first and last
  n←'name' Prop ⍵ ByElem 'Token'       ⍝ Verify that the Nss and Nse
  2≠+/n∊nms:⎕SIGNAL 2                  ⍝ Tokens never appear more than once
  ns←0 'Namespace' '' (1 2⍴'name' '')  ⍝ New root node is Namespace
  ns⍪←⍵⌿⍨~(⍳≢⍵)∊(0,⊢,¯1+⊢)⍵⍳fl         ⍝ Drop Nse and Nss Tokens
  tm←(1⌷⍉ns)∊⊂'Token'                  ⍝ Mask of Tokens
  sm←tm\('name'Prop tm⌿ns)∊⊂,'⋄'       ⍝ Mask of Separators
  (sm⌿ns)←1 'Line' '' MtA⍴⍨4,⍨+/sm     ⍝ Replace separators by lines, Tbl 219
    ⍝ XXX: The above does not preserve commenting behavior
  tm←(1⌷⍉ns)∊⊂'Token'                  ⍝ Update token mask
  fm←(,¨'{}')⍳'name'Prop tm⌿ns         ⍝ Which tokens are braces?
  fm←fm⊃¨⊂1 ¯1 0                       ⍝ Convert } → ¯1; { → 1; else → 0
  0≠+/fm:⎕SIGNAL 2                     ⍝ Verify balance
  (0⌷⍉ns)+←2×+\0,¯1↓fm←tm\fm           ⍝ Push child nodes 2 for each depth
  ns fm←(⊂¯1≠fm)⌿¨ns fm                ⍝ Drop closing braces
  fa←1 2⍴'class' 'ambivalent'          ⍝ Function attributes
  fn←(d←fm/0⌷⍉ns),¨⊂'Function' '' fa   ⍝ New function nodes
  fn←fn,[¯0.5]¨(1+d),¨⊂'Line' '' MtA   ⍝ Line node for each function
  hd←(~∨\fm)⌿ns                        ⍝ Unaffected areas of ns
  ns←hd⍪⊃⍪/fn(⊣⍪1↓⊢)¨fm⊂[0]ns          ⍝ Replace { with fn nodes
  k←1 Kids ns                          ⍝ Children to examine
  env←⊃ParseFeBindings/k,⊂MtNTE        ⍝ Initial Fe bindings to feed in
  sd←MtAST env                         ⍝ Seed is an empty AST and the env
  ast env←⊃ParseTopLine/⌽(⊂sd),k       ⍝ Parse each child top down
  ((1↑ns)⍪ast)env                      ⍝ Return assembled AST and env
}

⍝ ParseFeBindings
⍝
⍝ Intended Function: Describe an set of bindings which is an extension of
⍝ given binding and any function bindings introduced by the given
⍝ AST top-level line.

ParseFeBindings←{
  1=≢⍺:⍵                               ⍝ Nothing on the line, done
  fp←'Function' 'Primitive'            ⍝ Looking for Functions and Prims
  ~fp∨.≡⊂0(0 1)⊃⌽k←1 Kids ⍺:⍵          ⍝ Not a function line, done
  ok←⊃⍪/¯1↓k                           ⍝ Other children
  tm←(1⌷⍉ok)∊⊂'Token'                  ⍝ Mask of all Tokens
  tn←'name'Prop tm⌿ok                  ⍝ Token names
  ~∧/tn∊⊂,'←':⎕SIGNAL 2                ⍝ Are all tokens assignments?
  ∨/0=2|tm/⍳≢ok:⎕SIGNAL 2              ⍝ Are all tokens separated correctly?
  vm←(1⌷⍉ok)∊⊂'Variable'               ⍝ Mask of all variables
  vn←'name'Prop vm⌿ok                  ⍝ Variable names
  ∨/0≠2|vm/⍳≢ok:⎕SIGNAL 2              ⍝ Are all variables before assignments?
  ~∧/vm∨tm:⎕SIGNAL 2                   ⍝ Are there only variables, assignments?
  ⍵⍪⍨2,⍨⍪vn                            ⍝ We're good, return new environment
}

⍝ ParseTopLine
⍝
⍝ Intended Function: Given a Top-level Line sub-tree as the left argument,
⍝ and an code block and environment as the right, parse the sub-tree into
⍝ one of Expression, Function, or FuncExpr sub-tree at the same depth and
⍝ attach it to the existing code block, updating the environment if
⍝ appropriate.

ParseTopLine←{cod env←⍵ ⋄ line←⍺
  1=≢⍺:(cod⍪⍺)env                      ⍝ Empty lines, do nothing
  cmt←⊃'comment' Prop 1↑⍺              ⍝ We need the comment for later
  eerr ast ne←env ParseExpr 1↓⍺        ⍝ Try to parse as expression first
  0=eerr:(cod⍪ast Comment cmt)ne       ⍝ If it works, extend and replace
  err ast←env 0 ParseLineVar 1↓⍺       ⍝ Try to parse as variable prefixed line
  0=⊃err:(cod⍪ast Comment cmt)env      ⍝ It worked, good
  ferr ast rst←env ParseFuncExpr 1↓⍺   ⍝ Try to parse as a function expression
  0=⊃ferr:(cod⍪ast Comment cmt)env     ⍝ It worked, extend and replace
  ¯1=×err:⎕SIGNAL eerr                 ⍝ Signal expr error if it seems good
  ⎕SIGNAL err                          ⍝ Otherwise signal err from ParseLineVar
}

⍝ ParseLineVar
⍝
⍝ Intended Function: Process variable stimuli that can occur when processing a
⍝ top-level line.
⍝
⍝ The first element of the output vector is a number indicating the error that was
⍝ received. It will return a negative number in the case where it thinks that the
⍝ errors of previously parsed recursive stimuli is better than the current error,
⍝ and a positive value whenever it wants to return a very specific error code.
⍝ It will return zero in the case that the parsing has succeeded.
⍝
⍝ The process of parsing out a variable assignment appears in a few locations
⍝ so it makes a bit of sense to encapsulate this process into a single function.
⍝ Indeed, the basic process is exactly the same, but depending on the starting
⍝ state, the transitions (read, function calls) are slightly different. In particular,
⍝ the transitions from an unbound variable depends on whether we have seen a
⍝ bound variable already or not. To handle this, we admit a "state class"
⍝ argument as the second element of the left argument vector.
⍝
⍝ State Class 0: Value ← EMPTY ⋄ Named ← EMPTY
⍝ State Class 1: Value ← EMPTY ⋄ Named ← BOUND
⍝
⍝ Right Argument: Matrix of Token and Function nodes
⍝ Left Argument: ([name,type] environment)(Parser state class)
⍝ Output: (Success/Failure)(Empty Line, Expression, Function, or FuncExpr)

ParseLineVar←{env cls←⍺
  '←'≡⊃'name'Prop 1↑⍵:2 MtAST          ⍝ No variable named, syntax error
  3>⊃⍴⍵:¯1 MtAST                       ⍝ Valid cases have at least three nodes
  tk←'Variable' 'Token'                ⍝ First two tokens should be Var and Tok
  ~tk∧.≡(0 1)1⌷⍵:¯1 MtAST              ⍝ If not, bad things
  (,'←')≢⊃'name'Prop 1↑1↓⍵:¯1 MtAST    ⍝ 2nd node is assignment?
  vn←⊃'name'Prop 1↑⍵                   ⍝ Name of the variable
  tp←env VarType vn                    ⍝ Type of the variable: Vfo or Vu?
  t←(0=tp)∧(cls=0)                     ⍝ Class zero with Vu?
  t:0,⊂vn env ParseNamedUnB 2↓⍵        ⍝ Then parse as unbound
  t←(2 3 4∨.=tp)∨(0=tp)∧(cls=1)        ⍝ Vfo or unbound with previous Vfo seen?
  t:0,⊂vn 2 env ParseNamedBnd 2↓⍵      ⍝ Then parse as bound to Fn
    ⍝ XXX: Right now we assume that we have only types of 2, or Fns.
    ⍝ In the future, change this to adjust for other nameclasses.
  ¯1 MtAST                             ⍝ Not a Vfo or Vu; something is wrong
}

⍝ ParseNamedUnB
⍝
⍝ Intended Function: Parse an assignment to an unbound variable as a
⍝ FuncExpr node.
⍝
⍝ Right Argument: Non-empty matrix of Token and Function nodes
⍝ Left Argument: Variable Name, [Name,Type] Environment
⍝ Output: FuncExpr Node

ParseNamedUnB←{vn env←⍺
  err ast←env 0 ParseLineVar ⍵         ⍝ Else try to parse as a variable line
  0=err:vn Bind ast                    ⍝ that worked, so bind it
  ferr ast rst←env ParseFuncExpr ⍵     ⍝ Try to parse as a FuncExpr
  0=ferr:vn Bind ast                   ⍝ It worked, bind it to vn
  ¯1=×err:⎕SIGNAL ferr                 ⍝ Signal FuncExpr error if suggested
  ⎕SIGNAL err                          ⍝ Otherwise signal Variable line error
}

⍝ ParseNamedBnd
⍝
⍝ Intended Function: Parse an assignment to a bound variable as a
⍝ FuncExpr node.
⍝
⍝ Right Argument: Non-empty matrix of Token and Function nodes
⍝ Left Argument: Variable Name, Variable Type, [Name,Type] Environment

ParseNamedBnd←{vn tp env←⍺
  0=⊃env ParseExpr ⍵:⎕SIGNAL 2         ⍝ Should not be an Expression
  tp≠t←2:⎕SIGNAL 2                     ⍝ The types must match to continue
  err ast←env 1 ParseLineVar ⍵         ⍝ Try to parse as a variable line
  0=err:vn Bind ast                    ⍝ If it succeeds, Bind and return
  ferr ast rst←env ParseFuncExpr ⍵     ⍝ Try to parse as a FuncExpr
  (0=ferr)∧tp=t:vn Bind ast            ⍝ If it works, bind it and return
  t←(1=≢⍵)∧('Variable'≡⊃0 1⌷⍵)         ⍝ Do we have only a single var node?
  t∧←0=env VarType⊃'name'Prop 1↑⍵      ⍝ And is it unbound?
  t:⎕SIGNAL 6                          ⍝ Then signal a value error for unbound
  ¯1=×err:⎕SIGNAL ferr                 ⍝ Signal FuncExpr error if suggested
  ⎕SIGNAL err                          ⍝ Else signal variable line error
}

⍝ ParseExpr
⍝
⍝ Intended Function: Take an environment and a set of tokens
⍝ and parse it as an expression, returning an error code, ast, and a new,
⍝ updated environment of types.

ParseExpr←{
  0=⊃⍴⍵:2 MtAST ⍺                      ⍝ Empty expressions are errors
  2::2 MtAST ⍺                         ⍝ Allow instant exit while parsing
  6::6 MtAST ⍺
  11::11 MtAST ⍺
  at←1 2⍴'class' 'atomic'              ⍝ Literals become atomic expressions
  n←(d←⊃⍵)'Expression' '' at           ⍝ One node per group of literals
  p←2</0,m←(d=0⌷⍉⍵)∧(1⌷⍉⍵)∊⊂'Number'   ⍝ Mask and partition of literals
  (0⌷⍉m⌿e)+←1⊣e←⍵                      ⍝ Bump the depths of each literal
  e←⊃⍪/(⊂MtAST),(⊂n)⍪¨p⊂[0]e           ⍝ Add expr node to each literal group
  e←((~∨\p)⌿⍵)⍪e                       ⍝ Attach anything before first literal
  dwn←{a⊣(0⌷⍉a)+←1⊣a←⍵}                ⍝ Fn to push nodes down the tree
  at←1 2⍴'class' 'monadic'             ⍝ Attributes for monadic expr node
  em←d 'Expression' '' at              ⍝ Monadic expression node
  at←1 2⍴'class' 'dyadic'              ⍝ Attributes for dyadic expr node
  ed←d 'Expression' '' at              ⍝ Dyadic expression node
  at←1 2⍴'class' 'ambivalent'          ⍝ Attributes for operator-derived Fns
  feo←d 'FuncExpr' '' at               ⍝ Operator-derived Functions
  e ne _←⊃{ast env knd←⍵               ⍝ Process tokens from bottom up
    e fe rst←env ParseFuncExpr ⍺       ⍝ Try to parse as a FuncExpr node first
    (0⌷⍉fe)+←1                         ⍝ Bump up the FuncExpr depth to match
    k←(e=0)⊃⍺ fe                       ⍝ Kid is Fe if parsed, else existing kid
    tps←'Expression' 'FuncExpr'        ⍝ Types of nodes
    tps,←'Token' 'Variable'
    typ←tps⍳0 1⌷k                      ⍝ Type of node we're dealing with
    nm←⊃'name'Prop 1↑k                 ⍝ Name of the kid, if any
    k←(typ=3)⊃k(n⍪dwn k)               ⍝ Wrap the variable if necessary
    c←knd typ                          ⍝ Our case
    c≡0 0:(k⍪ast) env 1                ⍝ Nothing seen, Expression
    c≡0 1:⍎'⎕SIGNAL 2'                 ⍝ Nothing seen, FuncExpr
    c≡0 2:⍎'⎕SIGNAL 2'                 ⍝ Nothing seen, Assignment
    c≡0 3:(k⍪dwn ast) env 1            ⍝ Nothing seen, Variable
    c≡1 0:⍎'⎕SIGNAL 2'                 ⍝ Expression seen, Expression
    c≡1 1:(em⍪dwn k⍪ast) env 2         ⍝ Expression seen, FuncExpr
    c≡1 2:ast env 3                    ⍝ Expression seen, Assignment
    c≡1 3:⍎'⎕SIGNAL 2'                 ⍝ Expression seen, Variable
    op←'operator'≡⊃'class'Prop 1↑1↓ast ⍝ Is class of kid ≡ operator?
    mko←{dwn feo⍪(dwn k)⍪2↑1↓ast}      ⍝ Fn to make the FuncExpr node
    op∧c≡2 0:(em⍪(mko⍬)⍪3↓ast)env 2    ⍝ FuncExpr seen, Operator, Expression
    c≡2 0:(ed⍪(dwn k)⍪1↓ast)env 2      ⍝ FuncExpr seen, Expression
    op∧c≡2 1:(em⍪(mko⍬)⍪3↓ast)env 2    ⍝ FuncExpr seen, Operator, FuncExpr
    c≡2 1:(em⍪dwn k⍪ast) env 2         ⍝ FuncExpr seen, FuncExpr
    op∧c≡2 2:⍎'⎕SIGNAL 2'              ⍝ FuncExpr seen, Operator, Assignment
    c≡2 2:ast env 3                    ⍝ FuncExpr seen, Assignment
    op∧c≡2 3:(em⍪(mko⍬)⍪3↓ast)env 2    ⍝ FuncExpr seen, Operator, Variable
    c≡2 3:(ed⍪(dwn k)⍪1↓ast)env 1      ⍝ FuncExpr seen, Variable
    c≡3 0:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, Expression
    c≡3 1:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, FuncExpr
    c≡3 2:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, Assignment
    c≡3 3:(nm Bind ast)((nm 1)⍪env)1   ⍝ Assignment seen, Variable
    ⎕SIGNAL 99                         ⍝ Unreachable
  }/(0 Kids e),⊂MtAST ⍺ 0
  (0⌷⍉e)-←1                            ⍝ Push the node up to right final depth
  0 e ne                               ⍝ Return the expression and new env
}

⍝ ParseFuncExpr
⍝
⍝ Intended Function: Take an environment of types and a set of tokens
⍝ and parse it as a function expression, returning an error code, ast,
⍝ and the rest of the unparsed tokens.

ParseFuncExpr←{
  at←{2 2⍴'class' ⍵ 'equiv' ⍺}         ⍝ Fn to build fn attributes
  fn←(¯1+⊃⍵)∘{⍺'FuncExpr' '' ⍵}        ⍝ Fn to build FuncExpr node
  pcls←{(~∨\' '=C)/C←⊃'class'Prop 1↑⍵} ⍝ Fn to get class of Primitive node
  nm←⊃'name'Prop 1↑⍵                   ⍝ Name of first node
  isp←'Primitive'≡⊃0 1⌷⍵               ⍝ Is the node a primitive?
  isp:0((fn nm at pcls ⍵)⍪1↑⍵)(1↓⍵)    ⍝ Yes? Use that node.
  isfn←'Variable'≡⊃0 1⌷⍵               ⍝ Do we have a variable
  isfn∧←2=⍺ VarType nm                 ⍝ that refers to a function?
  fnat←'' at 'ambivalent'              ⍝ Fn attributes for a variable
  isfn:0((fn fnat)⍪1↑⍵)(1↓⍵)           ⍝ If function variable, return
  err ast rst←⍺ ParseFunc ⍵            ⍝ Try to parse as a function
  0=err:0(ast⍪⍨fn at⍨'ambivalent')rst  ⍝ Use ambivalent class if it works
  2 MtAST ⍵                            ⍝ Otherwise, return error
}

⍝ ParseFunc
⍝
⍝ Intended Function: Take an environment and set of tokens/Function Nodes,
⍝ and parse them as n user-define dambivalent function, monadic, or
⍝ dyadic operator, returning an error code, ast, and the rest of the
⍝ input.

ParseFunc←{
  'Function'≢⊃0 1⌷⍵:2 MtAST ⍵          ⍝ Must have a Function node first
  fn←(fm←1=+\(fd←⊃⍵)=d←0⌷⍉⍵)⌿⍵         ⍝ Get the Function node, mask, depths
  en←⍺⍪⍨1,⍨⍪,¨'⍺⍵'                     ⍝ Extend current environment with ⍺ & ⍵
  sd←MtAST en                          ⍝ Seed value
  cn←1 Kids fn                         ⍝ Lines of Function node
   2:: 2 MtAST ⍵                       ⍝ Handle parse errors
  11::11 MtAST ⍵                       ⍝ by passing them up
  tr en←⊃ParseFnLine/⌽(⊂sd),cn         ⍝ Parse down each line
  0((1↑fn)⍪tr)((~fm)⌿⍵)                ⍝ Newly parsed function, rest of tokens
}

⍝ ParseFnLine
⍝
⍝ Intended Function: Given a Function Line sub-tree and a pair of already
⍝ parsed code with an environment, parse the sub-tree into one of
⍝ Expression, FuncExpr, Condition, or Guard sub-tree at the same depth,
⍝ returning the extended code and a new environment.

ParseFnLine←{cod env←⍵
  1=⊃⍴⍺:(cod⍪⍺)env                     ⍝ Do nothing for empty lines
  cmt←⊃'comment' Prop 1↑⍺              ⍝ Preserve the comment for attachment
  cm←{(,':')≡⊃'name'Prop 1↑⍵}¨1 Kids ⍺ ⍝ Mask of : stimuli, to check for branch
  1<cnd←+/cm:⎕SIGNAL 2                 ⍝ Too many : tokens
  1=1⌷cm:⎕SIGNAL 2                     ⍝ Empty test clause
  splt←{1↓¨(1,1↓cm)⊂[0]⍵}              ⍝ Fn to split on : token, drop excess
  1=cnd:⊃cod env ParseCond/splt ⍺      ⍝ Condition found, parse it
  err ast ne←env ParseExpr 1↓⍺         ⍝ Expr is the last non-error option
  0=err:(cod⍪ast)ne                    ⍝ Return if it worked
  ⎕SIGNAL err                          ⍝ Otherwise error the expr error
}

⍝ ParseCond
⍝
⍝ Intended Function: Construct a Condition node from two expressions
⍝ representing a conditional line in a function body, receiving as an
⍝ operand the current code to extend and an environment, and returning
⍝ the newly extended code and a new environment.

ParseCond←{cod env←⍺⍺
  err ast ne←env ParseExpr ⍺           ⍝ Try to parse the test expression 1st
  0≠err:⎕SIGNAL err                    ⍝ Parsing test expression failed
  (0⌷⍉ast)+←1                          ⍝ Bump test depth to fit in condition
  m←(¯1+⊃⍺)'Condition' '' MtA          ⍝ We're returning a condition node
  0=≢⍵:(cod⍪m⍪ast)ne                   ⍝ Emtpy consequent expression
  err con ne←ne ParseExpr ⍵            ⍝ Try to parse consequent
  0≠err:⎕SIGNAL err                    ⍝ Failed to parse consequent
  (0⌷⍉con)+←1                          ⍝ Consequent depth jumps as well
  (cod⍪m⍪ast⍪con)ne                    ⍝ Condition with conseuqent and test
}

⍝ KillLines
⍝
⍝ Intended Function: Eliminate all semantically irrelevant lines from AST
⍝ to create an AST suitable for compiling.

KillLines←{(~⍵[;1]∊⊂'Line')⌿⍵}

⍝ DropUnreached
⍝
⍝ Intended Function: Simplify functions by removing code in function
⍝ bodies after a return expression (unnamed expression).

DropUnreached←{
  u←(0=∘≢('name'∘Prop 1∘↑))¨           ⍝ (u k) gives map of unnamed exprs
  d←(~(∨\0,1↓¯1⌽u))(/∘⊢)⊢              ⍝ (d k) drops kids after 1st unnamed ex
  f←'Function'≡(⊃0 1∘⌷)                ⍝ (f n) tests if n is function node
  0=≢k←1 Kids ⍵:⍵                      ⍝ Terminate at leaves
  (1↑⍵)⍪⊃⍪/∇¨d⍣(f ⍵)⊢k                 ⍝ Recur after dropping unnamed exprs
}

⍝ LiftConsts
⍝
⍝ Intended Function: Lift all literal expressions to the top level.

LiftConsts←{
  I←¯1 ⋄ mkv←{'LC',⍕I⊣(⊃I)+←1}         ⍝ New variable maker
  at←{2 2⍴'name' ⍵ 'class' ⍺}          ⍝ Attribute maker
  ns←'Expression' 'Number'             ⍝ Nodes we care about
  e l←((1⌷⍉a←⍵)∊⊂)¨ns                  ⍝ All Expr and Number nodes
  v←mkv¨⍳+/s←2</0,l                    ⍝ Variables we need; start of literals
  hn←1⌷⍉h←(l∨e∧1⌽l)⌿a                  ⍝ Literal Expressions and node names
  vn←{'Variable' '' ('array' at ⍵)}    ⍝ Variable node maker sans depth
  a[s/⍳⊃⍴a;1+⍳3]←↑vn¨v                 ⍝ Replace starting lits with variables
  a←(s∨~l)⌿a                           ⍝ Remove all non-first literals
  h[(i←{(hn∊⊂⍵)/⍳⊃⍴h})1⊃ns;0]←2        ⍝ Literal depths are all 2
  h[i⊃ns;0 3]←1,⍪'atomic'∘at¨v         ⍝ Litexprs are depth 1, with new names
  (1↑a)⍪h⍪1↓a                          ⍝ Connect root, lifted with the rest
}

⍝ LiftBound
⍝
⍝ Intended Function: Lift all assignments to the root of their scope.

LiftBound←{
  vex←{                                ⍝ Function to make var expr
    at←2 2⍴'name' ⍵ 'class' 'array'    ⍝ Variable name is right argument
    v←1 4⍴(1+⍺)'Variable' '' at        ⍝ Variable node, depth in left argument
    at←1 2⍴'class' 'atomic'            ⍝ Expression is atomic
    e←1 4⍴⍺ 'Expression' '' at         ⍝ Expression node has no name
    e⍪v                                ⍝ Give valid AST as result
  }
  lft←{                                ⍝ Function to lift expression
    cls←⊃'class'Prop ⍵                 ⍝ Class determines handling
    'atomic'≡cls:MtAST ⍵               ⍝ Nothing to do for atomic
    ri←1+'monadic' 'dyadic'⍳⊂cls       ⍝ Location of the right argument
    lf ex←⍺ ∇ ri⊃k←1 Kids ⍵            ⍝ Lift the right argument
    nm←⊃'name'Prop 1↑ex                ⍝ Consider right argument name
    nr←⊃⍪/¯1↓k                         ⍝ Our not right arguments to recombine
    ∧/' '=nm:lf((1↑⍵)⍪nr⍪ex)           ⍝ When unnamed, do nothing
    ex[;0]-←(⊃ex)-⍺                    ⍝ When named, must lift
    ne←(1↑⍵)⍪nr⍪(1+⊃⍵)vex nm           ⍝ Replace right with variable reference
    (lf⍪ex)(ne)                        ⍝ New lifted exprs and new node
  }
  atm←{                                ⍝ Fn to atomize test expression
    cls←⊃'class'Prop 1↑te←⍵            ⍝ Class of test expression
    'atomic'≡cls:MtAST ⍵               ⍝ Do nothing if atomic already
    te[;0]-←1                          ⍝ Test expression is going up
    nm←⊃'class'Prop 1↑⍵                ⍝ Name of test expression
    ∨/' '≠nm:te((⊃⍵)vex ⊃Split nm)     ⍝ Already named, return with vex
    ('tst'Bind te)((⊃⍵)vex'tst')       ⍝ Use temporary name otherwise
  }
  cnd←{                                ⍝ Function to handle condition nodes
    te←⊃k←1 Kids ⍵                     ⍝ We care especially about the test expr
    lf1 te←(⊃⍵)lft te                  ⍝ Lift test children, before cond
    lf2 te←atm te                      ⍝ Atomize test expression
    lf←lf1⍪lf2                         ⍝ Combine liftings
    1=≢k:lf⍪(1↑⍵)⍪te                   ⍝ No consequent, no children expressions
    ce←⊃⍪/(1+⊃⍵)lft⊃⌽k                 ⍝ Lift consequent, inside cond
    lf⍪(1↑⍵)⍪te⍪ce                     ⍝ Put it all back in the right order
  }
  1=≢⍵:⍵                               ⍝ Do nothing for leaves
  'Expression'≡⊃0 1⌷⍵:⊃⍪/(⊃⍵)lft ⍵     ⍝ Lift root expressions
  'Condition'≡⊃0 1⌷⍵:cnd ⍵             ⍝ Lifting Condition nodes is special
  (∇⊢)Eachk ⍵                          ⍝ Ignore non-expr nodes
}

⍝ AnchorVars
⍝
⍝ Intended Function: Associate with each assignment, scope, and variable
⍝ reference an appropriate slot pointing to a specific region of memory within
⍝ the stack frames, or in the case of scopes, the size of the stack frame of
⍝ that scope.

AnchorVars←{
  mt←0 3⍴'' 0 0                        ⍝ An empty environment
  ge←{                                 ⍝ Fn to get env for current scope
    em←(1+⊃⍵)=0⌷⍉⍵                     ⍝ All expressions are direct descendants
    em∧←(1⌷⍉⍵)∊⊂'Expression'           ⍝ Mask of expressions
    nm←'name'Prop em⌿⍵                 ⍝ Names in local scope
    nm←⍪⊃,/(⊂0⍴⊂''),Split¨nm           ⍝ Split names and prepare
    (nm,0),⍳≢nm                        ⍝ Local scope 0, assign slot to each var
  }
  vis←{nm←⊃0 1⌷⍺ ⋄ ast env←⍵
    'Variable'≡nm:⍺{                   ⍝ Variable node
      nmv←'name'Prop ⍺                 ⍝ Name vector of node
      nmv∊,¨'⍺⍵':(ast⍪⍺)env            ⍝ Don't annotate if ⍺ or ⍵
      i←⊃(0⌷⍉env)⍳nmv                  ⍝ Lookup var in env
      a←'env' 'slot',⍪⍕¨i(1 2)⌷env     ⍝ Stack frame and slot
      a←(⊃0 3⌷⍺)⍪a                     ⍝ Attach new attributes
      (ast⍪(1 3↑⍺),⊂a)env              ⍝ Attach to current AST
    }⍵
    'FuncExpr'≡nm:⍺(⍺⍺{
      'Variable'≡⊃1 1⌷⍺:(ast⍪⍺)env     ⍝ Don't process function variables
      z←(⌽1 Kids ⍺),⊂MtAST env         ⍝ Recur down the children
      ka env←⊃⍺⍺vis/z                  ⍝ In other cases
      (ast⍪(1↑⍺)⍪ka)env                ⍝ and return
    })⍵
    'Expression'≡nm:⍺(⍺⍺{              ⍝ Expression node
      z←(⌽1 Kids ⍺),⊂MtAST env         ⍝ Children use existing env
      ka env←⊃⍺⍺vis/z                  ⍝ Children visited first
      nm←Split⊃'name'Prop 1↑⍺          ⍝ Name(s) of expression
      id←(0⌷⍉⍺⍺)⍳nm                    ⍝ Relevant names in scope env
      sl←id⊃¨⊂2⌷⍉⍺⍺                    ⍝ Slot(s) for each name
      at←(⊃0 3⌷⍺)⍪'slots'(⍕sl)         ⍝ New attributes for node
      nd←(1 3↑⍺),⊂at                   ⍝ New node
      z←(ast⍪nd⍪ka)                    ⍝ AST to return
      z(((⊂id)⌷⍺⍺)⍪env)                ⍝ Add any names to environment
    })⍵
    'Condition'≡nm:⍺(⍺⍺{               ⍝ Condition node
      k←1 Kids ⍵                       ⍝ Must handle children
      z←(⌽1 Kids ⍵),⊂MtAST env         ⍝ Can reduce over all the kids at once
      ca _←⊃⍺⍺ vis/z                   ⍝ We ignore the consequent environment
      (ast⍪(1↑⍺)⍪ca)env                ⍝ Return the original environment
    })⍵
    'Function'≡nm:⍺(⍺⍺{                ⍝ Function node
      ken←⍺⍺⍪env                       ⍝ Env is current env plus all in scope
      ken[;1]+←1                       ⍝ Push the stack count up
      z←(⌽1 Kids ⍺),⊂MtAST ken         ⍝ Must go through all children
      ne←ge ⍺                          ⍝ New scope env
      ka _←⊃ne vis/z                   ⍝ Ignore env from children
      at←(⊃0 3⌷⍺)⍪'alloca'(⍕≢ne)       ⍝ New env attribute for function node
      nd←(1 3↑⍺),⊂at                   ⍝ New function node
      (ast⍪nd⍪ka)env                   ⍝ Leave environment same as when entered
    })⍵
    z←(⌽1 Kids ⍺),⊂MtAST env
    ka env←⊃∇/z
    (ast⍪(1↑⍺)⍪ka)env
  }
  z←(⌽1 Kids ⍵),⊂MtAST mt
  z←⊃⊃(ge ⍵)vis/z
  (1↑⍵)⍪z
}

⍝ LiftFuncs
⍝
⍝ Intended Function: Lift all functions to the top level.

LiftFuncs←{
  I←¯1 ⋄ MkV←{'FN',⍕I⊣(⊃I)+←1}         ⍝ New variable maker
  vis←{lft ast←⍵                       ⍝ Fn to visit each node
    (0=⍺⍺)∧'Function'≡⊃0 1⌷⍺:⍺(⍺⍺{     ⍝ Traverse Top-level Fn Nodes
      z←(⌽1 Kids ⍺),⊂lft MtAST         ⍝ Recur over children
      lft ka←⊃(1+⍺⍺)vis/z              ⍝ Bump up the depth for kids
      lft(ast⍪(1↑⍺)⍪ka)                ⍝ Return unchanged
    })⍵
    'Function'≡⊃0 1⌷⍺:⍺(⍺⍺{            ⍝ Only lift nested Function nodes
      z←(⌽1 Kids ⍺),⊂lft MtAST         ⍝ Recur over children, updating lifted
      lft ka←⊃(1+⍺⍺)vis/z              ⍝ Bump up the depth over children
      (0⌷⍉ka)-←(⊃ka)-3                 ⍝ Lift children down to root depth 3
      at←(⊃0 3⌷⍺)⍪'depth'(⍕⍺⍺)         ⍝ New depth attribute for Function node
      nfn←(1 4⍴2,(0(1 2)⌷⍺),⊂at)⍪ka    ⍝ New Fn node lifted to depth 2
      at←1 2⍴'name'(nm←MkV⍬)           ⍝ Fe gets new name
      at⍪←'class' 'ambivalent'         ⍝ Ambivalent class; this is a Fn
      nlf←(1 4⍴1 'FuncExpr' '' at)⍪nfn ⍝ Containing Fe node at depth 1
      vn←1 2⍴'class' 'ambivalent'      ⍝ Replace with ambivalent variable
      vn⍪←2 2⍴'depth'(⍕⍺⍺)'name' nm    ⍝ With the same depth and new name
      vn←1 4⍴(⊃⍺)'Variable' '' vn      ⍝ Node has same depth
      (lft⍪nlf)(ast⍪vn)                ⍝ Fn lifted and replaced by variable
    })⍵
    z←(⌽1 Kids ⍺),⊂lft MtAST           ⍝ Otherwise, traverse
    nlf ka←⊃∇/z                        ⍝ without changing anything
    nlf(ast⍪(1↑⍺)⍪ka)                  ⍝ Tack on the head
  }
  z←(⌽1 Kids ⍵),⊂2⍴⊂MtAST              ⍝ Must traverse all top-level
  (1↑⍵)⍪⊃⍪/⊃0 vis/z                    ⍝ Nodes just the same
}

⍝ Runtime equivalents
⍝
⍝ The runtime equivalents to specific APL primitives

APLPrims←⊂,'+'  ⋄ APLRunts←⊂'codfns_add'
APLPrims,←⊂,'-' ⋄ APLRunts,←⊂'codfns_subtract'
APLPrims,←⊂,'÷' ⋄ APLRunts,←⊂'codfns_divide'
APLPrims,←⊂,'×' ⋄ APLRunts,←⊂'codfns_multiply'
APLPrims,←⊂,'|' ⋄ APLRunts,←⊂'codfns_residue'
APLPrims,←⊂,'*' ⋄ APLRunts,←⊂'codfns_power'
APLPrims,←⊂,'⍟' ⋄ APLRunts,←⊂'codfns_log'
APLPrims,←⊂,'⌈' ⋄ APLRunts,←⊂'codfns_max'
APLPrims,←⊂,'⌊' ⋄ APLRunts,←⊂'codfns_min'
APLPrims,←⊂,'<' ⋄ APLRunts,←⊂'codfns_less'
APLPrims,←⊂,'≤' ⋄ APLRunts,←⊂'codfns_less_or_equal'
APLPrims,←⊂,'=' ⋄ APLRunts,←⊂'codfns_equal'
APLPrims,←⊂,'≠' ⋄ APLRunts,←⊂'codfns_not_equal'
APLPrims,←⊂,'≥' ⋄ APLRunts,←⊂'codfns_greater_or_equal'
APLPrims,←⊂,'>' ⋄ APLRunts,←⊂'codfns_greater'
APLPrims,←⊂,'⌷' ⋄ APLRunts,←⊂'codfns_squad'
APLPrims,←⊂,'⍴' ⋄ APLRunts,←⊂'codfns_reshape'
APLPrims,←⊂,',' ⋄ APLRunts,←⊂'codfns_catenate'
APLPrims,←⊂,'⍳' ⋄ APLRunts,←⊂'codfns_indexgen'
APLPrims,←⊂'⎕ptred' ⋄ APLRunts,←⊂'codfns_ptred'
APLPrims,←⊂'⎕index' ⋄ APLRunts,←⊂'codfns_index'
APLPrims,←⊂,'¨' ⋄ APLRtOps←,⊂'codfns_each'

⍝ ConvPrims
⍝
⍝ Intended Function: Convert all Primitive nodes to their appropriate
⍝ runtime variable references.

ConvPrims←{ast←⍵
  pm←(1⌷⍉⍵)∊⊂'Primitive'               ⍝ Mask of Primitive nodes
  pn←'name'Prop pm⌿⍵                   ⍝ Primitive names
  cn←(APLPrims⍳pn)⊃¨⊂APLRunts,APLRtOps ⍝ Converted names
  at←⊂1 2⍴'class' 'function'           ⍝ Class is function
  at⍪¨←(⊂⊂'name'),∘⊂¨cn                ⍝ Use the converted name
  vn←(⊂'Variable'),(⊂''),⍪at           ⍝ Build the basic node structure
  ast⊣(pm⌿ast)←(pm/0⌷⍉⍵),vn            ⍝ Replace Primitive nodes
}

⍝ GenLLVM
⍝
⍝ Intended Function: Take a namespace and convert it to an LLVM Module that is
⍝ semantically equivalent.

GenLLVM←{
  nam←(0 3)(0 1)⊃⍵                     ⍝ Namespace must have name
  nam←nam 'Unamed Namespace'⌷⍨''≡nam   ⍝ Possibly empty, so fix it
  mod←ModuleCreateWithName nam         ⍝ Empty module to start with
  0=≢k←1 Kids ⍵:mod                    ⍝ Quit if nothing to do
  nm←1⌷⍉(1=0⌷⍉⍵)⌿⍵                     ⍝ Top-level nodes and node names
  exm←nm∊⊂'Expression'                 ⍝ Mask of expressions
  fem←nm∊⊂'FuncExpr'                   ⍝ Mask of function expressions
  _←GenRuntime mod                     ⍝ Generate declarations for runtime
  tex←⊃,/(⊂⍬),mod GenGlobal¨exm/k      ⍝ Generate top-level globals
  _←mod GenFnDec¨fem/k                 ⍝ Generate Function declarations
  _←mod GenFunc¨fem/k                  ⍝ Generate functions
  _←mod GenInit tex                    ⍝ Generate Initialization function
  _←⍎'Initialize',Target,'TargetInfo'  ⍝ Setup targeting information
  _←⍎'Initialize',Target,'Target'      ⍝ Based on given Machine
  _←⍎'Initialize',Target,'TargetMC'    ⍝ Parameters in CoDfns namespace
  _←SetTarget mod TargetTriple         ⍝ JIT must have machine target
  mod  
}

⍝ GenFnDec
⍝
⍝ Intended Function: Take a FuncExpr node and declare the function.

GenFnDec←{
  0=≢fn←Split⊃'name'Prop 1↑⍵:0         ⍝ Ignore functions without names
  vtst←'Variable'≡⊃1 1⌷⍵               ⍝ Child node type
  vn←⊃'name'Prop 1↑1↓⍵                 ⍝ Variable name if it exists
  vtst:⍺{                              ⍝ Named function reference
    t←('equiv'Prop 1↑⍵)∊,¨APLPrims     ⍝ Is function equivalent to a primitive?
    t:vn(⍺ GenPrimEquiv)fn             ⍝ Then generate the call
    fr←GetNamedFunction ⍺ vn           ⍝ Referenced function
    ft←GenFuncType(CountParams fr)-3   ⍝ Function Type based on depth
    ⍺{AddAlias ⍺ ft fr ⍵}¨fn           ⍝ Generate aliases for each name
  }⍵
  fnf←⊃fn ⋄ fnr←1↓fn                   ⍝ Canonical name; rest of names
  fd←⍎'0',⊃'depth'Prop 1↑1↓⍵           ⍝ Function depth
  ft←GenFuncType fd                    ⍝ Fn type based on depth
  fr←AddFunction ⍺ fnf ft              ⍝ Insert function into module
  0=≢fnr:fr                            ⍝ Return if no other names
  fr⊣⍺{AddAlias ⍺ ft fr ⍵}¨fnr         ⍝ Otherwise, alias the others
}

⍝ GenPrimEquiv
⍝
⍝ Intended Function: Generate a function equivalent to a primitive, 
⍝ since you cannot alias a runtime definition.

GenPrimEquiv←{
  ft←GenFuncType 0                     ⍝ Primitive function type
  fr←AddFunction ⍺⍺ (⊃⍵) ft            ⍝ Declare equivalent
  bl←CreateBuilder                     ⍝ New builder 
  bb←AppendBasicBlock fr ''            ⍝ Single basic block
  _←PositionBuilderAtEnd bl bb         ⍝ Sync the builder and basic block
  pr←GetNamedFunction ⍺⍺ ⍺             ⍝ Get the name of the primitive
  ar←{GetParam fr ⍵}¨⍳3                ⍝ Get the arguments
  rs←BuildCall bl pr ar 3 ''           ⍝ Make the call to the primitive
  _←BuildRet bl rs                     ⍝ Return the error code of primitive
  1=≢⍵:fr                              ⍝ If there is only one name then done
  fr⊣⍺⍺{AddAlias ⍺ ft fr ⍵}¨1↓⍵        ⍝ Otherwise alias the other names
}

⍝ GenGlobal
⍝
⍝ Intended Function: Take a global expression and generate a new
⍝ binding in the module. Returns initialization expression if needed.

GenGlobal←{
  0=≢⍵:⍬                               ⍝ Don't do anything if nothing to do
  litp←{                               ⍝ Fn predicate to test if literal
    cls←⊃'class'Prop 1↑⍵               ⍝ Class of Expression
    ct←⊃1 1⌷⍵                          ⍝ Node type of the first child
    ('atomic'≡cls)∧'Number'≡ct         ⍝ Class is atomic; Child type is Number
  }
  litp ⍵:⍬⊣⍺ GenConst ⍵                ⍝ Generate the constants directly
  ∧/' '=nm←⊃'name'Prop 1↑⍵:,⊂⍵         ⍝ No need to declare unnamed expressions
  ,⊂⍵⊣⍺ GenArrDec Split⊃'name'Prop 1↑⍵ ⍝ Declare the array and enqueue
}

⍝ GenArrDec
⍝
⍝ Intended Function: Generate a new binding for an expression to be
⍝ initialized later if there is not already a binding in the module.

GenArrDec←{
  ⍺{                                   ⍝ Fn to declare new array
    0≠GetNamedGlobal ⍺ ⍵:⍵             ⍝ Do nothing if already declared
    r←ConstInt (Int16Type) 0 0         ⍝ Rank ← 0
    sz←ConstInt (Int64Type) 0 0        ⍝ Size ← 0
    t←ConstInt (Int8Type) 2 0          ⍝ Type ← 2
    st←PointerType Int32Type 0         ⍝ Type of the shape field
    dt←PointerType Int64Type 0         ⍝ Type of the data field
    s←ConstPointerNull st              ⍝ Shape ← ⍬
    d←ConstPointerNull dt              ⍝ Data ← ⍬
    a←ConstStruct (r sz t s d) 5 0     ⍝ Build empty structure
    g←AddGlobal ⍺ ArrayTypeV ⍵         ⍝ Add the Global
    ⍵⊣SetInitializer g a               ⍝ Set the initial empty value
  }¨⍵
}

⍝ GenConst
⍝
⍝ Intended Function: Given an literal Expression node, generate a global
⍝ LLVM Constant and insert it into the LLVM Module given.

GenConst←{
  vs←⊃'name'Prop 1↑⍵                   ⍝ Get the name of a literal
  mnlerr←'BAD LITERAL NAME'            ⍝ Error message
  ∨/' '=vs:mnlerr ⎕SIGNAL 99           ⍝ Sanity check for a single name
  v←((2≤⍴v)⊃⍬(⍴v))⍴v←'value'Prop 1↓⍵   ⍝ Expression values with correct shape
  arrayp←{                             ⍝ Fn to generate LLVM Array Pointer
    a←ConstArray ⍺⍺ ⍵ (⊃⍴⍵)            ⍝ Data values
    at←ArrayType ⍺⍺ (⊃⍴⍵)              ⍝ Type of the array
    g←AddGlobal ⍺ at ⍵⍵                ⍝ Add global to the module
    _←SetInitializer g a               ⍝ Initialize it
    b←CreateBuilder                    ⍝ Need a builder
    p←BuildGEP b g (GEPI 0 0) 2 ''     ⍝ Get the array pointer
    p⊣DisposeBuilder b                 ⍝ Cleanup and return pointer
  }
  cintstr←ConstIntOfString             ⍝ Shorten the name
  d←{cintstr (Int64Type) ⍵ 10}¨,v      ⍝ Data values
  d←⍺(Int64Type arrayp 'elems')d       ⍝ Data array pointer
  s←{                                  ⍝ The shape is either
    0=⍴⍵:⍬                             ⍝ An empty shape
    {ConstInt (Int32Type) ⍵ 0}¨⍵       ⍝ Or has LLVM Integers
  }⍴v                                  ⍝ Based on the shape of v
  s←⍺(Int32Type arrayp 'shape')s       ⍝ Shape array pointer
  r←ConstInt (Int16Type) (⊃⍴⍴v) 0      ⍝ Rank is constant; from v not d
  sz←ConstInt (Int64Type) (⊃⍴,v) 0     ⍝ Size of d is length of v
  t←ConstInt (Int8Type) 2 0            ⍝ Constant Int type, for now
  a←ConstStruct (r sz t s d) 5 0       ⍝ Build array value
  g←AddGlobal ⍺ ArrayTypeV vs          ⍝ Create global place holder
  g⊣SetInitializer g a                 ⍝ Initialize global with array value
}

⍝ GenFunc
⍝
⍝ Intended Function: Given a FuncExpr node, build an appropriate
⍝ Function in the LLVM Module given.

GenFunc←{
  0=≢fn←Split⊃'name'Prop 1↑⍵:0         ⍝ Ignore functions without names
  'Variable'≡⊃1 1⌷⍵:0                  ⍝ Ignore named function references
  fs←⍎⊃'alloca'Prop 1↑1↓⍵              ⍝ Allocation for local scope
  fr←GetNamedFunction ⍺ (⊃fn)          ⍝ Get the function reference
  bldr←CreateBuilder                   ⍝ Setup builder
  bb←AppendBasicBlock fr ''            ⍝ Initial basic block
  _←PositionBuilderAtEnd bldr bb       ⍝ Link builder and basic block
  env0←{                               ⍝ Setup local frame
    fsz←ConstInt Int32Type fs 0        ⍝ Frame size value reference
    0=fs:(GenNullArrayPtr⍬)fsz         ⍝ If frame is empty, do nothing
    ftp←ArrayTypeV                     ⍝ Frame is array pointer
    args←bldr ftp fsz 'env0'           ⍝ Frame is env0
    (BuildArrayAlloca args)fsz         ⍝ Return pointer and size
  }⍬
  k←2 Kids ⍵                           ⍝ Nodes of the Function body
  _←⍬ ⍬(⍺ fr bldr env0 GenFnBlock)k    ⍝ Generate the function body
  fr⊣DisposeBuilder bldr               ⍝ Builder cleanup
}

⍝ GenFnBlock
⍝
⍝ Intended Function: Generate a block of code in a function.

GenFnBlock←{mod fr bldr env0←⍺⍺ ⋄ nm vl←⍺ ⋄ k←⍵
  line←{n←⊃0 1⌷⍺                       ⍝ Op to handle node in function body
    n≡'Expression':⍺(⍺⍺ GenExpr)⍵      ⍝ Use GenExpr on Expressions
    n≡'Condition':⍺(⍺⍺ GenCond)⍵       ⍝ Use GenCond on Conditions
    emsg←'UNKNOWN FUNCTION CHILD'      ⍝ Only deal with Exprs or Conditions
    emsg ⎕SIGNAL 99                    ⍝ And signal an error otherwise
  }
  _ v←⊃⍺⍺ line/(⌽⍵),⊂⍺                 ⍝ Reduce top to bottom over children
  mt←GetNamedFunction mod 'array_mt'   ⍝ Runtime function to empty array
  res←GetParam fr 0                    ⍝ ValueRef of result parameter
  mtret←{                              ⍝ Fn for empty return
    _←BuildCall bldr mt res 1 ''       ⍝ Empty the result parameter
    bldr(⍵ MkRet)env0                  ⍝ And make return
  }
  0=≢⍵:mtret mod                       ⍝ Empty return on empty body
  'Condition'≡⊃0 1⌷l←⊃⌽⍵:mtret mod     ⍝ Extra return if condition
  cp←GetNamedFunction mod 'array_cp'   ⍝ Runtime array copy function
  ∨/' '≠⊃'name'Prop 1↑l:{              ⍝ Is last node named?
    args←res,⊃⌽v                       ⍝ Then we return the binding
    _←BuildCall bldr cp args 2 ''      ⍝ Copied into result array
    bldr(mod MkRet)env0                ⍝ And return
  }⍵
  1:shy←v
}

⍝ GenInit
⍝
⍝ Intended Function: Generate the initialization function that will
⍝ initialize all global variables that are not constants.

GenInit←{
  ft←GenFuncType 0                     ⍝ Zero depth function
  fr←AddFunction ⍺ 'Init' ft           ⍝ Named Init
  bldr←CreateBuilder                   ⍝ Setup builder
  bb←AppendBasicBlock fr ''            ⍝ Initial basic block
  _←PositionBuilderAtEnd bldr bb       ⍝ Link builder and basic block
  gex←{GetNamedGlobal ⍺ ⍵}             ⍝ Convenience Fn for GetNamedGlobal
  gfn←{GetNamedFunction ⍺ ⍵}           ⍝ Convenience Fn for GetNamedFunction
  call←{BuildCall bldr ⍺⍺ ⍵ (≢⍵) ''}   ⍝ Op to build call
  cpf←⍺ gfn 'array_cp'                 ⍝ Runtime copy function
  cpy←{cpf call ⍺ ⍵}                   ⍝ Convenience Fn for Copying arrays
  mcall←{                              ⍝ Fn to generate multiple assignment
    v←⍺⍺ call (⊃⍺),⍵                   ⍝ Call on the first argument
    1=≢⍺:v                             ⍝ If single target, done.
    v,(1↓⍺)cpy¨⊃⍺                      ⍝ Otherwise, copy results to other args
  }
  gtg←{                                ⍝ Fn to ensure valid target name
    nm←⊃'name'Prop 1↑⍵                 ⍝ Name attr of node
    ∧/' '=nm:(⍺ GenArrDec⊂'ign'),1     ⍝ If unnamed, generate temp name
    (⍺ gex¨Split nm)(0)                ⍝ Otherwise, lookup references
  }
  array_free←⍺ gfn 'array_free'        ⍝ Runtime cleaner function reference
  free←{array_free call ⍵}             ⍝ Function to cleanup ararys
  clean←{(⊃⍺){⍵⊣free ⍺}⍣(⊃⌽⍺)⊢⍵}       ⍝ Fn to optionally cleanup temp array
  expr←{                               ⍝ Handle each global expr in turn
    n←⊃'class'Prop 1↑⍵                 ⍝ Switch on node class
    'atomic'≡n:⍺{                      ⍝ Atomic case: variable reference
      ∧/' '=tgt←⊃'name'Prop 1↑⍵:0      ⍝ Ignore unnamed global references
      tgt←⍺ gex¨Split tgt              ⍝ Vector of target ValueRefs
      src←⍺ gex ⊃'name'Prop 1↑1↓⍵      ⍝ Source ValueRef
      tgt cpy¨src                      ⍝ Copy source to each target
    }⍵
    'monadic'≡n:⍺{                     ⍝ Monadic: FVar Var, Depth always 0
      tgt ist←t←⍺ gtg ⍵                ⍝ Variables to be assigned
      lft←GenNullArrayPtr⍬             ⍝ Left argument is null
      fn←⍺ gfn ⊃'name'Prop 1↑2↓⍵       ⍝ Function is first child
      rgt←⍺ gex ⊃'name'Prop 1↑4↓⍵      ⍝ Right argument is second child
      t clean tgt(fn mcall)lft rgt     ⍝ Make the call
    }⍵
    'dyadic'≡n:⍺{                      ⍝ Dyadic: Var FVar Var
      tgt ist←t←a gtg ⍵                ⍝ Variables to be assigned
      lft←⍺ gex ⊃'name'Prop 1↑2↓⍵      ⍝ Left argument is first child
      fn←⍺ gfn ⊃'name'Prop 1↑4↓⍵       ⍝ Function is second child
      rgt←⍺ gex ⊃'name'Prop 1↑6↓⍵      ⍝ Right argument is third child
      t clean tgt(fn mcall)lft rgt     ⍝ Make the call
    }⍵
    'UNREACHABLE'⎕SIGNAL 99
  }
  finish←{
    zero←ConstInt Int32Type 0 0        ⍝ Zero Return
    _←BuildRet bldr zero               ⍝ No need to do regular return
    fr⊣DisposeBuilder bldr             ⍝ Cleanup and return function reference
  }
  0=≢⍵:finish⍬                         ⍝ Nothing to do
  _←⍺ expr¨⍵                           ⍝ Handle each expr
  finish⍬                              ⍝ Cleanup
}

⍝ LookupExpr
⍝
⍝ Intended Function: Given an environment and a name, find the
⍝ LLVM Value Ref for that name.

LookupExpr←{⍺←⊢ ⋄ nm vl←⍺⊣2⍴⊂0⍴⊂'' ⋄ mod fr bld _←⍺⍺ ⋄ node←⍵
  nam←⊃'name'Prop ⍵                    ⍝ Variable's name
  i←(,¨'⍺⍵')⍳⊂nam                      ⍝ Do we have a formal?
  2≠i:(GetParam fr (1+i)),nm vl        ⍝ Easy if we have formals
  (i←nm⍳⊂nam)<≢nm:(i⊃vl),nm vl         ⍝ Environment contains binding, use it
  eid←⍎⊃'env'Prop ⍵                    ⍝ Variable's Environment
  pos←⍎⊃'slot'Prop ⍵                   ⍝ Position in environment
  fnd←(CountParams fr)-3               ⍝ Get the function depth
  eid=0:'VALUE ERROR'⎕SIGNAL 99        ⍝ Variable should not be in local scope
  eid>fnd:{                            ⍝ Environment points to global space
    val←GetNamedGlobal mod nam         ⍝ Grab the value from the global space
    val,((⊂nam),nm)(val,vl)            ⍝ Add it to the bindings and return
  }⍬
  env←GetParam fr(2+eid)               ⍝ Pointer to environment frame
  idx←GEPI ,pos                        ⍝ Convert pos to GEP index
  app←BuildGEP bld env idx 1 ''        ⍝ Pointer to Array Pointer for Variable
  apv←BuildLoad bld app nam            ⍝ Array Pointer for Variable
  apv,((⊂nam),nm)(apv,vl)              ⍝ Update the environment and return
}

⍝ GenCond
⍝
⍝ Intended Function: Generate code for a Condition node.

GenCond←{mod fr bldr env0←⍺⍺ ⋄ nm vl←⍵ ⋄ node←⍺
  te←⊃k←1 Kids ⍺                       ⍝ Children and test expression
  te nm vl←⍵(⍺⍺ LookupExpr)1↑1↓te      ⍝ Find ValueRef of test expression
  gp←BuildStructGEP bldr te 4 ''       ⍝ Get data values pointer
  tp←BuildLoad bldr gp 'tp'            ⍝ Load data values
  ap←ArrayType Int64Type 1             ⍝ Type of an Array
  ap←PointerType ap 0                  ⍝ Pointer type to an array
  tp←BuildBitCast bldr tp ap ''        ⍝ Cast data values to array pointer
  gp←BuildGEP bldr tp (GEPI 0 0) 2 ''  ⍝ Value pointer
  tv←BuildLoad bldr gp 'tv'            ⍝ Load value
  zr←ConstInt Int64Type 0 1            ⍝ We're testing against zero
  t←BuildICmp bldr 32 tv zr 'T'        ⍝ We test at the end of block
  cb←AppendBasicBlock fr 'consequent'  ⍝ Consequent basic block
  _←PositionBuilderAtEnd bldr cb       ⍝ Point builder to consequent
  _←⍵(⍺⍺ GenFnBlock)1↓k                ⍝ Generate the consequent block
  ob←GetPreviousBasicBlock cb          ⍝ Original basic block
  ab←AppendBasicBlock fr 'alternate'   ⍝ Alternate basic block
  _←PositionBuilderAtEnd bldr ob       ⍝ We need to add a conditional break
  _←BuildCondBr bldr t ab cb           ⍝ To the old block pointing to cb and ab
  _←PositionBuilderAtEnd bldr ab       ⍝ And then return pointing at the ab
  nm vl                                ⍝ Return our possibly new environment
}

⍝ GenExpr
⍝
⍝ Intended Function: Generate an Expression, named or unnamed.

GenExpr←{mod fr bldr env0←⍺⍺ ⋄ nm vl←⍵ ⋄ node←⍺
  gnf←{GetNamedFunction mod ⍵}         ⍝ Convenience function
  call←{BuildCall bldr ⍺ ⍵ (≢⍵) ''}    ⍝ Op to build call
  cpf←gnf 'array_cp'                   ⍝ Foreign copy function
  cpy←{0=⍺:0 ⋄ cpf call ⍺ ⍵}           ⍝ Copy wrapper
  gret←{GetParam ⍵ 0}                  ⍝ Fn to get result array
  gloc←{                               ⍝ Fn to get local variable
    idx←GEPI ,⍺
    BuildGEP bldr(⊃env0)idx 1 ⍵
  } 
  nms←Split ⊃'name'Prop 1↑⍺            ⍝ Assignment variables
  sl←Split ⊃'slots'Prop 1↑⍺            ⍝ Slots for variable assignments
  sl←{∧/' '=⍵:0 ⋄ ⍎⍵}¨sl               ⍝ Convert to right type
  tgt←sl{0=≢⍵:gret fr ⋄ ⍺ gloc¨⍵}nms   ⍝ Target Value Refs for assignment
  tgh←⊃tgt ⋄ tgr←1↓tgt                 ⍝ Split into head and rest targets
  nm vl←⍺(⍺⍺{rec←∇                     ⍝ Process the Expr
    cls←⊃'class'Prop 1↑⍺               ⍝ Node class
    'atomic'≡cls:⍺{                    ⍝ Atomic: Var Reference
      av nm vl←⍵(⍺⍺ LookupExpr)1↑2↓⍺   ⍝ Lookup expression variable
      nm vl⊣tgh cpy                    ⍝ Copy into the first target
    }⍵
    lft nm vl f r←⍺(⍺⍺{                ⍝ Left argument handled based on arity
      gnap←GenNullArrayPtr             ⍝ Convenience
      dlft←⍺⍺{⍵(⍺⍺LookupExpr)1↑2↓⍺}    ⍝ Grab left argument in dyadic case
      'monadic'≡cls:(gnap⍬),⍵,0 1      ⍝ No new bindings, Fn Rgt ←→ 1st, 2nd
      'dyadic'≡cls:(⍺ dlft ⍵),1 2      ⍝ New bindings, Fn Rgt ←→ 2nd, 3rd
      'BAD CLASS'⎕SIGNAL 99            ⍝ Error trap just in case
    })⍵
    rgt nm vl←(k←1 Kids ⍺)(⍺⍺{         ⍝ Process the right argument
      'atomic'≡⊃'class'Prop r⊃⍺:⍺(⍺⍺{  ⍝ Handling for an atomic
        ⍵(⍺⍺ LookupExpr)1↑1↓r⊃⍺        ⍝ Lookup the single variable
      })⍵
      tgh,(r⊃⍺)rec ⍵                   ⍝ Recur on other types of nodes
    })nm vl
    fn env←⍺⍺ GenFnEx f⊃k              ⍝ Get the function reference
    nm vl⊣fn call tgh,lft,rgt,env      ⍝ Build the call
  })⍵
  nb←(nms,nm)(((≢nms)↑tgt),vl)         ⍝ New bindings
  0=≢nms:nb⊣bldr(mod MkRet)env0        ⍝ Unnamed is a return
  nb⊣tgr cpy¨tgh                       ⍝ Copy rest of names; return bindings
}

⍝ GenFnEx
⍝
⍝ Intended Function: Generate a function reference and environment for 
⍝ a given function expression. 

GenFnEx←{mod fr bldr env0←⍺ ⋄ node←⍵
  gnf←{GetNamedFunction mod ⍵}         ⍝ Convenience function
  garg←{0=⍵:⍬ ⋄ GetParam ⍺ ⍵}          ⍝ Fn to get a function parameter
  fn←gnf⊃'name'Prop ⊃k←1 Kids ⍵        ⍝ Grab function (pre-declared)
  fd←-(CountParams fn)-3               ⍝ Callee depth
  cd←(CountParams fr)-3                ⍝ Caller depth
  env←fd↑(⊃env0),fr garg¨3+⍳cd         ⍝ Environments needed for fn
  1=≢k:fn env                          ⍝ Single variable reference
  each←gnf 'codfns_each'               ⍝ Otherwise, we heave ¨
  atp←PointerType ArrayTypeV 0         ⍝ Type of each env value
  rt←Int32Type                         ⍝ Op function has unique signature
  args←(3⍴atp),(PointerType atp 0)     ⍝ It has res, lft, rgt, and env[]
  ft←FunctionType rt args (≢args) 0    ⍝ Function type for op function
  nf←AddFunction mod 'opf' ft          ⍝ Op function to pass to each
  nfb←CreateBuilder                    ⍝ We need to use a new builder here
  bb←AppendBasicBlock nf ''            ⍝ Simple basic block is all we need
  _←PositionBuilderAtEnd nfb bb        ⍝ Position our new builder
  enva←GetParam nf 3                   ⍝ The Array **
  args←{
    0=≢env:⍬                           ⍝ Catch the empty case
    {
      idx←GEPI ,⍵                      ⍝ i←⍵
      ptr←BuildGEP nfb enva idx 1 ''   ⍝ &env[i]
      BuildLoad nfb ptr ''             ⍝ env[i]
    }¨⍳≢env
  }⍬
  carg←({GetParam nf ⍵}¨⍳3),args       ⍝ All the args
  res←BuildCall nfb fn carg (≢carg) '' ⍝ Call inside of opf to fn
  _←BuildRet nfb res                   ⍝ Return result of fn from opf
  _←DisposeBuilder nfb                 ⍝ nf definition complete, clean up
  fsz←ConstInt Int32Type (≢env) 0      ⍝ Value Ref for ≢env
  ena←BuildArrayAlloca bldr atp fsz '' ⍝ Stack frame to hold frame pointers
  _←{
    idx←GEPI ,⍵
    ptr←BuildGEP bldr ena idx 1 ''     ⍝ Pointer to cell in env[]
    BuildStore bldr (env[⍵]) ptr       ⍝ Store env[⍵] into frame
  }¨⍳≢env
  each (nf ena)
}

⍝ MkRet
⍝
⍝ Intended Function: Insert a return at the end of a function body

MkRet←{
  cln←GetNamedFunction ⍺⍺ 'clean_env'  ⍝ Runtime function to clean environment
  0=cln:'MISSING FN'⎕SIGNAL 99         ⍝ Safeguard
  _←BuildCall ⍺ cln ⍵ 2 ''             ⍝ Clean the local environment
  zero←ConstInt Int32Type 0 0          ⍝ Zero integer
  BuildRet ⍺ zero                      ⍝ Return a success status
}

⍝ GenNullArrayPtr
⍝
⍝ Intended Function: Generate a null pointer to an array.

GenNullArrayPtr←{
  T←PointerType ArrayTypeV 0           ⍝ Array Type
  ConstPointerNull T                   ⍝ Null Pointer
}

⍝ GenArrayType
⍝
⍝ Intended Function: Constant function returning the type of an
⍝ array.
⍝
⍝ See the Software Architecture for details on the Array Structure.

GenArrayType←{
  D←PointerType (Int64Type) 0          ⍝ Data is int64_t *
  S←PointerType (Int32Type) 0          ⍝ Shape is uint32_t *
  lt←(Int16Type)(Int64Type)(Int8Type)  ⍝ Rank, Size, and Type
  lt,←S D                              ⍝ with Shape and Data
  ctx←GetGlobalContext                 ⍝ Context for the type
  tp←StructCreateNamed ctx 'Array'     ⍝ Initial named structure
  tp⊣StructSetBody tp lt 5 0           ⍝ Set the structure body
}

⍝ GenFuncType
⍝
⍝ Intended Function: A constant function returning the type of a
⍝ Function.

GenFuncType←{
  typ←PointerType ArrayTypeV 0         ⍝ All arguments are array pointers
  ret←Int32Type ⋄ arg←((3+⍵)⍴typ)      ⍝ Return type and arg type vector
  FunctionType ret arg (≢arg) 0        ⍝ Return the function type
}

⍝ GEPI
⍝
⍝ Intended Function: Generate an array of pointers to be used as
⍝ inputs to the BuildGEP function.

GEPI←{{ConstInt (Int32Type) ⍵ 0}¨⍵}

⍝ GenRuntime
⍝
⍝ Intended Function: Generate declarations for the Co-dfns runtime
⍝ in an LLVM Module.

GenRuntime←{
  ft←PointerType ArrayTypeV 0          ⍝ Pointer to array, clean_env arg 1
  et←PointerType ft 0                  ⍝ Pointer to frame
  it←Int32Type                         ⍝ clean_env arg 2 type
  vt←VoidType                          ⍝ clean_env return type
  cet←FunctionType vt (ft it) 2 0      ⍝ clean_env type
  opf←FunctionType it ((3⍴ft),et) 4 0  ⍝ Operator Function signature
  two←GenFuncType ¯1                   ⍝ Some functions take only two args
  std←GenFuncType 0                    ⍝ Most take three
  opfp←PointerType opf 0               ⍝ Type of Opf argument to operator
  opa←(3⍴ft),opfp,et                   ⍝ Operator argument types
  opr←FunctionType it opa 5 0          ⍝ Operator type
  add←⍵ {AddFunction ⍺⍺ ⍵ ⍺}           ⍝ Fn to add functions to the module
  _←cet add 'clean_env'                ⍝ Add clean_env()
  _←two add¨'array_cp' 'array_free'    ⍝ Add the special ones
  _←std add¨APLRunts                   ⍝ Add the normal runtime
  _←opr add¨APLRtOps                   ⍝ Add the operators
  0 0⍴⍬                                ⍝ Hide our return result
}

⍝ Foreign Functions

∇{Z}←FFI∆INIT;P;Core;ExEng;X86Info;X86CodeGen;X86Desc;R
Z←⍬
Core←LLVMCore
ExEng←LLVMExecutionEngine
X86Info←LLVMX86Info
X86CodeGen←LLVMX86CodeGen
X86Desc←LLVMX86Desc
R←CoDfnsRuntime
P←'LLVM'

⍝ LLVMTypeRef LLVMTypeOf (LLVMValueRef Val)
'TypeOf'⎕NA 'P ',Core,'|',P,'TypeOf P'

⍝ LLVMTypeRef LLVMInt8Type (void)
'Int8Type'⎕NA 'P ',Core,'|',P,'Int8Type'

⍝ LLVMTypeRef  LLVMInt16Type (void)
'Int16Type'⎕NA 'P ',Core,'|',P,'Int16Type'

⍝ LLVMTypeRef  LLVMInt32Type (void)
'Int32Type'⎕NA 'P ',Core,'|',P,'Int32Type'

⍝ LLVMTypeRef  LLVMInt64Type (void)
'Int64Type'⎕NA 'P ',Core,'|',P,'Int64Type'

⍝ LLVMTypeRef LLVMVoidType(void)
'VoidType'⎕NA 'P ',Core,'|',P,'VoidType'

⍝ LLVMTypeRef
⍝ LLVMFunctionType (LLVMTypeRef ReturnType,
⍝    LLVMTypeRef *ParamTypes, unsigned ParamCount, LLVMBool IsVarArg)
'FunctionType'⎕NA 'P ',Core,'|',P,'FunctionType P <P[] U I'

⍝ LLVMTypeRef
⍝ LLVMStructType (LLVMTypeRef *ElementTypes, unsigned ElementCount, LLVMBool Packed)
'StructType'⎕NA 'P ',Core,'|',P,'StructType <P[] U I'

⍝ void 	
⍝ LLVMStructSetBody (LLVMTypeRef StructTy, 
⍝     LLVMTypeRef *ElementTypes, unsigned ElementCount, LLVMBool Packed)
'StructSetBody'⎕NA Core,'|',P,'StructSetBody P <P[] U I'

⍝ LLVMPointerType (LLVMTypeRef ElementType, unsigned AddressSpace)
'PointerType'⎕NA 'P ',Core,'|',P,'PointerType P U'

⍝ LLVMTypeRef 	LLVMArrayType (LLVMTypeRef ElementType, unsigned ElementCount)
'ArrayType'⎕NA'P ',Core,'|',P,'ArrayType P U'

⍝ LLVMTypeRef 	LLVMStructCreateNamed (LLVMContextRef C, const char *Name)
'StructCreateNamed'⎕NA 'P ',Core,'|',P,'StructCreateNamed P <0C[]'

⍝ LLVMValueRef  LLVMConstInt (LLVMTypeRef IntTy, unsigned long long N, LLVMBool SignExtend)
'ConstInt'⎕NA 'P ',Core,'|',P,'ConstInt P U8 I'

⍝ LLVMValueRef  LLVMConstIntOfString (LLVMTypeRef IntTy, const char *Text, uint8_t Radix)
'ConstIntOfString'⎕NA 'P ',Core,'|',P,'ConstIntOfString P <0C[] U8'

⍝ LLVMValueRef
⍝ LLVMConstArray (LLVMTypeRef ElementTy, LLVMValueRef *ConstantVals, unsigned Length)
'ConstArray'⎕NA 'P ',Core,'|',P,'ConstArray P <P[] U'

⍝ LLVMValueRef 	LLVMConstPointerNull (LLVMTypeRef Ty)
'ConstPointerNull'⎕NA'P ',Core,'|',P,'ConstPointerNull P'

⍝ LLVMValueRef  LLVMAddGlobal (LLVMModuleRef M, LLVMTypeRef Ty, const char *Name)
'AddGlobal'⎕NA 'P ',Core,'|',P,'AddGlobal P P <0C[]'

⍝ void  LLVMSetInitializer (LLVMValueRef GlobalVar, LLVMValueRef ConstantVal)
'SetInitializer'⎕NA '',Core,'|',P,'SetInitializer P P'

⍝ LLVMValueRef  LLVMAddFunction (LLVMModuleRef M, const char *Name, LLVMTypeRef FunctionTy)
'AddFunction'⎕NA 'P ',Core,'|',P,'AddFunction P <0C[] P'

⍝ LLVMValueRef  LLVMGetNamedGlobal (LLVMModuleRef M, const char *Name)
'GetNamedGlobal'⎕NA 'P ',Core,'|',P,'GetNamedGlobal P <0C[]'

⍝ LLVMValueRef 	LLVMGetNamedFunction (LLVMModuleRef M, const char *Name)
'GetNamedFunction'⎕NA 'P ',Core,'|',P,'GetNamedFunction P <0C[]'

⍝ LLVMBasicBlockRef  LLVMAppendBasicBlock (LLVMValueRef Fn, const char *Name)
'AppendBasicBlock'⎕NA 'P ',Core,'|',P,'AppendBasicBlock P <0C[]'

⍝ LLVMBuilderRef  LLVMCreateBuilder (void)
'CreateBuilder'⎕NA 'P ',Core,'|',P,'CreateBuilder'

⍝ void  LLVMPositionBuilderAtEnd (LLVMBuilderRef Builder, LLVMBasicBlockRef Block)
'PositionBuilderAtEnd'⎕NA 'P ',Core,'|',P,'PositionBuilderAtEnd P P'

⍝ LLVMValueRef  LLVMBuildRet (LLVMBuilderRef, LLVMValueRef V)
'BuildRet'⎕NA'P ',Core,'|',P,'BuildRet P P'

⍝ LLVMValueRef 	LLVMBuildRetVoid (LLVMBuilderRef)
'BuildRetVoid'⎕NA'P ',Core,'|',P,'BuildRetVoid P'

⍝ LLVMValueRef
⍝ LLVMBuildCondBr (LLVMBuilderRef, LLVMValueRef If, LLVMBasicBlockRef Then,
⍝     LLVMBasicBlockRef Else)
'BuildCondBr'⎕NA'P ',Core,'|',P,'BuildCondBr P P P P'

⍝ LLVMValueRef
⍝ LLVMBuildCall (LLVMBuilderRef, LLVMValueRef Fn,
⍝     LLVMValueRef *Args, unsigned NumArgs, const char *Name)
'BuildCall'⎕NA'P ',Core,'|',P,'BuildCall P P <P[] U <0C'

⍝ void  LLVMDisposeBuilder (LLVMBuilderRef Builder)
'DisposeBuilder'⎕NA 'P ',Core,'|',P,'DisposeBuilder P'

⍝ LLVMValueRef
⍝ LLVMConstStruct (LLVMValueRef *ConstantVals, unsigned Count, LLVMBool Packed)
'ConstStruct'⎕NA'P ',Core,'|',P,'ConstStruct <P[] U I'

⍝ LLVMValueRef 	LLVMBuildAlloca (LLVMBuilderRef, LLVMTypeRef Ty, const char *Name)
'BuildAlloca'⎕NA'P ',Core,'|',P,'BuildAlloca P P <0C'

⍝ LLVMValueRef 	LLVMBuildLoad (LLVMBuilderRef, LLVMValueRef PointerVal, const char *Name)
'BuildLoad'⎕NA'P ',Core,'|',P,'BuildLoad P P <0C'

⍝ LLVMValueRef 	LLVMBuildStore (LLVMBuilderRef, LLVMValueRef Val, LLVMValueRef Ptr)
'BuildStore'⎕NA'P ',Core,'|',P,'BuildStore P P P'

⍝ LLVMBasicBlockRef 	LLVMGetInsertBlock (LLVMBuilderRef Builder)
'GetInsertBlock'⎕NA'P ',Core,'|',P,'GetInsertBlock P'

⍝ LLVMValueRef 	LLVMGetLastInstruction (LLVMBasicBlockRef BB)
'GetLastInstruction'⎕NA'P ',Core,'|',P,'GetLastInstruction P'

⍝ LLVMBasicBlockRef 	LLVMGetPreviousBasicBlock (LLVMBasicBlockRef BB)
'GetPreviousBasicBlock'⎕NA'P ',Core,'|',P,'GetPreviousBasicBlock P'

⍝ LLVMValueRef
⍝ LLVMBuildStructGEP (LLVMBuilderRef B, LLVMValueRef Pointer, unsigned Idx, const char *Name)
'BuildStructGEP'⎕NA'P ',Core,'|',P,'BuildStructGEP P P U <0C'

⍝ LLVMValueRef
⍝ LLVMBuildGEP (LLVMBuilderRef B, LLVMValueRef Pointer, LLVMValueRef *Indices,
⍝     unsigned NumIndices, const char *Name)
'BuildGEP'⎕NA'P ',Core,'|',P,'BuildGEP P P <P[] U <0C'

⍝ LLVMValueRef
⍝ LLVMBuildBitCast (LLVMBuilderRef, LLVMValueRef Val, LLVMTypeRef DestTy, const char *Name)
'BuildBitCast'⎕NA'P ',Core,'|',P,'BuildBitCast P P P <0C'

⍝ LLVMValueRef
⍝ LLVMBuildICmp (LLVMBuilderRef, LLVMIntPredicate Op, LLVMValueRef LHS,
⍝     LLVMValueRef RHS, const char *Name)
'BuildICmp'⎕NA'P ',Core,'|',P,'BuildICmp P U P P <0C'

⍝ LLVMValueRef
⍝ LLVMBuildArrayAlloca (LLVMBuilderRef,
⍝     LLVMTypeRef Ty, LLVMValueRef Val, const char *Name)
'BuildArrayAlloca'⎕NA'P ',Core,'|',P,'BuildArrayAlloca P P P <0C'

⍝ LLVMValueRef 	LLVMGetParam (LLVMValueRef Fn, unsigned Index)
'GetParam'⎕NA'P ',Core,'|',P,'GetParam P U'

⍝ unsigned 	LLVMCountParams (LLVMValueRef Fn)
'CountParams'⎕NA'U ',Core,'|',P,'CountParams P'

⍝ LLVMBool
⍝ LLVMPrintModuleToFile (LLVMModuleRef M, const char *Filename, char **ErrorMessage)
'PrintModuleToFile'⎕NA'I4 ',Core,'|',P,'PrintModuleToFile P <0C >P'

⍝ void LLVMDisposeMessage (char *Message)
'DisposeMessage'⎕NA Core,'|',P,'DisposeMessage P'

⍝ LLVMContextRef 	LLVMGetGlobalContext (void)
'GetGlobalContext'⎕NA 'P ',Core,'|',P,'GetGlobalContext'

⍝ LLVMModuleRef LLVMModuleCreateWithName (const char *ModuleID)
'ModuleCreateWithName'⎕NA'P ',Core,'|',P,'ModuleCreateWithName <0C'

⍝ LLVMValueRef
⍝ LLVMAddAlias (LLVMModuleRef M, LLVMTypeRef Ty, LLVMValueRef Aliasee, const char *Name)
'AddAlias'⎕NA'P ',Core,'|',P,'AddAlias P P P <0C'

⍝ LLVMBool
⍝ LLVMCreateJITCompilerForModule (LLVMExecutionEngineRef *OutJIT,
⍝     LLVMModuleRef M, unsigned OptLevel, char **OutError)
'CreateJITCompilerForModule'⎕NA'I ',ExEng,'|',P,'CreateJITCompilerForModule >P P U >P'

⍝ LLVMGenericValueRef
⍝ LLVMRunFunction (LLVMExecutionEngineRef EE,
⍝     LLVMValueRef F, unsigned NumArgs, LLVMGenericValueRef *Args)
'RunFunction'⎕NA'P ',ExEng,'|',P,'RunFunction P P U <P[]'

⍝ void * LLVMGenericValueToPointer (LLVMGenericValueRef GenVal)
'GenericValueToPointer'⎕NA'P ',ExEng,'|',P,'GenericValueToPointer P'

⍝ void * LLVMGenericValueToPointer (LLVMGenericValueRef GenVal)
'GenericValueToInt'⎕NA'I ',ExEng,'|',P,'GenericValueToInt P I'

⍝ void LLVMDisposeGenericValue (LLVMGenericValueRef GenVal)
'DisposeGenericValue'⎕NA ExEng,'|',P,'DisposeGenericValue P'

⍝ LLVMBool
⍝ LLVMFindFunction (LLVMExecutionEngineRef EE, const char *Name, LLVMValueRef *OutFn)
'FindFunction'⎕NA'I ',ExEng,'|',P,'FindFunction P <0C >P'

⍝ void 	LLVMSetTarget (LLVMModuleRef M, const char *Triple)
'SetTarget'⎕NA Core,'|',P,'SetTarget P <0C'

⍝ #define 	LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##TargetInfo(void);
⍝ #define 	LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##Target(void);
⍝ #define 	LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##TargetMC(void);
('Initialize',Target,'TargetInfo')⎕NA X86Info,'|',P,'Initialize',Target,'TargetInfo'
('Initialize',Target,'Target')⎕NA X86CodeGen,'|',P,'Initialize',Target,'Target'
('Initialize',Target,'TargetMC')⎕NA X86Desc,'|',P,'Initialize',Target,'TargetMC'

⍝ void 	LLVMDumpModule (LLVMModuleRef M)
'DumpModule'⎕NA Core,'|',P,'DumpModule P'

⍝ void LLVMDumpType (LLVMValueRef Val)
'DumpType'⎕NA Core,'|',P,'DumpType P'

⍝ void ffi_get_data_int (int64_t *res, struct codfns_array *)
'ffi_get_data_int'⎕NA R,'|ffi_get_data_int >I8[] P'

⍝ void ffi_get_shape (uint32_t *res, struct codfns_array *)
'ffi_get_shape'⎕NA R,'|ffi_get_shape >U4[] P'

⍝ uint64_t ffi_get_size (struct codfns_array *)
'ffi_get_size'⎕NA 'U8 ',R,'|ffi_get_size P'

⍝ uint16_t ffi_get_rank (struct codfns_array *)
'ffi_get_rank'⎕NA 'U2 ',R,'|ffi_get_rank P'

⍝ int ffi_make_array(struct codfns_array **, uint16_t, uint64_t, uint32_t *, int64_t *)
'ffi_make_array'⎕NA 'I ',R,'|ffi_make_array >P U2 U8 <U4[] <I8[]'

⍝ void array_free(struct codfns_array *)
'array_free'⎕NA R,'|array_free P'

⍝ void *memcpy(void *dst, void *src, size_t size)
'cstring'⎕NA'libc.so.6|memcpy >C[] P P'

⍝ size_t strlen(char *str)
'strlen'⎕NA'P libc.so.6|strlen P'

⍝ void free(void *)
'free'⎕NA 'libc.so.6|free P'

⍝ Generate an Array value for everyone to use
ArrayTypeV←GenArrayType⍬

∇

:EndNamespace

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Notes on Style
⍝
⍝ ∘ Global variables are camel case
⍝ ∘ Local variables are lower case
⍝ ∘ Function bodies receive a two column code/comment layout
⍝ ∘ Comments of entire function body should align
⍝ ∘ All line comments start at column 40 with '⍝ '
⍝ ∘ Avoid needless bindings
⍝ ∘ Divide bindings based on clarity of documentation
⍝ ∘ Prefer tacit programming
⍝ ∘ Keep to 80 columns
⍝ ∘ Every global function must have an intended function documented in comments

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Notes on each increment development

⍝ Increment 1 Overview:
⍝
⍝ ∘ Support an empty namespace
⍝ ∘ Generate an empty LLVM Object to a file
⍝ ∘ Create passes Tokenize, GenLLVM, Parse
⍝ ∘ Add support for stimuli: Fix Break Eot Fnb Fne Fnf Lle Lls Nl Nse Nss
⍝
⍝ Handling of the Break Stimuli is automatic, and does not need to be handled
⍝ explicitly

⍝ Increment 2 Overview:
⍝
⍝ ∘ Support static global constants of integers
⍝ ∘ New Stimuli: N ← V { }
⍝ ∘ Support functions that return constants of integers
⍝ ∘ New Passes: KillLines, LiftConsts
⍝ ∘ Modified Passes: GenLLVM, Tokenize, Parse
⍝
⍝ GenLLVM Modifications:
⍝
⍝ ∘ Handle global arrays
⍝ ∘ Generate single basic block, one-statement function bodies that
⍝   reference a single global variable
⍝
⍝ Tokenize Modifications:
⍝
⍝ ∘ Integers
⍝ ∘ Variable names
⍝ ∘ Assignment
⍝ ∘ Braces
⍝
⍝ Parse Modifications:
⍝
⍝ ∘ Integer arrays
⍝ ∘ Constant expressions
⍝ ∘ Assignment to literal integer array expressions
⍝ ∘ Assignment to user-defined functions

⍝ Increment 3 Overview:
⍝
⍝ ∘ Implement all of top-level space
⍝ ∘ Top-level Stimuli: ⋄ ← Break Eot Fix Fnb Fne Fnf Lle Lls Nl
⍝   Nse Nss Vi Vfo Vu E Fe
⍝
⍝ Impact Analysis
⍝ ===============
⍝
⍝ IsFnb     Must be implemented to handle the Fnb stimuli.
⍝ ModToNS   Must be implemented.
⍝ Tokenize  Add support for the ⋄ token.
⍝ Parse     Must add support for the ⋄ stimuli.
⍝ GenFunc   Must add support for multiple names to a single function.
⍝ DropUnmd  Add a new pass to drop the unnamed functions that could
⍝           appear at the top-level.

⍝ Increment 4 Overview:
⍝
⍝ ∘ Complete all code to cover Bind ∊ NO states in the Functions space
⍝ ∘ Return a JIT'd or Fixed Namespace (Functions only)
⍝
⍝ Impact Analysis
⍝ ===============
⍝
⍝ These additions have mostly to do with handline a more complete body
⍝ of the function, which will require some additional changes in the
⍝ handling of Tokenize first and foremost to support the : token:
⍝
⍝   1. Update Tokenize to handle the : token
⍝
⍝ Furthermore, we now allow multi-line functions, which will require
⍝ extending how we parse functions currently. We can roughly divide this
⍝ into a series of stages. The first stage corresponds to handling the
⍝ { and } tokens and encapsulating the entire function space, which also
⍝ happens to fully deal with the 0th state of the Function Space.
⍝
⍝   2. Extend handling of { and } to deal with multi-line functions.
⍝
⍝ The next state that is left unfinished is the 1st state, which can be
⍝ handled separately, and should be used to dispatch into the rest of
⍝ the states.
⍝
⍝   3. Complete handling of Function State 1.
⍝
⍝ Function State 4 ( { Vu ) deals with a single unbound variable. We are
⍝ not dealing with any assignments here, which means that all behaviors
⍝ encapsulated by the state are subsumed by Function State 5 ( { E ).
⍝ So we can deal with Vu implicitly rather than explicitly. Function
⍝ State 2 needs to be dealt with explicitly, but the difference between
⍝ this and states 5 and 8 are a matter of the : token.
⍝
⍝   4. Deal with parsing the : token.
⍝
⍝ With this taken care of, we can handle all other cases of the state 2,
⍝ so we should clear that at this point.
⍝
⍝   5. Complete handling of parse state 2.
⍝
⍝ Once States 0 - 2 are cleared, states 5 and 8 fall out as the next
⍝ natural elements, so we should parse those next.
⍝
⍝   6. Complete parsing of function states 5 and 8.
⍝
⍝ This finally leaves only state 3, which is a simple case at the moment,
⍝ so we can complete the handling of state 3 now.
⍝
⍝   7. Complete parsing of function state 3.
⍝
⍝ At the completion of Step 7, we will have multi expression function bodies,
⍝ but without function bindings or nested functions. We will also have
⍝ conditional branching. We must first extend the compiler to handle
⍝ multiple expressions in the body of a function. We will allow expressions
⍝ to be either bound or not, but still constant. This means we will need to
⍝ extend the parser to handle top-level unbound expressions and function
⍝ level bound expressions.
⍝
⍝   8. Extend parser to handle more general constant expressions in both
⍝      function bodies and top-level.
⍝
⍝ This will also necessitate modifying DropUnmd to handle top-level
⍝ unbound expressions.
⍝
⍝   9. Extend DropUnmd pass to handle unbound top-level constant expressions.
⍝
⍝ Now we can extend the compiler to handle multiple expressions in the
⍝ function body. We should start with a new compiler pass to remove code
⍝ that will never be executed in the function, so that we do not need to
⍝ generate code for this.
⍝
⍝   10. Create a new compiler pass that eliminates any code in a function
⍝       body that will never be executed by the shape of the conditionals
⍝       and the bindings of the body.
⍝
⍝ At this point LiftConst will need to be modified to handle multiple
⍝ expressions in the body and to lift all of the constants in the
⍝ function body to the top-level.
⍝
⍝   11. Modify LiftConst to handle multiple expression function bodies
⍝       and to lift all of the constants in said body to the top-level,
⍝       but to keep the local bindings local.
⍝
⍝ Next GenFunc will need to be modified to handle multiple expressions in
⍝ a function body as well as conditional expressions.
⍝
⍝   12. Modify GenFunc to handle multiple constant expressions in a function
⍝       body and to handle branching in the system. This will require a
⍝       means of dealing with local bindings and the return value of expressions
⍝       and assignment as an expression and not as a statement.

⍝ Increment 5 Overview:
⍝
⍝ ∘ Support Expressions without nesting or selection:
⍝    0 empty
⍝    1 Fea
⍝    3 N
⍝    5 Va
⍝    6 Vna
⍝    7 Vnu
⍝    9 Fea N
⍝   10 Fea Va
⍝   11 Fea Vna
⍝   16 N Vnu
⍝
⍝ ∘ Only atomic Function Expressions:
⍝   0 empty
⍝
⍝ ∘ Basic scalar function primitives:
⍝   + - ÷ × | * ⍟ ⌈ ⌊ < ≤ = ≠ ≥ >
⍝
⍝ ∘ Basic structural primitives
⍝   ⍴ , ≡ ≢
⍝
⍝ ∘ Only over integers without overflow concerns
⍝
⍝ ∘ JIT'd namespace support
⍝
⍝ Steps for completing Increment 5
⍝ ────────────────────────────────
⍝
⍝ 1. Update Software Architecture with a function signature
⍝
⍝ 2. Update Tokenize with new stimuli: D[a] & M[a]
⍝    + - ÷ × | * ⍟ ⌈ ⌊ < ≤ = ≠ ≥ >
⍝
⍝ 3. Rewrite ParseFuncExpr to handle atomics
⍝
⍝ 4. Rewrite ParseExpr
⍝   a. Split on Function nodes
⍝   b. Enclose literals and variables
⍝   c. Apply nesting levels
⍝
⍝ 5. Make sure that ParseExpr has the right environment from the top-level
⍝    and from function bodies.
⍝
⍝ 6. Rewrite DropUnreached
⍝
⍝ 7. Adapt Liftconsts to handle new expression types and function expressions.
⍝
⍝ 8. Add a pass to insert allocations
⍝
⍝ 9. Add a pass to flatten function calls.
⍝
⍝ 10. Add a pass to convert free variables to environment references
⍝
⍝ 11. Add support for function calls in GenLlvm
⍝
⍝ 12. Add a pass to replace primitive function names with runtime names
⍝
⍝ 13. Fix ModToNs
⍝
⍝ 14. Implement runtime functions
⍝
⍝ 15. Update Software Architecture to include new attributes that were added
⍝
⍝ 16. Update ConvertArray to handle higher-ranked arrays
⍝
⍝ 17. Update FFI declarations to use multiple libraries so that things work on
⍝     OpenSuse
