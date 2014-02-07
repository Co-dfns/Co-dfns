⍝ CoDfns Namespace: Increment 3

:Namespace CoDfns

  ⎕IO ⎕ML←0 1

⍝ Platform Configuration
⍝ 
⍝ The following variables must be set correctly for the appropriate platform

Target←'X86'
TargetTriple←'x86_64-slackware-linux-gnu'

⍝ Fix
⍝
⍝ Intended Function: Accept a valid namespace script and return an 
⍝ equivalent namespace script, possibly exporting a module at the same 
⍝ time to the file named in the optional left argument.
⍝
⍝ Right argument: Valid namespace script, see ⎕FIX
⍝ Left argument: Optional character vector specifying filename
⍝ Output: Namespace equivalent to script, possibly an object equivalent as well
⍝ State: Context ← Top ⋄ Fix ← No
⍝ Return State: Context ← Top ⋄ Fix ← No

Fix←{
  ⍝ State: Fix ← Yes
  
  _←FFI∆INIT
  
  ⍝ Input Validation, Signal DOMAIN ERROR if not valid
  ~(,1)≡⍴⍴⍵:⎕SIGNAL 11
  ~∧/1≥⊃∘⍴∘⍴¨⍵:⎕SIGNAL 11
  ~∧/⊃,/' '=⊃∘(0∘⍴)∘⊂¨⍵:⎕SIGNAL 11
  
  ⍝ Identify Obj property
  ⍝ This is based on the arity of the Fix call
  ⍺←⊢ ⋄ Obj←⍺⊣''
  
  ⍝ We must handle the other transitions: 
  ⍝   Fnb → DOMAIN ERROR    → (Fix ← No)
  ⍝   Fnf → null            → (Obj ← Yes)
  ⍝   Fne → null            → (Obj ← Yes)
  IsFnb Obj:⎕SIGNAL 11
  
  ⍝ State: Namespace ← NOTSEEN ⋄ Eot ← No
  ⍝ At this stage, we can compile ⍵ without consideration 
  ⍝ to Fix or Obj properties into a single LLVM Module
  ⍝ State Transitions Handled by Compile: 
  ⍝   Eot → SYNTAX ERROR    → (Fix ← No)
  ⍝   Nl  → null            → (Obj ← No)
  ⍝   Nse → SYNTAX ERROR    → (Fix ← No)
  ⍝   Nss → null            → (Obj ← No ⋄ Namespace ← OPEN)
  Module Names←Compile ⍵

  ⍝ State: Namespace ← CLOSED ⋄ Eot ← Yes
  ⍝ Now we need only create the Namespace
  ⍝ And deal with the Obj property and states
  Namespace←Names ModToNS Module
  
  ⍝ State: Obj ← No
  ⍝ When Obj ← No we need only give a namespace 
  ''≡Obj:Namespace
  
  ⍝ State: Obj ← Yes
  ⍝ Must return the namespace and generate the 
  ⍝ module object as well.
  _←Obj ModToObj Module
  Namespace
}

⍝ IsFnb
⍝
⍝ Intended Function: Determine whether the given input is a valid 
⍝ filename or not.
⍝ 
⍝ For the moment, we just check to make sure that we are getting 
⍝ a valid string, and if so, we consider it valid.

IsFnb←{~(∧/' '=⊃0⍴⊂⍵)∧((,1)≡⍴⍴⍵)∧(1≡≡⍵)}

⍝ Compile
⍝
⍝ Intended Function: Compile the given Fix input into an LLVM Module.
⍝ 
⍝ Input: Valid Fix right argument
⍝ Output: Semantically equivalent LLVM Module and a (name, type) 
⍝   mapping of top-level bindings
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No
⍝ Return State: Namespace ← CLOSED ⋄ Eot ← Yes
⍝ 
⍝ Each of the passes of the compiler returns us to the same starting state, 
⍝ conceptually, but refines the details over and over again, returning a 
⍝ slightly different namespace than the one before.

Compile←{
  tks←Tokenize ⍵
  ast names←Parse   tks
  ast←KillLines     ast
  ast←DropUnmd      ast
  ast←DropUnreached ast
  ast←LiftConsts    ast
  mod←GenLLVM       ast
  mod names
}

⍝ ModToNS
⍝ 
⍝ Intended Function: Create a Namespace that provides access to an LLVM Module
⍝
⍝ Left Argument: A (name, type) mapping of top-level bindings
⍝ Right Argument: A valid LLVM Module
⍝ Output: A Namespace
⍝ State: Context ← Top ⋄ Namespace ← CLOSED ⋄ Eot ← Yes
⍝
⍝ An interesting restriction here is that we need to make sure that we do not 
⍝ have any bindings in the namespace that are not observably equivalent to 
⍝ those that we have in the given compiled namespace. This means that we 
⍝ cannot have any helper functions at the top level of our namespace. 
⍝ Furthermore, we have two types of values that we need to convert, those 
⍝ function types and the globals. The function types can be converted directly 
⍝ to function types, but the globals need to be niladic functions to ensure that 
⍝ they grab their values from the latest global state of the compiled module, 
⍝ rather than an old value.
⍝
⍝ XXX: At the moment this function only handles the functions that are 
⍝ exported by a namespace, and does not deal with the globals.

ModToNS←{
  ⍝ All of this starts with having a namespace where we can 
  ⍝ put all of these functions. 
  ⊢Ns←⎕NS⍬ ⍝ Create an Empty Namespace

  ⍝ We need to specify exactly what target triple we are using 
  ⍝ to do the compilation, which is done based on the value of 
  ⍝ the TargetTriple Global value. Before using the triple, however, it is 
  ⍝ necessary to ensure that we have initialized the appropriate target,
  ⍝ which is given by the Target global value.
  _←⍎'Initialize',Target,'TargetInfo'
  _←⍎'Initialize',Target,'Target'
  _←⍎'Initialize',Target,'TargetMC'
  _←SetTarget ⍵ TargetTriple

  ⍝ The execution engine is the primary thing which allows us 
  ⍝ to JIT a module. We store the main execution engine in Ee 
  ⍝ after creation. 
  C Eev Err←CreateJITCompilerForModule 1 ⍵ 0 1
  0≠C:(ErrorMessage ⊃Err)⎕SIGNAL 99
  Ee←⊃Eev

  ⍝ We use an operator here to build each function. This let's us capture 
  ⍝ the relevant state without worrying about mucking with the top-level 
  ⍝ of the namespace. 
  Fn←{
    Gv←RunFunction ⍺⍺ ⍵⍵ 0 0
    Z←ConvertArray GenericValueToPointer Gv
    _←DisposeGenericValue Gv
    Z
  }

  ⍝ We need to be able to extract out the value of a function, 
  ⍝ as this is needed by RunFunction in order to actually do 
  ⍝ any real work. To do this we use the FindFunction. However, 
  ⍝ the syntax of the FindFunction is less than ideal, so we 
  ⍝ wrap it in the function Fp to get us what we want.
  Fp←{
    C Fpv←FindFunction Ee ⍵ 1
    0≠C:'FUNCTION NOT FOUND'⎕SIGNAL 99
    ⊃Fpv
  }

  ⍝ Each function is described succinctly by the function 
  ⍝ returned by (Ee Fn Fp Fname) where Fname is one of the 
  ⍝ keys associated with the function type in ⍺. The trick 
  ⍝ is getting these into the namespace, which as yet does 
  ⍝ not have defined in it any of the appropriate names. 
  ⍝ This is, unfortunately, a case for ⍎. We have a function 
  ⍝ Add to do this for us. This will work for either functions 
  ⍝ or globals depending on how we invoke it.
  AddF←{0=⊃⍴⍵: 0 ⋄ F←Ee Fn (Fp ⍵) ⋄ ⎕←F ⋄ _←⍎'Ns.',⍵,'←F' ⋄ 0}

  ⍝ We can now add our appropriate functions and globals to our 
  ⍝ namespace.
  Ns⊣AddF¨(2=1⌷⍉⍺)/0⌷⍉⍺
}

⍝ ConvertArray
⍝
⍝ Intended Function: Convert an array from the Co-dfns compiler into an 
⍝ array suitable for use in the Dyalog APL Interpreter.
⍝
⍝ Right Argument: A pointer to the array
⍝ Output: A Dyalog Array

ConvertArray←{
  D←⊃FFIGetDataInt (S←FFIGetSize ⍵) ⍵ 
  ((2≤S)⊃⍬ S)⍴D
}

⍝ ModToObj
⍝
⍝ Intended Function: Generate a compiled object to the file given the LLVM Module
⍝ 
⍝ Left Argument: A filename
⍝ Right Argument: An LLVM Module
⍝ State: Context ← Top ⋄ Namespace ← CLOSED ⋄ Eot ← Yes
⍝ 
⍝ This is stubbed right now to just generate a regular text rather than a 
⍝ compiled object module

ModToObj←{
  r err←PrintModuleToFile ⍵ ⍺ 1
  1=r:(ErrorMessage ⊃err)⎕SIGNAL 99
  0 0⍴⍬
}

⍝ ErrorMessage
⍝ 
⍝ Intended Function: Return an array of the LLVM Error Message
⍝
⍝ Right argument: An error message pointer returned by an LLVM function
⍝ Output: A character vector

ErrorMessage←{
  len←strlen ⍵
  res←cstring len ⍵ len
  res⊣DisposeMessage ⍵
}

⍝ Tokenize
⍝
⍝ Intended Function: Convert a vector of character vectors or scalars to a valid 
⍝ AST with a Tokens root that is lexically equivalent modulo spaces.
⍝ 
⍝ Input: Right argument to Fix
⍝ Output: Tokens structure
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

Tokenize←{
  ⍝ Potential Stimuli: Eot Nl Nse Nss V N ← { } ⋄
  ⍝ 
  ⍝ The only real job of this pass is to get to these stimuli, not do anything
  ⍝ more with them.
  
  ⍝ Valid Variable characters
  VC←'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'
  VC,←'abcdefghijklmnopqrstuvwxyz'
  VC,←'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß'
  VC,←'àáâãäåæçèéêëìíîïðñòóôõöøùúûüþ'
  VC,←'∆⍙'
  VC,←'ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ'
  VCN←VC,NC←'0123456789'
  
  ⍝ Additional Characters in domain: ←{}⋄
  ⍝ 
  ⍝ The NC variable contains the decimal digits, used in both 
  ⍝ the N and V tokens. The Nl token is already parsed, so we 
  ⍝ do not do anything with that, and the Eot token is implicit 
  ⍝ as well.
  
  ⍝ Verify that we have only valid characters in use
  AC←VCN,'←{}:⋄ ⍝'
  ~∧/AC∊⍨⊃,/⍵:⎕SIGNAL 2

  ⍝ Divide into comment and code
  I←⍵⍳¨'⍝' ⋄ T←I↑¨⍵ ⋄ C←I↓¨⍵
  
  ⍝ Strip leading and trailing whitespace from each line
  T←((⌽∘(∨\)∘⌽¨T)∧∨\¨T←' '≠T)/¨T
  
  ⍝ Recognize :Namespace and :EndNamespace tokens, which 
  ⍝ must be on lines by themselves, split these off to 
  ⍝ prevent further processing and save for reassembly later.
  NSL←(NSB←T∊':Namespace' ':EndNamespace')/T
  NSI←NSB/⍳⍴T ⋄ TI←(~NSB)/⍳⍴T ⋄ T←(~NSB)/T
  
  ⍝ Tokenize each Namespace element
  ⍝ This makes NSL a vector of lines where each line is a vector of tokens
  NSL←{,⊂2 'Token' '' (2 2⍴'name' ⍵ 'class' 'delimiter')}¨NSL
  
  T←{
    ⍝ Special case when T is empty to make life easier
    0=⍴T:⍬

    ⍝ Split on and remove spaces
    T←{((⍴X)⍴1 0)/X←(2≠/' '=' ',⍵)⊂⍵}¨T
    
    ⍝ Split on ← { } ⋄ :
    T←{⊃,/(⊂⍬),⍵}¨{(B∨2≠/1,B←⍵∊'←{}⋄:')⊂⍵}¨¨T

    ⍝ At this point, all lines are split into tokens
    ⍝ Wrap each token in appropriate element:
    ⍝   Variables → Variable
    ⍝   Integer   → Number class ← 'int' 
    ⍝   ← ⋄ :     → Token class ← 'separator'
    ⍝   { }       → Token class ← 'delimiter'
  
    ⍝ We switch from lines to a single vector of tokens
    ⍝ Must preserve ability to construct lines
    ⍝ L: Count of tokens for each line
    ⍝ T: Vector of Tokens
    L←⊃∘⍴¨T ⋄ T←⊃,/T
    
    ⍝ Identifying the type of a token here can be
    ⍝ accomplished by checking the first character 
    ⍝ of the token:
    ⍝   Variable → T∊VC
    ⍝   Integer  → T∊NC
    ⍝   ← ⋄ :    → T∊'←⋄:'
    ⍝   { }      → T∊'{}'
    ⍝
    ⍝ Create a selection vector for each type of token
    Sv Si Sa Sd←(⊃¨T)∘∊¨VC NC '←⋄:' '{}'
    
    ⍝ Wrap each type in appropriate elements
    Tv←{1 4⍴2 'Variable' '' (1 2⍴'name' ⍵)}¨Sv/T
    Ti←{1 4⍴2 'Number' '' (2 2⍴'value' ⍵ 'class' 'int')}¨Si/T
    Ta←{1 4⍴2 'Token' '' (2 2⍴'name' ⍵ 'class' 'separator')}¨Sa/T
    Td←{1 4⍴2 'Token' '' (2 2⍴'name' ⍵ 'class' 'delimiter')}¨Sd/T
    
    ⍝ Indexes of each type in original
    Iv Ii Ia Id←Sv Si Sa Sd/¨⊂⍳+/L
    
    ⍝ Restore T to a vector of non-empty lines of tokens
    T←(⊃,/L↑¨1)⊂(Tv,Ti,Ta,Td)[⍋Iv,Ii,Ia,Id]
    
    ⍝ Restore the empty lines of T
    (T,(+/0=L)↑⊂⍬)[⍋((0≠L)/⍳⍴L),(0=L)/⍳⍴L]
  }⍬
  
  ⍝ Add the Namespace lines back
  T←(NSL,T)[⍋NSI,TI]
   
  ⍝ Wrap in Lines
  T←C {H←1 4⍴1 'Line' '' (1 2⍴'comment' ⍺) ⋄ 0=⊃⍴⍵:H ⋄ H⍪⊃⍪/⍵}¨T
  
  ⍝ Create and return Tokens tree
  0 'Tokens' '' MtA⍪⊃⍪/T
}

⍝ Utility Constants

⍝ An empty attribute table for AST
MtA←0 2⍴⊂''

⍝ An empty AST
MtAST←0 4⍴0 '' '' MtA

⍝ An Empty (Name, Type) Environment
MtNTE←0 2⍴'' 0

⍝ Utility Functions

⍝ Attr Prop AST: A vector of the values of a specific attribute
⍝
⍝ Prop is used to take an AST (⍵) and extract the values of 
⍝ an attribute (⍺) from all the nodes in the AST. It returns a
⍝ vector of these values.
Prop←{(¯1⌽P∊⊂⍺)/P←,↑⍵[;3]}

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

⍝ Parse
⍝
⍝ Intended Function: Convert a Tokens AST to a Namespace AST that is 
⍝ structurally equivalent and that preserves comments and line counts.
⍝ 
⍝ Input: Tokens tree
⍝ Output: Namespace AST, Top-level Names
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No
⍝
⍝ The top-level names are an important structure. In particular, they 
⍝ are a matrix of (name, type) records. The set of types are as follows:
⍝ 
⍝   0  Unknown Type
⍝   1  Array
⍝   2  Function
⍝   3  Monadic Operator
⍝   4  Dyadic Operator
⍝
⍝ The name should be a simple, valid APL variable in the form of a 
⍝ string (that is, a simple character vector).

Parse←{
  ⍝ Potential Stimuli: Eot Nl Nse Nss Vfo Vu N ← { }
  ⍝
  ⍝ State Transitions:
  ⍝   Eot → SYNTAX ERROR → (Fix ← No)
  ⍝   Nl  → null         → ()
  ⍝   Nse → SYNTAX ERROR → (Fix ← No)
  ⍝   Nss → null         → (Namespace ← OPEN)
  ⍝   Vfo → SYNTAX ERROR → ()
  ⍝   Vu  → SYNTAX ERROR → ()
  ⍝   N   → SYNTAX ERROR → ()
  ⍝   {   → SYNTAX ERROR → ()
  ⍝   }   → SYNTAX ERROR → ()
  ⍝
  ⍝ Trace: Tables 9 and 206 in Function Specification

  ⍝ Stimuli: Eot
  ⍝ This corresponds to an empty namespace
  ⍝ This means that there are no tokens, which we can 
  ⍝ check easily
  ⍝
  ⍝ Importantly, we can handle this here because there is
  ⍝ only one place that an Eot is legal, and in all other
  ⍝ cases it is a SYNTAX ERROR. Because all of the cases 
  ⍝ occur in a Top level context, we can handle them all 
  ⍝ here without further ado. The legal cases of Eot 
  ⍝ falls out implicitly.
  ⍝
  ⍝ Trace: Table 233 in Function Specification
  0=+/⍵[;1]∊⊂'Token':⎕SIGNAL 2
  
  ⍝ Stimuli: Nl
  ⍝
  ⍝ Empty lines don't matter, and Nl has already been 
  ⍝ parsed for us by Tokenize, so there is no need to deal 
  ⍝ with this explicitly. We leave the empty or comment
  ⍝ only lines around for idempotency's sake
  ⍝
  ⍝ Trace: Table 243 in Function Specification
  ⍝
  ⍝ In the above table, we see that in all cases, the Nl 
  ⍝ is a partitioning form that serves only to partition 
  ⍝ the state-space of other stimuli and their possible 
  ⍝ occurances. We can determine the proper result without 
  ⍝ requiring explicit handling of the Nl stimuli. 
  ⍝ Thus, we need to do no explicit parsing here for Nl.

  ⍝ Stimuli: Nss and Nse
  ⍝ Trace: Tables 233, 244, 245, and 206 in Function Specification
  ⍝ Properties handled: Eot and Namespace
  ⍝
  ⍝ The only cases where we may have a valid Nse the Namespace is OPEN,
  ⍝ which happens when we see an Nss. Nothing else will change this state. 
  ⍝ The response of encountering an Nse token depends on the values of 
  ⍝ the previous elements, and only on them, so we can trigger those errors 
  ⍝ at a later time, when we care to process them. However, if we have only 
  ⍝ Nss or only Nse it is clearly a SYNTAX ERROR. So, at this point, we can 
  ⍝ eliminate the need to consider the Namespace property entirely by 
  ⍝ parsing out the Nss and Nse tokens here. After this the only properties 
  ⍝ that must be handled at the top-level Context are the Value and 
  ⍝ Named properties. 
  ⍝
  ⍝ Firstly, we need to test that the beginning and end are both 
  ⍝ Nss and Nse tokens.
  FL←⊃1 ¯1⍪.↑⊂⍵ ByDepth 2
  ~FL[;1]∧.≡⊂'Token':⎕SIGNAL 2
  ~':Namespace' ':EndNamespace'∧.≡'name' Prop FL:⎕SIGNAL 2
  
  ⍝ Secondly, we must ensure that there are not more than two Nss and Nse 
  ⍝ tokens combined either, or it is also a syntax error
  N←'name' Prop ⍵ ByElem 'Token'
  2≠+/N∊':Namespace' ':EndNamespace':⎕SIGNAL 2
  
  ⍝ Parse out the Nss and Nse tokens
  ⍝ This corresponds to lifting the tokens to part of the structure
  ⍝ This changes the root from Tokens to Namespace
  ⍝ We remove both the Line that contains the single namespace 
  ⍝ token as well as the token itself. We take advantage of the 
  ⍝ assumption that a namespace token must appear on a line 
  ⍝ by itself.
  NS←0 'Namespace' '' (1 2⍴'name' '')
  NS⍪←⍵[1↓(⍳⊃⍴⍵)~I,¯1+I←(⊂[1]⍵)⍳⊂[1]FL;]
  
  ⍝ Stimuli: ⋄
  ⍝
  ⍝ The ⋄ token is treated just the same as an Nl for all intents 
  ⍝ and purposes. However, the Tokenizer will not have broken these 
  ⍝ out implicitly like it has for Nl due to the way the input 
  ⍝ format works. 
  ⍝ 
  ⍝ Trace: Table 219 in Function Specification
  ⍝ 
  ⍝ We can examine each of the cases illustrated by the above table 
  ⍝ and note the same as with Nl. It thus suffices to convert all 
  ⍝ ⋄ tokens to Nl lines. In the tree, converting each ⋄ Token node 
  ⍝ to a Line node has this effect, and is a safe transformation 
  ⍝ because a Token node has no children, and stores no additional 
  ⍝ information that needs to be restored.
  ⍝
  ⍝ XXX: The following transformation does not adequately preserve 
  ⍝ commenting behavior.
  I←(('name' Prop B⌿NS)∊⊂,'⋄')/(B←NS[;1]∊⊂'Token')/⍳⊃⍴NS
  NS[I;]←((⍴I),4)⍴1 'Line' '' MtA

  ⍝ Stimuli: { }
  ⍝
  ⍝ The { and } stimuli delimit only function bodies, and nothing else. 
  ⍝ Moreover, they must be balanced or a syntax error occurs. It is also 
  ⍝ the only valid way to continue from Funtion State 0. Because of these 
  ⍝ natural features of the way that the { and } stimuli occur, this allows 
  ⍝ a complete removal of them from the set of tokens early on, provided 
  ⍝ that we allow for a single internal extension to the public AST 
  ⍝ restriction. If we allow for lines to contain not only token values, 
  ⍝ but also Function subtrees, then we can convert all { and } stimuli 
  ⍝ into Function nodes that themselves contain Line nodes. This, of course, 
  ⍝ works recursively. 
  ⍝ 
  ⍝ At this point the NS variable contains a namespace tree of shallow 
  ⍝ depth containing all Line nodes with various tokens in each line. 
  ⍝ This gives a maximum depth of 2. We divide the basic operation into 
  ⍝ two steps: 
  ⍝
  ⍝ 1. Adapt all depths of the nodes to ensure that the depth of each node 
  ⍝    is incremented by two for each un-closed { that appears prior to the
  ⍝    token in the token stream. Fm is the map of { and } tokens, where 
  ⍝    a 1 is for any { token, and a ¯1 for any } token, and 0 for everything 
  ⍝    else.
  Fm←((1⌷⍉NS)∊⊂'Token')×{1 ¯1 0⌷⍨(,¨'{}')⍳((0⌷⍉⍵)⍳⊂'name')⌷(1⌷⍉⍵),⊂''}¨3⌷⍉NS
  _←⍎'⎕SIGNAL(0≠+/Fm)/2 ⋄ ⍬ '
  NS[;0]+←2×Fd←+\0,¯1↓Fm

  ⍝ 2. Delete the { and } token nodes to insert a Function node at the 
  ⍝    { token location. Additionally, insert a child node Line under the 
  ⍝    Function node to hold the rest of the tokens on the same line as 
  ⍝    the { token but appearing after it. Accomplished through Ci and Fi, 
  ⍝    the index vectors of the Children and Function nodes, respectively. 
  Fi←(1=Fm)/⍳⍴Fm ⋄ Ci←((1⌽B)∧B←0≠Fd)/⍳⍴Fd
  NS[1+Ci;]←NS[Ci;]
  NS[Fi;1+⍳3]←((⍴Fi),3)⍴'Function' '' (1 2⍴'class' 'ambivalent')
  NS[1+Fi;]←(NS[Fi;0]+1),((⍴Fi),3)⍴'Line' '' MtA

  ⍝ Now we have handled all { and } stimuli and do not need to consider 
  ⍝ them again; they have been replaced with the appropriate Function 
  ⍝ nodes. 
  
  ⍝ State: Namespace ← OPEN ⋄ Eot ← No
  ⍝ Stimuli already handled by this point or that do not need handling: 
  ⍝   Eot Fix Fnb Fne Fnf Nl Nse Nss Break ⋄ { }
  ⍝ Stimuli to consider: Vfo Vu N ← E Fe
  ⍝
  ⍝ At this point we have a series of abstract Line nodes which are either
  ⍝ empty, contain an expression or a function. The previous handling of 
  ⍝ { and } stimuli means that we can still treat Functions as occuring 
  ⍝ on a single line, and that any lines that they have inside of them are 
  ⍝ "internal" to the function and do not affect the top-level.
  ⍝ If we look at the set of states in the 
  ⍝ top-level (Table 206) we will see that all of the Namespace ← OPEN
  ⍝ states either error out on Nl or they return back to the 
  ⍝ Namespace ← OPEN state which is right here. Thus, each line 
  ⍝ can be processed individually from one another as they all just 
  ⍝ come back here anyways. 
  ⍝ 
  ⍝ Trace: Tables 11 through 22 in Function Specification dealing with 
  ⍝ Fix Nss prefixes.
  ⍝
  ⍝ We rely on a helper function at this point which is designed to 
  ⍝ handle all of the cases when we have a Namespace ← Open property.
  
  ⍝ Our overall strategy here is to reduce over the lines from top to bottom, 
  ⍝ eventually resulting in our final namespace. Each call to ParseTopLine will 
  ⍝ return an extended namespace and a new environment containing the bindings 
  ⍝ that have been created so far. 
  ⍝
  ⍝ To begin with, we need to start with an empty environment and an empty 
  ⍝ AST. This is our Seed value.
  SD←(0 4⍴⍬)MtNTE
  
  ⍝ We note that all sub-trees of the the main Tokens AST at this point
  ⍝ are lines.  All other nodes types are at depth 2 or greater. We assume
  ⍝ here that the tree consists of a single root node of depth 0 and that
  ⍝ there are no other depth 0 nodes appearing anywhere else.  Finally, we
  ⍝ use ParseTopLine to reduce over the lines, extracting out the final
  ⍝ namespace. At this point, the namespace will not have the appropriate
  ⍝ head on it, which we stripped off above. We put this back on to form
  ⍝ the final, correctly parsed AST. The AST is now a Namespace AST and
  ⍝ each line has been converted into an apropriate node, or left alone if
  ⍝ it is an empty line.
  NS←(1↑NS)⍪⊃A E←⊃ParseTopLine/⌽(⊂SD),1 Kids NS
  
  ⍝ We return the final environment created by the ParseTopLine function and 
  ⍝ the final Namespace AST. 
  NS E
}

⍝ ParseTopLine
⍝
⍝ Intended Function: Given a Top-level Line sub-tree, parse it into one of
⍝ Expression, Function, or FuncExpr sub-tree at the same depth.
⍝
⍝ Right Argument: Code lines already parsed, Names environment
⍝ Left Argument: Current Line sub-tree to process
⍝ Output: (Code extended by Line, Expression, Function, or FuncExpr)
⍝         (New [name,type] environment)
⍝ Invariant: Depth of input and output sub-trees should be the same
⍝ Invariant: Comment of the line should be transferred to the output node
⍝ Invariant: Should be able to reconstruct the original input from output
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← OPEN ⋄ Eot ← No
⍝ Return state: Same as entry state.

ParseTopLine←{C E←⍵
  ⍝ Possible stimuli: Vfo Vu N ← E Fe
  ⍝ 
  ⍝ We are only considering the Value and Named states in this function.
  ⍝ That is to say, the Context, Namespace and Eot states should stay the 
  ⍝ same throughout this function. While the literal stimuli that we 
  ⍝ consider above are the only ones that can appear, we are also implicitly 
  ⍝ dealing with the Nl stimuli.
  ⍝   
  ⍝ State Transitions:
  ⍝   E        → null         → (Value ← EXPR)
  ⍝   E Nl     → null         → ()
  ⍝   Fe       → null         → (Value ← FUNC ⋄ Named ← No)
  ⍝   Fe Nl    → null         → ()
  ⍝   ←        → SYNTAX ERROR → ()
  ⍝   Vfo      → null         → (Value ← FUNC ⋄ Named ← MAYBE)
  ⍝   Vfo Nl   → null         → ()
  ⍝   Vfo ←    → null         → (Named ← BOUND)
  ⍝   Vu       → null         → (Value ← UNBOUND ⋄ Named ← MAYBE)
  ⍝   Vu Nl    → VALUE ERROR  → ()
  ⍝   Vu ←     → null         → (Named ← UNBOUND)
  ⍝
  ⍝ Trace: Tables 11-15, 18-22, 206 in Function Specification 
  
  ⍝ Dealing with Empty Lines
  ⍝ We might have an empty line with no tokens. In this case, we can 
  ⍝ just return the line, as there is nothing to do for this 
  ⍝ line.
  1=⊃⍴⍺:(C⍪⍺)E
  
  ⍝ Regardless of what we do, we need to have the comment to put on the 
  ⍝ new head of the sub-tree that we will return.
  cmt←⊃'comment' Prop 1↑⍺
  
  ⍝ Stimuli: E Fe
  ⍝ Stimuli indirectly processed: N { }
  ⍝
  ⍝ States to process: E, Fe, E Nl, Fe Nl, Vfo Nl, Vu Nl
  ⍝
  ⍝ The first stimuli to eliminate if possible is the recursive stimuli, 
  ⍝ which, if it parses correctly, is all we need do. Since we are dealing 
  ⍝ with an implicit Nl, then ParseExpr and ParseFuncExpr will give us the 
  ⍝ results both for E and Fe states, but for E Nl and Fe Nl. Since these 
  ⍝ are the only reasonable transitions from E and Fe states, this also means 
  ⍝ that we have properly handled the E and Fe transitions from the above table.
  ⍝
  ⍝ We also have the happy situation of handling the Vfo Nl and Vu Nl states, as 
  ⍝ both of these are really subsumed members of the set of parses of E Nl and Fe Nl. 
  ⍝ Thus we can eliminate these states as well from needing further treatment. 
  ⍝ We are not quite done with the handling fo the Vu and Vfo states, however, as 
  ⍝ the state-space clearly has more to handle as can be seen from the above table. 
  0=⊃eerr ast Ne←E ParseExpr 1↓⍺:(C⍪ast Comment cmt)Ne
  0=⊃ferr ast rst Ne←E ParseFuncExpr 1↓⍺:(C⍪ast Comment cmt)Ne
  
  ⍝ At this point we have only to deal with variables. This happens to be a situation 
  ⍝ that we encounter fairly often, so we abstract this into another function.
  0=⊃err ast Ne←E 0 ParseLineVar 1↓⍺:(C⍪ast Comment cmt)Ne
  
  ⍝ When the error is best taken from one of the recursive stimuli (see ParseLineVar 
  ⍝ documentation) then we will use the expression error code, as it is the one most 
  ⍝ likely to be useful.
  ¯1=×err:⎕SIGNAL eerr
  
  ⎕SIGNAL err
}

⍝ ParseLineVar
⍝
⍝ Intended Function: Process variable stimuli that can occur when processing a 
⍝ top-level line.
⍝
⍝ This function exists because we need to use it in more than one place.
⍝ ParseLineVar can be safely used whenever the state transitions in the current 
⍝ state result in the same state change as given in the transition table below.
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
⍝         (New [name,type] environment)
⍝ Invariant: Depth of input and output sub-trees should be the same
⍝ Invariant: Should be able to reconstruct the original input from output
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← OPEN ⋄ Eot ← No
⍝ Return state: Same as entry state.

ParseLineVar←{E SC←⍺
  ⍝ State Transitions (State Class 0):
  ⍝   ←      → SYNTAX ERROR → ()
  ⍝   Vfo    → null         → (Value ← FUNC    ⋄ Named ← MAYBE)
  ⍝   Vfo Nl → null         → (Value ← EMPTY   ⋄ Named ← EMPTY)
  ⍝   Vfo ←  → null         → (Value ← EMPTY   ⋄ Named ← BOUND)
  ⍝   Vu     → null         → (Value ← UNBOUND ⋄ Named ← MAYBE)
  ⍝   Vu Nl  → VALUE ERROR  → ()
  ⍝   Vu ←   → null         → (Value ← EMPTY   ⋄ Named ← UNBOUND)
  ⍝
  ⍝ State Transitions (State Class 1):
  ⍝   ←      → SYNTAX ERROR → ()
  ⍝   Vfo    → null         → (Value ← FUNC    ⋄ Named ← MAYBE)
  ⍝   Vfo Nl → null         → (Value ← EMPTY   ⋄ Named ← EMPTY)
  ⍝   Vfo ←  → null         → (Value ← EMPTY   ⋄ Named ← BOUND)
  ⍝   Vu     → null         → (Value ← UNBOUND ⋄ Named ← BOUND)
  ⍝   Vu Nl  → VALUE ERROR  → ()
  ⍝   Vu ←   → null         → (Value ← EMPTY   ⋄ Named ← BOUND)
  ⍝
  ⍝ Trace: Tables 11-15, 18-22, 206 in Function Specification 
  ⍝
  ⍝ The Nl suffixed states are assumed to have been already handled implicitly 
  ⍝ by the caller of ParseLineVar. See ParseLine.

  ⍝ Stimuli: Vfo Vu ←
  ⍝
  ⍝ States to Process: Vfo, Vu, Vfo ←, Vu ←
  ⍝
  ⍝ After the above, there are only a few situations we can be in. All the other states 
  ⍝ described in Table 206 are tied in one way or another to the ← token. Most of them 
  ⍝ have ← directly in their names, but the Vfo and Vu states are partially handled by the 
  ⍝ above handling, and the only other situations we can have which make sense, 
  ⍝ are not illegal, and not otherwise subsumed by the above are the assignment cases. 
  ⍝
  ⍝ This handling of the assignment statement is really a case of handling the 
  ⍝ Named property. We can have either BOUND or UNBOUND states. The MAYBE state 
  ⍝ will be unused here. 
  ⍝
  ⍝ The first possibility is that we have no variable to be named, in which case we need 
  ⍝ to signal a SYNTAX ERROR.
  '←'≡⊃'name'Prop 1↑⍵:2 MtAST E
  
  ⍝ The only non-error cases that make any sense at this point are either Vfo ← or Vu ←, 
  ⍝ so we can check to make sure that we have at least 3 tokens, any less than that 
  ⍝ would indicate either Vfo ← Nl or some other error case. 
  3>⊃⍴⍵:¯1 MtAST E
  
  ⍝ If we have at least three tokens to deal with, then the first two should be an 
  ⍝ assignment token and a variable token. Let's make sure that this is what we 
  ⍝ actually have, otherwise, we should signal an error again.
  ~'Variable' 'Token'∧.≡⍵[0 1;1]:¯1 MtAST E
  (,'←')≢⊃'name' Prop 1 4⍴1⌷⍵:¯1 MtAST E
  
  ⍝ Now we need to determine whether the variable is a Vfo or a Vu.
  Tp←E VarType⊢Vn←⊃'name'Prop 1 4⍴0⌷⍵

  ⍝ If the type of the variable is Vu, then we have 
  ⍝ the Named ← UNBOUND when we have State Class ← 0
  (0=Tp)∧(SC=0):0,Vn E ParseNamedUnB 2↓⍵
  
  ⍝ If we have a Vfo, then the Named ← BOUND
  ⍝ and when we have State Class ← 1 with a Vu
  ⍝ XXX In this case, because we know that we only have types 
  ⍝ of 2, then we can make sure that we give a type of 2 to 
  ⍝ the ParseNamedBnd call. In the future, we will need to make 
  ⍝ sure that we know what the real type of the variable is for 
  ⍝ State Class ← 1. We will also have to make sure that the 
  ⍝ types are in the appropriate nameclass if we have another 
  ⍝ class in the stack already.
  (2 3 4∨.=Tp)∨(0=Tp)∧(SC=1):0,Vn 2 E ParseNamedBnd 2↓⍵
  
  ⍝ If we do not have a Vfo or Vu, then something is wrong and we should error out
  ¯1 MtAST E
}

⍝ ParseNamedUnB
⍝
⍝ Intended Function: Parse an assignment to an unbound variable.
⍝
⍝ Right Argument: Non-empty matrix of Token and Function nodes
⍝ Left Argument: Variable Name, [Name,Type] Environment
⍝ Invariant: Input should have at least one row.
⍝ Output: FuncExpr Node, [Name,Type] Environment
⍝ State: Context ← Top ⋄ Value ← EMPTY ⋄ Named ← UNBOUND
⍝ Return State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← OPEN ⋄ Eot ← No

ParseNamedUnB←{Vn E←⍺
  ⍝ Possible stimuli: Fe Vfo Vu ←
  ⍝ Indirectly processed: { }
  ⍝
  ⍝ Trace: Table 19, 22, 206 in Function Specification
  ⍝
  ⍝ State Transitions:
  ⍝   Fe    → null         → (Value ← FUNC    ⋄ Named ← UNBOUND)
  ⍝   Fe Nl → null         → ()
  ⍝   Vfo   → null         → (Value ← FUNC    ⋄ Named ← MAYBE)
  ⍝   Vu    → null         → (Value ← UNBOUND ⋄ Named ← MAYBE)
  ⍝   ←     → SYNTAX ERROR → ()
  
  ⍝ Stimuli: Fe
  ⍝ 
  ⍝ We begin by directly addressing the Fe possibility, which has only a 
  ⍝ single valid follow-up from here, which is to end the line. 
  ⍝ In this case, we take the function expression and give it the name 
  ⍝ given to us. This further requires updating the environment and returning
  ⍝ that together with the new node.
  0=⊃ferr ast rst Ne←E ParseFuncExpr ⍵:(Vn Bind ast)(Vn 2⍪Ne)
  
  ⍝ Stimuli: Vfo Vu ←
  ⍝
  ⍝ If we could not successfully parse as a function expression, the only 
  ⍝ other valid, non-error option is the Vfo or Vu prefixes. However, in this
  ⍝ case we have a state exactly like that handled by the ParseLineVar function
  ⍝ above. The only thing we need to remember to do is to add the extra variable 
  ⍝ name that is given to us.
  0=⊃err ast Ne←E 0 ParseLineVar ⍵:(Vn Bind ast)(Vn 2⍪Ne)
  
  ¯1=×err:⎕SIGNAL ferr
  ⎕SIGNAL err
}

⍝ ParseNamedBnd
⍝
⍝ Intended Function: Parse an assignment to a bound variable.
⍝
⍝ Right Argument: Non-empty matrix of Token and Function nodes
⍝ Left Argument: Variable Name, Variable Type, [Name,Type] Environment
⍝ Invariant: Input should have at least one row.
⍝ Output: FuncExpr Node, [Name,Type] Environment
⍝ State: Context ← Top ⋄ Value ← EMPTY ⋄ Named ← BOUND
⍝ Return State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← OPEN ⋄ Eot ← No

ParseNamedBnd←{Vn Tp E←⍺
  ⍝ Possible stimuli: Fe Vfo Vu ←
  ⍝ Indirectly processed: { }
  ⍝
  ⍝ Trace: Table 18, 20, 21, 206 in Function Specification
  ⍝
  ⍝ State Transitions:
  ⍝   E     → SYNTAX ERROR → ()
  ⍝   Fe    → null         → (Value ← FUNC    ⋄ Named ← BOUND)
  ⍝   Fe Nl → null         → (Value ← EMPTY   ⋄ Named ← EMPTY)
  ⍝   Vfo   → null         → (Value ← FUNC    ⋄ Named ← MAYBE)
  ⍝   Vu    → null         → (Value ← UNBOUND ⋄ Named ← BOUND)
  ⍝   Vu Nl → SYNTAX ERROR → ()
  ⍝   Vu ←  → null         → (Value ← EMPTY   ⋄ Named ← BOUND)
  ⍝   ←     → SYNTAX ERROR → ()
  
  ⍝ Stimuli: E
  ⍝
  ⍝ If we are Named ← BOUND then we need to make sure that we do not have 
  ⍝ a binding to a different nameclass. Namely, a binding from an expression
  ⍝ to a function, operator, or the like.
  0=⊃E ParseExpr ⍵:⎕SIGNAL 2

  ⍝ Stimuli: Fe
  ⍝ 
  ⍝ When we parse a function expression successfully, we still need to 
  ⍝ ensure that the type of the variable matches the type of the function 
  ⍝ expression, but at least this time, we have a chance of it succeeding.
  ⍝ If it does succeed, we simply need to add the name and move on.
  T←2 ⋄ ferr ast rst Ne←E ParseFuncExpr ⍵
  (0=ferr)∧Tp=T:(Vn Bind ast)(Vn Tp⍪Ne)
  Tp≠T:⎕SIGNAL 2
  
  ⍝ Stimuli: Vfo Vu ←
  ⍝
  ⍝ The handling of the Fe stimuli will have covered both the Fe states and 
  ⍝ the Vfo Nl state, as in the Value ← EMPTY ⋄ Named ← EMPTY case handled in 
  ⍝ ParseTopLine. We must handle the Vu Nl state explicitly here, and then we are 
  ⍝ left only with the states handled by ParseLineVar, except that we need to call 
  ⍝ it with a state class of 1 instead of 0.
  (1=⊃⍴⍵)∧('Variable'≡⊃0 1⌷⍵)∧(0=E VarType⊃'name'Prop 1↑⍵):⎕SIGNAL 6
  0=⊃err ast Ne←E 1 ParseLineVar ⍵:(Vn Bind ast)(Vn Tp⍪Ne)
  
  ¯1=×err:⎕SIGNAL ferr
  ⎕SIGNAL err
}

⍝ ParseExpr
⍝
⍝ Intended Function: Take a set of tokens and an environment of types 
⍝ and parse it as an expression, returning an error code, ast, and a new, 
⍝ updated environment of types.
⍝
⍝ Right Argument: Matrix of Token and Function nodes
⍝ Left Argument: [Name,Type] Environment
⍝ Output: (0 or Exception #)(Expression Node)(New [Name,Type] Environment)
⍝ Invariant: Depth of the output should be the same as the input
⍝ State: Context ← Expr ⋄ Nest ← NONE ⋄ Class ← ATOM ⋄ Last Seen ← EMPTY

ParseExpr←{
  ⍝ Possible Stimuli: N Va Vnu ←
  ⍝
  ⍝ State Transitions:
  ⍝   N          → atomic       → (Last Seen ← LIT)
  ⍝   N N        → atomic       → (Last Seen ← LIT)
  ⍝   Va         → atomic       → (Last Seen ← VAR)
  ⍝   Va ←       → wait         → (Class ← FUNC)
  ⍝   Vnu        → wait         → (Last Seen ← UVAR)
  ⍝   Vnu Nl     → SYNTAX ERROR → ()
  ⍝   Vnu ←      → wait         → (Class ← FUNC ⋄ Last Seen ← EMPTY)
  ⍝   Vnu ← Va   → okay         → (Class ← FUNC ⋄ Last Seen ← VAR)
  ⍝   Vnu ← Vnu  → wait         → (Last Seen ← UVAR ⋄ Class ← ATOM)
  ⍝
  ⍝ For Increment 4 we are handling only arrays of integers, which might 
  ⍝ possibly have a name. Thus, we can handle all of our cases by only 
  ⍝ checking for a name first, and then handling the integers separately.

  ⍝ Do we have an empty expression?
  0=⊃⍴⍵:2 MtAST ⍺
  
  ⍝ Check for a name, and parse as appropriate if we have a name
  'Variable'≡⊃0 1⌷⍵:⍺{
    ⍝ Verify that we have an assignment
    ~2≤⊃⍴⍵:2 MtAST ⍺
    ~('Token'≡⊃1 1⌷⍵)∧((,'←')≡⊃'name'Prop 1↑1↓⍵):2 MtAST ⍺

    ⍝ Parse the rest as an expression
    err ast Ne←⍺ ParseExpr 2↓⍵
    
    ⍝ If we are successful in that, then we need to bind the 
    ⍝ parsed expression with the name given in the variable.
    nm←⊃'name'Prop 1↑⍵
    0=err:err (nm Bind ast) ((nm 1)⍪Ne)
    
    ⍝ Otherwise, we can just pass it through
    err MtAST ⍺
  }⍵
  
  ⍝ If we do not have a name then we should only have integers, so let's 
  ⍝ check for that.
  ~(1⌷⍉⍵)∧.≡⊂'Number':2 MtAST ⍺
  
  ⍝ As long as we have all number tokens, we can easily construct the 
  ⍝ appropriate expression node on top of it. The depth of the expression 
  ⍝ is one less than the depth of all the tokens that we assume to all 
  ⍝ be of the same depth.
  X←(¯1+⊃⍵) 'Expression' '' (1 2⍴'class' 'atomic')⍪⍵

  ⍝ At the moment, there is no change to the environment possible, so 
  ⍝ we pass it through
  0 X ⍺
}

⍝ ParseFuncExpr
⍝ 
⍝ Intended Function: Take a set of tokens and an environment of types 
⍝ and parse it as a function expression, returning an error code, ast, and a new, 
⍝ updated environment of types.
⍝
⍝ Right Argument: Matrix of Token and Function nodes
⍝ Left Argument: [Name,Type] Environment
⍝ Output: (0 or Exception #)(FuncExpr AST)(Rest of Input)(New [Name,Type] Environment)
⍝ Invariant: Depth of the output should be the same as the input
⍝ State: Context ← Fnex ⋄ Opnd ← NONE ⋄ Oper ← NONE ⋄ Axis ← NO ⋄ Nest ← NONE ⋄ Tgt ← No

ParseFuncExpr←{
  ⍝ Possible Stimuli: Fn
  ⍝ Indirectly processed Stimuli: N
  ⍝
  ⍝ The only possibility that we have right now is that of an user defined constant 
  ⍝ function, so we will just call that right here.
  0≠⊃err ast rst←⍺ ParseFunc ⍵:err ast rst ⍺
  
  ⍝ The only thing we can have at this point is a function, so we just handle that 
  ⍝ here directly.
  Fn←(¯1+⊃⍵) 'FuncExpr' '' (2 2⍴'class' 'ambivalent' 'equiv' 'ambivalent')
  
  0 (Fn⍪ast) rst ⍺
}

⍝ ParseFunc
⍝
⍝ Intended Function: Take a set of tokens and parse them as an user-defined 
⍝ ambivalent function, monadic or dyadic operator.
⍝
⍝ Right Argument: Non-empty matrix of Token and Function nodes
⍝ Left Argument: [Name,Type] Environment
⍝ Output: (0 or Exception #)(Function AST)(Rest of Input)
⍝ Invariant: Depth of the output should be the same as the input
⍝ Invariant: Right argument must have at least one row
⍝ State: Context ← Func ⋄ Bracket ← No ⋄ Cond ← No ⋄ Bind ← NO ⋄ Value ← EMPTY

ParseFunc←{
  ⍝ Possible Stimuli: E : Vfo Vu
  ⍝ Indirectly processed stimuli: N
  ⍝
  ⍝ Trace: Tables 23 - 28 and 31 of Function Specification
  ⍝
  ⍝ In Parse, the { and } stimuli have already been processed and used 
  ⍝ to construct nested forms of the lines. The ParseFunc therefore must 
  ⍝ check to ensure that the next node (token) to process is a Function 
  ⍝ node and convert the body of the function from a series of Line nodes
  ⍝ to a proper function body. Firstly, we must check to determine whether
  ⍝ we have a Function node.
  'Function'≢⊃0 1⌷⍵:2 MtAST ⍵

  ⍝ The rest of the nodes to parse are children of the Function node, 
  ⍝ so extract out just the Function node from the rest of the tokens.
  Fb←(Fm←1=+\(Fd←⊃⍵)=D←0⌷⍉⍵)⌿⍵

  ⍝ State: Bracket ← Yes ⋄ Cond ← No ⋄ Bind ← NO ⋄ Value ← EMPTY
  ⍝ 
  ⍝ State Transitions:
  ⍝   E     → wait → (Value ← EXPR)
  ⍝   E :   → wait → (Cond ← Yes ⋄ Value ← EMPTY)
  ⍝   E : E → wait → (Value ← EXPR)
  ⍝   Vfo   → wait → (Value ← FVAR)
  ⍝   Vu    → wait → (Value ← UNBOUND)
  ⍝   :     → SYNTAX ERROR → ()
  ⍝   }     → okay         → ()
  ⍝ 
  ⍝ At this point we can use a similar technique to that used at the 
  ⍝ top level and reduce over all the lines to collect up a final AST. 
  ⍝ At the end we can replace the Fb contents (marked out by Fm) with 
  ⍝ the AST that was created. This requires a ParseFnLine function.
  ⍝ Note that the } Stimuli which could appear here for an empty function 
  ⍝ gets implicitly handled.

  ⍝ To begin with, we need to start with an empty environment and an empty 
  ⍝ AST. This is our Seed value.
  Sd←(0 4⍴⍬)MtNTE
  
  ⍝ We partition the AST into the appropriate sub-trees, each of which should 
  ⍝ correspond to a single line. All Lines we care about are at depth Fd+1.
  Cn←((Fd+1)=0⌷⍉Fb)⊂[0]Fb
  
  ⍝ Finally, we use ParseFnLine to reduce over the lines.
  ⍝ At this point, the function will not have the appropriate root on 
  ⍝ it, which we stripped off above. We put this back on to form the final, 
  ⍝ correctly parsed Function. Fn is now a Function node and each line has been 
  ⍝ converted into an apropriate node, or left alone if it is an empty line.
   2:: 2 MtAST ⍵
  11::11 MtAST ⍵
  99::99 MtAST ⍵
  Fn←(1↑Fb)⍪⊃A E←⊃ParseFnLine/⌽(⊂Sd),Cn
  
  ⍝ We return the function node together with the rest of the nodes after 
  ⍝ it. 
  0 Fn ((~Fm)⌿⍵)
}

⍝ ParseFnLine
⍝
⍝ Intended Function: Given a Function Line sub-tree, parse it into one of
⍝ Expression, FuncExpr, Condition, or Guard sub-tree at the same depth.
⍝
⍝ Right Argument: Code lines already parsed, Names environment
⍝ Left Argument: Current Line sub-tree to process
⍝ Output: (Code extended by Line, Expression, FuncExpr, Condition, or Guard)
⍝         (New [name,type] environment)
⍝ Invariant: Depth of input and output sub-trees should be the same
⍝ Invariant: Comment of the line should be transferred to the output node
⍝ Invariant: Should be able to reconstruct the original input from output
⍝ State: Context ← Func ⋄ Bracket ← Yes ⋄ Cond ← No ⋄ Bind ← NO ⋄ Value ← EMPTY
⍝ Return state: Same as entry state.

ParseFnLine←{C E←⍵
  ⍝ State: Bracket ← Yes ⋄ Cond ← No ⋄ Bind ← NO ⋄ Value ← EMPTY
  ⍝ 
  ⍝ State Transitions:
  ⍝   E     → wait         → (Value ← EXPR)
  ⍝   E :   → wait         → (Cond ← Yes ⋄ Value ← EMPTY)
  ⍝   E : E → wait         → (Value ← EXPR)
  ⍝   Vfo   → wait         → (Value ← FVAR)
  ⍝   Vu    → wait         → (Value ← UNBOUND)
  ⍝   :     → SYNTAX ERROR → ()

  ⍝ Dealing with Empty Lines / Handling Immediate } Stimuli
  ⍝ We might have an empty line with no tokens. In this case, we can 
  ⍝ just return the line, as there is nothing to do for this 
  ⍝ line.
  1=⊃⍴⍺:(C⍪⍺)E
  
  ⍝ Regardless of what we do, we need to have the comment to put on the 
  ⍝ new head of the sub-tree that we will return.
  cmt←⊃'comment' Prop 1↑⍺
  
  ⍝ Stimuli: :
  ⍝
  ⍝ A line may contain at most one : stimuli. If one occurs, we know exactly 
  ⍝ what we must have, but if we do not, then we have one of E, Vfo, or Vu. 
  Cm←{(,':')≡((0⌷⍉⍵)⍳⊂'name')⊃(1⌷⍉⍵),⊂''}¨3⌷⍉⍺ ⍝ All name attributes ≡,':'
  Cnd←+/Cm←((1+⊃⍺)=0⌷⍉⍺)×((1⌷⍉⍺)∊⊂'Token')×Cm  ⍝ Only direct child Tokens
  1<Cnd:⎕SIGNAL 2                               ⍝ Too many : tokens
  1=1⌷Cm:⎕SIGNAL 2                              ⍝ Empty test clause
  1=Cnd:((C⍪A)E)⊣A E←⊃E ParseCond/¯1↓¨(1,1↓Cm)⊂[0]1⊖⍺
  0≠Cnd:'Unexpected : Token Count'⎕SIGNAL 99
  
  ⍝ At this point, we have handled line terminators (Nl and ⋄) as well as 
  ⍝ all closing } stimuli. We have also eliminated Stimuli : . Function 
  ⍝ States 0, 1, 5, 8 have all been processed by the code above. That 
  ⍝ leaves the following states:
  ⍝
  ⍝   State # │ Canonical Sequence
  ⍝   ────────┼───────────────────
  ⍝         2 │ { E
  ⍝         3 │ { Vfo
  ⍝         4 │ { Vu
  ⍝   ────────┴───────────────────
  ⍝
  ⍝ Basically, state 3 at this point, because we do not have 
  ⍝ assignments, can be nothing but a SYNTAX ERROR (see Table 26 
  ⍝ in the Function Specification). State 4 (Table 27) can be nothing 
  ⍝ more than a VALUE ERROR, and is completely subsumed by state 2 
  ⍝ (Table 25). Thus, checking for a valid E stimuli at this point 
  ⍝ suffices to answer all questions and complete the handling of these 
  ⍝ tables completely. 
  0≠⊃err ast Ne←E ParseExpr 1↓⍺:⎕SIGNAL err
  (C⍪ast)Ne        
}

⍝ ParseCond
⍝
⍝ Intended Function: Construct a Condition node from two expressions 
⍝ representing a conditional line in a function body.
⍝
⍝ Left Operand: Current (name, type) environment
⍝ Right argument: Tokens representing the consequent expression
⍝ Left argument: Tokens representing the test expression
⍝ Output: (Condition node)(New [name, type] environment)
⍝ Invariant: Test expression is non-empty
⍝ Invariant: Condition node depth is one less than token depth
⍝ State: Context ← Func ⋄ Bracket ← Yes ⋄ Cond ← Yes ⋄ Bind ← NO ⋄ Value ← EMPTY

ParseCond←{
  ⍝ ParseFnLine calls ParseCond without knowing whether the test expression 
  ⍝ parses to a valid expression. Verify this first.
  0≠⊃err ast Ne←⍺⍺ ParseExpr ⍺:⎕SIGNAL err

  ⍝ Depths of ast need to be bumped since they are going into a condition 
  ⍝ node.
  ast[;0]+←1

  ⍝ Return a Condition node
  H←(¯1+⊃⍺)'Condition' '' MtA

  ⍝ Refer to Tables 28 and 31 in Function Specification; parse a valid or 
  ⍝ empty expression, as all other cases are subsumed. This covers 
  ⍝ Function States 5 and 8. 
  0=⊃⍴⍵:(H⍪ast)Ne
  0≠⊃err con Ne←Ne ParseExpr ⍵:⎕SIGNAL err
  con[;0]+←1 ⍝ Bump the consequence depth as well
  (H⍪ast⍪con)Ne
}

⍝ KillLines
⍝
⍝ Intended Function: Eliminate all semantically irrelevant lines from AST 
⍝ to create an AST suitable for compiling. 
⍝
⍝ Right argument: Namespace AST
⍝ Output: Namespace AST
⍝ Invariant: Result contains no Line elements
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

KillLines←{
  ⍝ The only case when we keep a line around in the parser is 
  ⍝ when the line is empty. This means that we can eliminate all 
  ⍝ the Line nodes from the tree by compressing the Line rows, 
  ⍝ since we are guaranteed not to have any children in the Line 
  ⍝ nodes.
  (~⍵[;1]∊⊂'Line')⌿⍵
}

⍝ DropUnmd
⍝
⍝ Intended Function: Drop all unnamed expressions or functions from the 
⍝ top-level.
⍝
⍝ Right argument: Namespace AST
⍝ Output: Namespace AST
⍝ Invariant: All FuncExpr and Expression nodes at the top-level 
⍝   have a non-empty, valid name attribute upon output.
⍝ Invariant: All top-level nodes are either FuncExpr or Expresssion 
⍝   nodes; particularly, there are no Line nodes.
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

DropUnmd←{
  ⍝ At this point in our program, we will have removed all lines from 
  ⍝ the program and will have only Expression or FuncExpr nodes at 
  ⍝ the level 1 of the tree. Thus, we can take all level 1 nodes and 
  ⍝ extract the names from those nodes, to get a boolean mask about which 
  ⍝ Nodes to keep and which not to keep. At this point, we can use 
  ⍝ this to select out all of the nodes by enclosing each of the 
  ⍝ depth 1 sub-trees and then recombining the ones that are left 
  ⍝ after the selection.
  Nm←{⊃(((0⌷⍉⍵)∊⊂'name')/1⌷⍉⍵),⊂''}¨(1=0⌷⍉⍵)/3⌷⍉⍵
  (0⌷⍵)⍪⊃⍪/(⊂MtAST),(0≠⊃∘⍴¨Nm)/1 Kids ⍵
}

⍝ DropUnreached
⍝
⍝ Intended Function: Simplify function bodies to remove code that is 
⍝ obviously not reachable.
⍝
⍝ Right argument: Namespace AST
⍝ Output: Namespace AST
⍝ Invariant: Output and input are semantically the same.
⍝ Invariant: Function bodies are the only sub-trees which may have altered nodes.
⍝ Invarient: Function bodies may have less nodes on output.
⍝ state: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No
⍝
⍝ Assume for now that all functions appear in FuncExpr nodes at the top
⍝ level and do not contain any nested functions. This is sort of a stub 
⍝ function, and will require additional reworking further down the line.

DropUnreached←{
  ⍝ Generate a mask covering all depth 3 nodes before and including
  ⍝ first unnamed Expression node.
  Msk←{~∨\0,1↓¯1⌽((⍺/1⌷⍉⍵)∊⊂'Expression')×{~(⊂'name')∊0⌷⍉⍵}¨⍺/3⌷⍉⍵}

  ⍝ Drop all function body nodes after first unnamed expression node
  Drp←{(2↑⍵)⍪⊃⍪/(⊂MtAST),(Nm Msk ⍵)/(Nm←3=0⌷⍉⍵)⊂[0]⍵}

  ⍝ Shortcut when there are no children
  1=⊃⍴⍵:⍵

  ⍝ Apply Drp to all top-level functions and recombine results
  (1↑⍵)⍪⊃⍪/(⊂MtAST),{'FuncExpr'≡⊃0 1⌷⍵:Drp ⍵ ⋄ ⍵}¨1 Kids ⍵
}

⍝ LiftConsts
⍝
⍝ Intended Function: Remove all constants from all depths to ensure that 
⍝ there exist constant values only at the top level. 
⍝
⍝ Right argument: Namespace AST
⍝ Output: Namespace AST
⍝ Invariant: Function Expressions appear only at top-level
⍝ Invariant: Expressions contain only integers
⍝ Invariant: Functions contain only Expressions or Conditions
⍝ Invariant: FuncExpr nodes contain only a single Function node
⍝ Invariant: FuncExpr nodes always contain a Function node
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

LiftConsts←{
  I←¯1 ⋄ MkV←{(⊃I)+←1 ⋄ 'LC',⍕I}

  ⍝ Note: By the invariants, processing expressions of any sort does 
  ⍝ not depend on any other sibling or parent nodes.

  ⍝ Lifting an expression generates two new expressions: a top-level 
  ⍝ expression binding the literal to a newly generated global name, 
  ⍝ and the previous expression will all Number nodes replaced by a single 
  ⍝ Variable node referring to the global name. 
  TpExpr←{1 'Expression' '' (2 2⍴'class' 'atomic' 'name' ⍺)⍪2,¯3↑[1]1↓⍵}
  SbExpr←{(1↑⍵)⍪(1+⊃⍵) 'Variable' '' (2 2⍴'name' ⍺ 'class' 'array')}
  Expr←{(V TpExpr ⍵)(V SbExpr ⍵)⊣V←MkV⍬}

  ⍝ Lifting a Condition node is just the lifting of it's expressions, 
  ⍝ merging the results.
  Cond←{⍪⌿↑(⊂MtAST(1↑⍵)),Expr¨1 Kids ⍵}

  ⍝ Lifting a Function Expression generates a new set of top-level 
  ⍝ nodes binding the constants in the body of the function to fresh 
  ⍝ top-level names, while substituting each constant with a variable 
  ⍝ in a newly formed Function Expression node.
  FnEx←{⊃⍪/⍪⌿↑(⊂MtAST(2↑⍵)),{'Expression'≡⊃0 1⌷⍵⍪0 '' '' MtA:Expr ⍵ ⋄ Cond ⍵}¨C←2 Kids ⍵}

  ⍝ Shortcut when Namespace is empty
  1=⊃⍴⍵:⍵

  ⍝ Each top-level FuncExpr needs to be processed, and then recombined 
  ⍝ to form the final output. 
  ⊃⍪/(⊂1↑⍵),Z←{'FuncExpr'≡⊃0 1⌷⍵:FnEx ⍵ ⋄ ⍵}¨C←1 Kids ⍵
}

⍝ GenLLVM
⍝
⍝ Intended Function: Take a namespace and convert it to an LLVM Module that is 
⍝ semantically equivalent.
⍝ 
⍝ Input: Namespace AST
⍝ Output: Semantically equivalent LLVM Module
⍝ Invariant: All FuncExpr nodes appear at top-level
⍝ Invariant: All FuncExpr nodes contain a single Function node
⍝ Invariant: All FuncExpr nodes have names
⍝ Invariant: Function nodes contain either Condition or Expression nodes
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

GenLLVM←{
  ⍝ Stimuli: Nss Nse 
  
  ⍝ The Nss Nse pair triggers the start of a module creation
  ⍝ We know that this is all that we have there right now, 
  ⍝ so we just create a single empty module.
  ⍝ If the namespace has a name then we use it, otherwise, 
  ⍝ not.
  
  ⍝ Extracting the name assumes that the first row of the 
  ⍝ AST is the namespace node and that the Namespace 
  ⍝ element contains only a single attribute, name, 
  ⍝ and that it is never without this attribute.
  Nam←Nam 'Unamed Namespace'⌷⍨''≡Nam←((0 3)(0 1)⊃⍵)
  Mod←ModuleCreateWithName Nam
  
  ⍝ Quit if nothing to do
  0=⍴G←1 Kids ⍵:Mod
  
  ⍝ For each global we general some code
  Mod⊣Mod∘GenGlobal¨G
}

⍝ GenGlobal
⍝
⍝ Intended Function: Take a global expression and generate a new
⍝ binding in the module.
⍝
⍝ Left Argument: LLVM Module
⍝ Right Argument: Global Value

GenGlobal←{
  ⍝ There are two types of globals, Expression constants and Functions
  ⍝ We will use a specific helper for each.
  'Expression'≡⊃0 1⌷⍵:⍺ GenConst ⍵
  'FuncExpr'≡⊃0 1⌷⍵:⍺ GenFunc ⍵
  ⎕SIGNAL 99
}

⍝ GenConst
⍝
⍝ Intended Function: Given an Expression node that has only constant 
⍝ data in it, generate a global LLVM Constant and insert it into the 
⍝ LLVM Module given.
⍝
⍝ Left Argument: LLVM Module
⍝ Right Argument: Expression Node
⍝
⍝ See the Software Architecture for details on the array structure.

GenConst←{
  ⍝ An Expression node will contain a single array in it. Get these 
  ⍝ values into V. We note that V should have the same shape 
  ⍝ as the shape of the expression. Here V can either be a 
  ⍝ vector of at least two elements or it can be a single scalar.
  ⍝ The literal syntax allows for none others than this.
  V←((2≤⍴V)⊃⍬(⍴V))⍴V←'value'Prop 1↓⍵

  ⍝ Encapsulate the process of generating an array pointer 
  ArrayP←{
    A←ConstArray ⍺⍺ ⍵ (⊃⍴⍵)
    G←AddGlobal ⍺ (ArrayType ⍺⍺ (⊃⍴⍵)) ⍵⍵
    _←SetInitializer G A
    P←BuildGEP (B←CreateBuilder) G (GEPI 0 0) 2 ''
    P⊣DisposeBuilder B
  }
  
  ⍝ Generate LLVM Data Array from Values
  D←⍺(Int64Type ArrayP 'elems'){ConstIntOfString (Int64Type) ⍵ 10}¨,V

  ⍝ Shape of the array is a single element vector 
  ⍝ Make sure that the shape of the array is based off 
  ⍝ of V and not off of D.
  S←⍺(Int32Type ArrayP 'shape'){0=⍴⍵:⍬ ⋄ {ConstInt (Int32Type) ⍵ 0}¨⍵}⍴V

  ⍝ Rank is constant
  ⍝ Rank must also come from V and not D
  R←ConstInt (Int16Type) (⊃⍴⍴V) 0

  ⍝ Size is a function of the number of elements in V
  ⍝ which is really the size of D, or the length of ,V
  Sz←ConstInt (Int64Type) (⊃⍴,V) 0

  ⍝ For now we have a constant type
  T←ConstInt (Int8Type) 2 0

  ⍝ Get all the names of the expression from the 
  ⍝ name property, which is a space separated set of 
  ⍝ names, see Software Architecture
  Vs←(B/2≠/' '=' ',Vs)⊂(B←' '≠Vs)/Vs←⊃'name'Prop 1↑⍵

  ⍝ We can put this all together now and insert it into the 
  ⍝ Module
  A←ConstStruct (R Sz T S D) 5 0
  G←AddGlobal ⍺(T←GenArrayType⍬)(⊃Vs)
  _←SetInitializer G A

  ⍝ Alias all the rest of the names to the same value
  val←GetNamedGlobal ⍺(⊃Vs)
  0=⍴1↓Vs:val
  val⊣⍺{AddAlias ⍺ T val ⍵}¨1↓Vs
}

⍝ GenFunc
⍝
⍝ Intended Function: Given a FuncExpr node, build an appropriate 
⍝ Function in the LLVM Module given.
⍝
⍝ Left Argument: LLVM Module
⍝ Right Argument: FuncExpr Node

GenFunc←{
  ⍝ The name list of the function expression
  fn←⊃'name'Prop 1↑⍵

  ⍝ Function expressions can have multiple names, canonical name first.
  ⍝ Convert the space separated name list fn to a vector of names, then
  ⍝ let fnf be the canonical name and fnr the rest of them. The following
  ⍝ assumes that function expressions have names.
  fnf fnr←(⊃fn)(1↓fn←(nsp/2≠/' '=' ',fn)⊂(nsp←' '≠fn)/fn)

  ⍝ Create function using canonical name
  fr←AddFunction ⍺ fnf (ft←GenFuncType ⍬)

  ⍝ Each node of the function body can use the same builder.
  bldr←CreateBuilder

  ⍝ Functions all require at least a single basic block to 
  ⍝ start, using the above builder.
  bb←AppendBasicBlock fr ''
  _←PositionBuilderAtEnd bldr bb

  ⍝ Generate the code for each function body node.
  ⍝ We use 2 here because a FuncExpr node contains a single 
  ⍝ Function node; we want the children of the Function node.
  Line←{N←⊃0 1⌷⍺
    N≡'Expression':⍺(⍺⍺ GenExpr)⍵
    N≡'Condition':⍺(⍺⍺ GenCond)⍵
    'UNKNOWN FUNCTION CHILD'⎕SIGNAL 99
  }
  _ V←⊃⍺ fr bldr Line/⌽(⊂⍬ ⍬),K←2 Kids ⍵

  ⍝ It may be that there are no children. This still requires at 
  ⍝ least one statement in the basic block. We also need an empty 
  ⍝ return when the last expression was a Condition node. 
  ⍝ In the case of the last node being a named Expression, we 
  ⍝ should return that expression.
  _←{
    0=⊃⍴⍵:MkEmptyReturn bldr
    'Condition'≡⊃0 1⌷L←⊃⌽⍵:MkEmptyReturn bldr
    2=⍴'name'Prop L:BuildRet bldr (⊃⌽V)
    ⍵
  }K

  _←DisposeBuilder bldr

  ⍝ Alias the function to any of the other names, if any exist.
  0=⍴fnr:Shy←fr
  fr⊣⍺{AddAlias ⍺ ft fr ⍵}¨fnr
}

⍝ GetExpr
⍝
⍝ Intended Function: Convert an Expression node into an LLVM Value
⍝
⍝ Right argument: (Bound Names)(Name Values)
⍝ Left Argument: Expression node
⍝ Left Operand: LLVM Module
⍝ Output: (LLVM Value)(Bound Names)(Name Values)

GetExpr←{
  ⍝ When there are no names to bind, the return is simple. 
  ⍝ At this point, we know that all expressions must be 
  ⍝ references to global bindings.
  1=⍴Vs←'name'Prop ⍺:⍵,⍨GetNamedGlobal ⍺⍺ (⊃Vs)

  ⍝ In the binding case, we need to take the names to be 
  ⍝ bound and associate each of those names with the global 
  ⍝ in our environment.
  e←GetNamedGlobal ⍺⍺ (⊃⌽Vs)
  nu←(B/2≠/' '=' ',nu)⊂(B←' '≠nu)/nu←⊃Vs
  (e)(k,nu)(v,e⍴⍨⍴nu)⊣k v←⍵
}


⍝ GenCond
⍝
⍝ Intended Function: Generate code for a Condition node.
⍝
⍝ Right argument: (Bound Names)(Name Values)
⍝ Left Argument: Condition node to generate
⍝ Left Operand: (LLVM Module)(LLVM Function Reference)(LLVM Builder)
⍝ Output: (Bound Names)(Name Values)

GenCond←{mod fr bldr←⍺⍺
  ⍝ A condition node has one or two expressions 
  Ex←1 Kids ⍺
  
  ⍝ We assume type correct expressions right now,
  ⍝ meaning we can just grab the first data value for
  ⍝ comparison. Tv should be a single integer value.
  Te nm vl←(⊃Ex)(mod GetExpr)⍵
  Tp←BuildLoad bldr(BuildStructGEP bldr Te 4 '')'Tp'
  Tp←BuildBitCast bldr Tp (PointerType(ArrayType Int64Type 1)0)''
  Tv←BuildLoad bldr(BuildGEP bldr Tp (GEPI 0 0) 2 '')'Tv'

  ⍝ Create the test of Tv to conclude the block
  T←BuildICmp bldr 32 Tv(ConstInt Int64Type 0 1)'T'

  ⍝ Create the (simple) consequent block, which is a single 
  ⍝ return of either no value or the expression value.
  _←PositionBuilderAtEnd bldr,cb←AppendBasicBlock fr 'consequent'
  _←(1↓Ex)(⍺⍺ GenConsequent)nm vl
  _←(1↓Ex)(⍺⍺{0=⍴⍺:MkEmptyReturn bldr ⋄ (⊃⍺)(⍺⍺ GenExpr)⍵})nm vl
  
  ⍝ Create the alternate block and setup the builder to 
  ⍝ point to it.
  ob←GetPreviousBasicBlock cb
  ab←AppendBasicBlock fr 'alternate'
  _←PositionBuilderAtEnd bldr ob
  _←BuildCondBr bldr T ab cb
  _←PositionBuilderAtEnd bldr ab

  nm vl
}

⍝ GenConsequent
⍝
⍝ Intended Function: Build the Consequent of a Condition node.
⍝
⍝ Right Argument: (Bound names)(Name values)
⍝ Left Argument: Vector with Expression node to generate
⍝ Left Operand: (LLVM Module)(LLVM Function Reference)(LLVM Builder)

GenConsequent←{mod fr bldr←⍺⍺
  ⍝ There are three basic cases:
  ⍝   1. Empty Consequent
  ⍝   2. Unnamed consequent
  ⍝   3. Named Consequent

  ⍝ 1. Empty Consequent -- Null return
  0=⍴⍺:MkEmptyReturn bldr

  ⍝ For both #2 and #3, we must generate the expression.
  K V←(⊃⍺)(⍺⍺ GenExpr)⍵

  ⍝ 2. Unnamed Consequent -- Nothing futher, return already generated
  1=⍴'name'Prop⊃⍺:⍬
  
  ⍝ 3. Named Consequent -- Must generate return explicitly
  2=⍴'name'Prop⊃⍺:BuildRet bldr(⊃⌽V)
  'UNREACHABLE'⎕SIGNAL 99
}


⍝ GenExpr
⍝
⍝ Intended Function: Generate an Expression, named or unnamed.
⍝ 
⍝ Right Argument: (Bound names)(Name values)
⍝ Left Argument: Expression node to generate
⍝ Left Operand: (LLVM Module)(LLVM Function Reference)(LLVM Builder)
⍝ Output: (Bound Names)(Name Values)

GenExpr←{mod _ bldr←⍺⍺
  1=⍴'name'Prop ⍺:⍵⊣BuildRet bldr,⊃⍺(mod GetExpr)⍵
  1↓⍺(mod GetExpr)⍵
}

⍝ MkEmptyReturn
⍝
⍝ Intended Function: Insert an empty return value for a function 
⍝ into a builder.
⍝ 
⍝ Right argument: LLVM Builder

MkEmptyReturn←{
  T←PointerType (GenArrayType⍬) 0
  V←ConstPointerNull T
  BuildRet ⍵ V
}

⍝ GenArrayType
⍝
⍝ Intended Function: Constant function returning the type of an 
⍝ array.
⍝ 
⍝ See the Software Architecture for details on the Array Structure.

GenArrayType←{
  D←PointerType (Int64Type) 0
  S←PointerType (Int32Type) 0
  lt←(Int16Type)(Int64Type)(Int8Type) S D
  StructType lt 5 0
}

⍝ GenFuncType
⍝
⍝ Intended Function: A constant function returning the type of a 
⍝ Function.
⍝
⍝ See the Software Architecture for details on the Function convention.
⍝
⍝ For now this is just a stub assuming a constant function that returns 
⍝ an array.

GenFuncType←{
  FunctionType (PointerType (GenArrayType ⍬) 0) ⍬ 0 0
}

⍝ GEPIndices
⍝
⍝ Intended Function: Generate an array of pointers to be used as 
⍝ inputs to the BuildGEP function.

GEPI←{{ConstInt (Int32Type) ⍵ 0}¨⍵}

⍝ Foreign Functions

∇{Z}←FFI∆INIT;P;D
Z←⍬
D←'libLLVM-3.3.so'
R←'./libcodfns.so'
P←'LLVM'

⍝ LLVMTypeRef LLVMInt8Type (void)
'Int8Type'⎕NA 'P ',D,'|',P,'Int8Type'

⍝ LLVMTypeRef  LLVMInt16Type (void) 
'Int16Type'⎕NA 'P ',D,'|',P,'Int16Type'

⍝ LLVMTypeRef  LLVMInt32Type (void) 
'Int32Type'⎕NA 'P ',D,'|',P,'Int32Type'

⍝ LLVMTypeRef  LLVMInt64Type (void) 
'Int64Type'⎕NA 'P ',D,'|',P,'Int64Type'

⍝ LLVMTypeRef  
⍝ LLVMFunctionType (LLVMTypeRef ReturnType, 
⍝    LLVMTypeRef *ParamTypes, unsigned ParamCount, LLVMBool IsVarArg) 
'FunctionType'⎕NA 'P ',D,'|',P,'FunctionType P <P[] U I'

⍝ LLVMTypeRef 
⍝ LLVMStructType (LLVMTypeRef *ElementTypes, unsigned ElementCount, LLVMBool Packed) 
'StructType'⎕NA 'P ',D,'|',P,'StructType <P[] U I'

⍝ LLVMPointerType (LLVMTypeRef ElementType, unsigned AddressSpace)
'PointerType'⎕NA 'P ',D,'|',P,'PointerType P U'

⍝ LLVMTypeRef 	LLVMArrayType (LLVMTypeRef ElementType, unsigned ElementCount)
'ArrayType'⎕NA'P ',D,'|',P,'ArrayType P U'

⍝ LLVMValueRef  LLVMConstInt (LLVMTypeRef IntTy, unsigned long long N, LLVMBool SignExtend) 
'ConstInt'⎕NA 'P ',D,'|',P,'ConstInt P U8 I'

⍝ LLVMValueRef  LLVMConstIntOfString (LLVMTypeRef IntTy, const char *Text, uint8_t Radix) 
'ConstIntOfString'⎕NA 'P ',D,'|',P,'ConstIntOfString P <0C[] U8'

⍝ LLVMValueRef
⍝ LLVMConstArray (LLVMTypeRef ElementTy, LLVMValueRef *ConstantVals, unsigned Length) 
'ConstArray'⎕NA 'P ',D,'|',P,'ConstArray P <P[] U'

⍝ LLVMValueRef 	LLVMConstPointerNull (LLVMTypeRef Ty)
'ConstPointerNull'⎕NA'P ',D,'|',P,'ConstPointerNull P'

⍝ LLVMValueRef  LLVMAddGlobal (LLVMModuleRef M, LLVMTypeRef Ty, const char *Name) 
'AddGlobal'⎕NA 'P ',D,'|',P,'AddGlobal P P <0C[]'

⍝ void  LLVMSetInitializer (LLVMValueRef GlobalVar, LLVMValueRef ConstantVal) 
'SetInitializer'⎕NA '',D,'|',P,'SetInitializer P P'

⍝ LLVMValueRef  LLVMAddFunction (LLVMModuleRef M, const char *Name, LLVMTypeRef FunctionTy) 
'AddFunction'⎕NA 'P ',D,'|',P,'AddFunction P <0C[] P'

⍝ LLVMValueRef  LLVMGetNamedGlobal (LLVMModuleRef M, const char *Name) 
'GetNamedGlobal'⎕NA 'P ',D,'|',P,'GetNamedGlobal P <0C[]'

⍝ LLVMBasicBlockRef  LLVMAppendBasicBlock (LLVMValueRef Fn, const char *Name) 
'AppendBasicBlock'⎕NA 'P ',D,'|',P,'AppendBasicBlock P <0C[]'

⍝ LLVMBuilderRef  LLVMCreateBuilder (void) 
'CreateBuilder'⎕NA 'P ',D,'|',P,'CreateBuilder'

⍝ void  LLVMPositionBuilderAtEnd (LLVMBuilderRef Builder, LLVMBasicBlockRef Block) 
'PositionBuilderAtEnd'⎕NA 'P ',D,'|',P,'PositionBuilderAtEnd P P'

⍝ LLVMValueRef  LLVMBuildRet (LLVMBuilderRef, LLVMValueRef V) 
'BuildRet'⎕NA'P ',D,'|',P,'BuildRet P P'

⍝ LLVMValueRef 	LLVMBuildRetVoid (LLVMBuilderRef)
'BuildRetVoid'⎕NA'P ',D,'|',P,'BuildRetVoid P'

⍝ LLVMValueRef 	LLVMBuildCondBr (LLVMBuilderRef, LLVMValueRef If, LLVMBasicBlockRef Then, LLVMBasicBlockRef Else)
'BuildCondBr'⎕NA'P ',D,'|',P,'BuildCondBr P P P P'

⍝ void  LLVMDisposeBuilder (LLVMBuilderRef Builder) 
'DisposeBuilder'⎕NA 'P ',D,'|',P,'DisposeBuilder P'

⍝ LLVMValueRef
⍝ LLVMConstStruct (LLVMValueRef *ConstantVals, unsigned Count, LLVMBool Packed) 
'ConstStruct'⎕NA'P ',D,'|',P,'ConstStruct <P[] U I'

⍝ LLVMValueRef 	LLVMBuildAlloca (LLVMBuilderRef, LLVMTypeRef Ty, const char *Name)
'BuildAlloca'⎕NA'P ',D,'|',P,'BuildAlloca P P <0C'

⍝ LLVMValueRef 	LLVMBuildLoad (LLVMBuilderRef, LLVMValueRef PointerVal, const char *Name)
'BuildLoad'⎕NA'P ',D,'|',P,'BuildLoad P P <0C'

⍝ LLVMValueRef 	LLVMBuildStore (LLVMBuilderRef, LLVMValueRef Val, LLVMValueRef Ptr)
'BuildStore'⎕NA'P ',D,'|',P,'BuildStore P P P'

⍝ LLVMBasicBlockRef 	LLVMGetInsertBlock (LLVMBuilderRef Builder)
'GetInsertBlock'⎕NA'P ',D,'|',P,'GetInsertBlock P'

⍝ LLVMValueRef 	LLVMGetLastInstruction (LLVMBasicBlockRef BB)
'GetLastInstruction'⎕NA'P ',D,'|',P,'GetLastInstruction P'

⍝ LLVMBasicBlockRef 	LLVMGetPreviousBasicBlock (LLVMBasicBlockRef BB)
'GetPreviousBasicBlock'⎕NA'P ',D,'|',P,'GetPreviousBasicBlock P'

⍝ LLVMValueRef 	LLVMBuildStructGEP (LLVMBuilderRef B, LLVMValueRef Pointer, unsigned Idx, const char *Name)
'BuildStructGEP'⎕NA'P ',D,'|',P,'BuildStructGEP P P U <0C'

⍝ LLVMValueRef 	LLVMBuildGEP (LLVMBuilderRef B, LLVMValueRef Pointer, LLVMValueRef *Indices, unsigned NumIndices, const char *Name)
'BuildGEP'⎕NA'P ',D,'|',P,'BuildGEP P P <P[] U <0C'

⍝ LLVMValueRef 	LLVMBuildBitCast (LLVMBuilderRef, LLVMValueRef Val, LLVMTypeRef DestTy, const char *Name)
'BuildBitCast'⎕NA'P ',D,'|',P,'BuildBitCast P P P <0C'

⍝ LLVMValueRef 	LLVMBuildICmp (LLVMBuilderRef, LLVMIntPredicate Op, LLVMValueRef LHS, LLVMValueRef RHS, const char *Name)
'BuildICmp'⎕NA'P ',D,'|',P,'BuildICmp P U P P <0C'

⍝ LLVMBool
⍝ LLVMPrintModuleToFile (LLVMModuleRef M, const char *Filename, char **ErrorMessage)
'PrintModuleToFile'⎕NA'I4 ',D,'|',P,'PrintModuleToFile P <0C >P'

⍝ void LLVMDisposeMessage (char *Message)
'DisposeMessage'⎕NA'',D,'|',P,'DisposeMessage P'

⍝ LLVMModuleRef LLVMModuleCreateWithName (const char *ModuleID)
'ModuleCreateWithName'⎕NA'P ',D,'|',P,'ModuleCreateWithName <0C'

⍝ LLVMValueRef
⍝ LLVMAddAlias (LLVMModuleRef M, LLVMTypeRef Ty, LLVMValueRef Aliasee, const char *Name)
'AddAlias'⎕NA'P ',D,'|',P,'AddAlias P P P <0C'

⍝ LLVMBool
⍝ LLVMCreateJITCompilerForModule (LLVMExecutionEngineRef *OutJIT, 
⍝     LLVMModuleRef M, unsigned OptLevel, char **OutError)
'CreateJITCompilerForModule'⎕NA'I ',D,'|',P,'CreateJITCompilerForModule >P P U >P'

⍝ LLVMGenericValueRef
⍝ LLVMRunFunction (LLVMExecutionEngineRef EE, 
⍝     LLVMValueRef F, unsigned NumArgs, LLVMGenericValueRef *Args)
'RunFunction'⎕NA'P ',D,'|',P,'RunFunction P P U <P[]'

⍝ void * LLVMGenericValueToPointer (LLVMGenericValueRef GenVal)
'GenericValueToPointer'⎕NA'P ',D,'|',P,'GenericValueToPointer P'

⍝ void LLVMDisposeGenericValue (LLVMGenericValueRef GenVal)
'DisposeGenericValue'⎕NA D,'|',P,'DisposeGenericValue P'

⍝ LLVMBool
⍝ LLVMFindFunction (LLVMExecutionEngineRef EE, const char *Name, LLVMValueRef *OutFn)
'FindFunction'⎕NA'I ',D,'|',P,'FindFunction P <0C >P'

⍝ void 	LLVMSetTarget (LLVMModuleRef M, const char *Triple)
'SetTarget'⎕NA D,'|',P,'SetTarget P <0C'

⍝ #define 	LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##TargetInfo(void);
⍝ #define 	LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##Target(void);
⍝ #define 	LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##TargetMC(void);
('Initialize',Target,'TargetInfo')⎕NA D,'|',P,'Initialize',Target,'TargetInfo'
('Initialize',Target,'Target')⎕NA D,'|',P,'Initialize',Target,'Target'
('Initialize',Target,'TargetMC')⎕NA D,'|',P,'Initialize',Target,'TargetMC'

⍝ void 	LLVMDumpModule (LLVMModuleRef M)
'DumpModule'⎕NA D,'|',P,'DumpModule P'

⍝ void FFIGetDataInt (int64_t **res, struct codfns_array *)
'FFIGetDataInt'⎕NA R,'|FFIGetDataInt >I8[] P'

⍝ uint64_t FFIGetSize (struct codfns_array *)
'FFIGetSize'⎕NA 'U8 ',R,'|FFIGetSize P'

⍝ void *memcpy(void *dst, void *src, size_t size)
'cstring'⎕NA'libc.so.6|memcpy >C[] P P'

⍝ size_t strlen(char *str)
'strlen'⎕NA'P libc.so.6|strlen P'

∇

:EndNamespace

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

