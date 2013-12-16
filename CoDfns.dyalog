⍝ CoDfns Namespace: Increment 2

:Namespace CoDfns

  ⎕IO ⎕ML←0 1

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
⍝ ∘ JIT Namespace support
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
  ~((,1)≡⍴⍴⍵)∧(∧/1≥⊃∘⍴∘⍴¨⍵)∧(∧/⊃,/' '=⊃∘(0∘⍴)∘⊂¨⍵):⎕SIGNAL 11
  
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

⍝ Stubbed stimuli predicates for Fix

IsFnb←{0}

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
  ast names←Parse tks
  ast←KillLines   ast
  ast←DropUnmd    ast
  ast←LiftConsts  ast
  mod←GenLLVM     ast
  mod names
}

⍝ ModToNS
⍝ 
⍝ Intended Function: Create a Namespace that provides access to an LLVM Module
⍝
⍝ Left Argument: A (name, type) mapping of top-level bindings
⍝ Right Argument: A valid LLVM Module
⍝ State: Context ← Top ⋄ Namespace ← CLOSED ⋄ Eot ← Yes

ModToNS←{⎕FIX ':Namespace' ':EndNamespace'} ⍝ Stubbed until later

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
  res←⊃cstring len ⍵ len
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
    
    ⍝ Split on ← { } ⋄
    T←{⊃,/(⊂⍬),⍵}¨{(B∨2≠/1,B←⍵∊'←{}⋄')⊂⍵}¨¨T

    ⍝ At this point, all lines are split into tokens
    ⍝ Wrap each token in appropriate element:
    ⍝   Variables → Variable
    ⍝   Integer   → Number class ← 'int' 
    ⍝   ← ⋄       → Token class ← 'separator'
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
    ⍝   ← ⋄      → T∊'←⋄'
    ⍝   { }      → T∊'{}'
    ⍝
    ⍝ Create a selection vector for each type of token
    Sv Si Sa Sd←(⊃¨T)∘∊¨VC NC '←⋄' '{}'
    
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
ByElem←{(⍺[;1]∊⊂⍵)/[0]⍺}

⍝ AST ByDepth Depth: All nodes of a specific depth
⍝
⍝ ByDepth obtains a matrix of all the nodes of the AST (⍺) 
⍝ that have a given depth (⍵).
ByDepth←{(⍵=⍺[;0])/[0]⍺}

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

⍝ Parse
⍝
⍝ Intended Function: Convert a Tokens AST to a Namespace AST that is 
⍝ structurally equivalent and that preserves comments and line counts.
⍝ 
⍝ Input: Tokens tree
⍝ Output: Namespace AST, Top-level Names
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

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
  
  ⍝ State: Namespace ← OPEN ⋄ Eot ← No
  ⍝ Stimuli already handled by this point or that do not need handling: 
  ⍝   Eot Fix Fnb Fne Fnf Nl Nse Nss Break ⋄
  ⍝ Stimuli to consider: Vfo Vu N ← { } E Fe
  ⍝
  ⍝ At this point we have every other line representing some sort of 
  ⍝ expression or function. If we look at the set of states in the 
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
  
  ⍝ Our overal strategy here is to reduce over the lines from top to bottom, 
  ⍝ eventually resulting in our final namespace. Each call to ParseLine will 
  ⍝ return an extended namespace and a new environment containing the bindings 
  ⍝ that have been created so far. 
  ⍝
  ⍝ To begin with, we need to start with an empty environment and an empty 
  ⍝ AST. This is our Seed value.
  SD←(0 4⍴⍬)MtNTE
  
  ⍝ We partition the AST into the appropriate sub-trees, each of which should 
  ⍝ correspond to a single line. To do this, we note that all sub-trees of the 
  ⍝ the main Tokens AST at this point are lines, which are all at depth 1. 
  ⍝ We have no other node types with which to contend, which means that we can 
  ⍝ easily extract each of the sub-trees to work on.
  CN←(1=0⌷⍉S)⊂[0]S←(1≤0⌷⍉NS)⌿NS
  
  ⍝ Finally, we use ParseLine to reduce over the lines, extracting out the final 
  ⍝ namespace. At this point, the namespace will not have the appropriate head on 
  ⍝ it, which we stripped off above. We put this back on to form the final, 
  ⍝ correctly parsed AST. The AST is now a Namespace AST and each line has been 
  ⍝ converted into an apropriate node, or left alone if it is an empty line.
  NS←(1↑NS)⍪⊃A E←⊃ParseLine/⌽(⊂SD),CN
  
  ⍝ We return the final environment created by the ParseLine function and 
  ⍝ the final Namespace AST. 
  NS E
}

⍝ ParseLine
⍝
⍝ Intended Function: Given a Line sub-tree, parse it into one of
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

ParseLine←{C E←⍵
  ⍝ Possible stimuli: Vfo Vu N ← { } E Fe
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
  0=⊃ferr ast Ne←E ParseFuncExpr 1↓⍺:(C⍪ast Comment cmt)Ne
  
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
⍝ Right Argument: Matrix of Tokens
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
  (2 3 4∨.=Tp)∨(0=Tp)∧(SC=1):0,Vn Tp E ParseNamedBnd 2↓⍵
  
  ⍝ If we do not have a Vfo or Vu, then something is wrong and we should error out
  ¯1 MtAST E
}

⍝ ParseNamedUnB
⍝
⍝ Intended Function: Parse an assignment to an unbound variable.
⍝
⍝ Right Argument: Non-empty matrix of tokens
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
  0=⊃ferr ast Ne←E ParseFuncExpr ⍵:(Vn Bind ast)(Vn 2⍪Ne)
  
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
⍝ Right Argument: Non-empty matrix of tokens
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
  T←2 ⋄ ferr ast Ne←E ParseFuncExpr ⍵
  (0=ferr)∧Tp=T:(Vn Bind ast)(Vn Tp⍪Ne)
  Tp≠T:⎕SIGNAL 2
  
  ⍝ Stimuli: Vfo Vu ←
  ⍝
  ⍝ The handling of the Fe stimuli will have covered both the Fe states and 
  ⍝ the Vfo Nl state, as in the Value ← EMPTY ⋄ Named ← EMPTY case handled in 
  ⍝ ParseLine. We must handle the Vu Nl state explicitly here, and then we are 
  ⍝ left only with the states handled by ParseLineVar, except that we need to call 
  ⍝ it with a state class of 1 instead of 0.
  (1=⊃⍴⍵)∧('Variable'≡0 1⊃⍵)∧(0=E VarType⊃'name'Prop 1↑⍵):⎕SIGNAL 6
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
⍝ Right Argument: Matrix of token nodes
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
  ⍝ For Increment 2 we are handling only arrays of integers, which might 
  ⍝ possibly have a name. Thus, we can handle all of our cases by only 
  ⍝ checking for a name first, and then handling the integers separately.
  
  ⍝ Check for a name, and parse as appropriate if we have a name
  'Variable'≡⊃0 1⌷⍵:⍺ {
    ⍝ Verify that we have an assignment
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
  
  ⍝ The depth of the expression is one less than the depth of all the tokens
  ⍝ that we assume to all be of the same depth.
  D←¯1+⊃⍵
  
  ⍝ As long as we have all number tokens, we can easily construct the 
  ⍝ appropriate expression node on top of it.
  X←D 'Expression' '' (1 2⍴'class' 'atomic')⍪⍵

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
⍝ Right Argument: Matrix of token nodes
⍝ Left Argument: [Name,Type] Environment
⍝ Output: (0 or Exception #)(FuncExpr AST)(New [Name,Type] Environment)
⍝ Invariant: Depth of the output should be the same as the input
⍝ State: Context ← Fnex ⋄ Opnd ← NONE ⋄ Oper ← NONE ⋄ Axis ← NO ⋄ Nest ← NONE ⋄ Tgt ← No

ParseFuncExpr←{
  ⍝ Possible Stimuli: Fn
  ⍝ Indirectly processed Stimuli: N { }
  ⍝
  ⍝ The only possibility that we have right now is that of an user defined constant 
  ⍝ function, so we will just call that right here.
  0≠⊃err ast←⍺ ParseFunc ⍵:err ast ⍺
  
  ⍝ We need to push the depth of the received AST down by one to prepare for the
  ⍝ next
  ast[;0]+←1
  
  ⍝ The only thing we can have at this point is a function, so we just handle that 
  ⍝ here directly.
  Fn←(¯1+⊃⍵) 'FuncExpr' '' (2 2⍴'class' 'ambivalent' 'equiv' 'ambivalent')
  
  0 (Fn⍪ast) ⍺
}

⍝ ParseFunc
⍝
⍝ Intended Function: Take a set of tokens and parse them as an user-defined 
⍝ ambivalent function, monadic or dyadic operator.
⍝
⍝ Right Argument: Non-empty matrix of Token nodes
⍝ Left Argument: [Name,Type] Environment
⍝ Output: (0 or Exception #)(Function AST)
⍝ Invariant: Depth of the output should be the same as the input
⍝ Invariant: Right argument must have at least one row
⍝ State: Context ← Func ⋄ Bracket ← No ⋄ Cond ← No ⋄ Bind ← NO ⋄ Value ← EMPTY

ParseFunc←{
  ⍝ Possible Stimuli: { } E
  ⍝ Indirectly processed stimuli: N
  ⍝
  ⍝ Trace: Tables 23, 24, and 25 of Function Specification
  ⍝
  ⍝ This is a stubbed function for parsing functions, which handles only 
  ⍝ two sequences: { } and { E }.
  
  ⍝ Stimuli: { }
  ⍝
  ⍝ All functions must be surrounded by { and }. Since we do not have any 
  ⍝ nested functions right now, we can just check to make sure that the first 
  ⍝ and the last tokens here are { and }, respectively.
  FL←(1↑⍵)⍪(1↑⊖⍵)
  ~(FL[;1]∧.≡⊂'Token')∧((,¨'{' '}')∧.≡'name'Prop FL):2 MtAST
  
  ⍝ If we have only two tokens, then we have an empty function
  2=⊃⍴⍵:0 ((¯1+⊃⍵)'Function' '' (1 2⍴'class' 'ambivalent'))
  
  ⍝ Otherwise, we will have only a single expression which we should 
  ⍝ parse
  0≠⊃err ast Ne←⍺ ParseExpr ¯1↓1↓⍵:err MtAST
  ast[;0]+←1
  0((¯1+⊃⍵)'Function' ''(1 2⍴'class' 'ambivalent')⍪ast)
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
  (~⍵[;1]∊⊂'Line')/[0]⍵
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
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

DropUnmd←{
  
}

⍝ LiftConsts
⍝
⍝ Intended Function: Remove all constants from all depths to ensure that 
⍝ there exist constant values only at the top level. 
⍝
⍝ Right argument: Namespace AST
⍝ Output: Namespace AST
⍝ Invariant: Result contains only globals at top-level
⍝ Invariant: Function bodies either empty or single variable expression
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

LiftConsts←{
  ⍝ The following is equivalent to the Intended function assuming that 
  ⍝ we have the Increment 2 restrictions in place, namely, that functions 
  ⍝ have only a single literal expression in their bodies if they have one 
  ⍝ at all:
  ⍝ For each expression appearing in a function
  ⍝   Put the expression before the function that encloses it
  ⍝   Raise the expression depth
  ⍝   Give the expression a name
  ⍝   Add a variable of the name of the expression to the function body
  
  ⍝ We first partition the tree into depth 1 sub-trees (which corresponded to 
  ⍝ the individual global nodes in the tree) which allows us to work on each 
  ⍝ individually
  ST←(1=⍵[;0])⊂[0]⍵
  
  ⍝ Quit if there is nothing to do
  0=⍴ST:⍵
  
  ⍝ It is helpful to know which nodes are function expressions and which are 
  ⍝ not
  FeBV←'FuncExpr'∘≡∘⊃¨0 1∘⌷¨ST
  
  ⍝ For every function that we have, if we have just the function sub-tree, 
  ⍝ then we will note that a rotation of the matrix will result in the 
  ⍝ expression being above the function. In the case of a Function Expression, 
  ⍝ we will have a depth 1 FuncExpr node, a depth 2 Function node, and then 
  ⍝ a depth 3 Expression node if any at all. In this case, a 2 rotation along the 
  ⍝ first axis will result in the first two elements going to the bottom, which 
  ⍝ is the same as putting the expression "above" the Function, provided that we 
  ⍝ adjust the depths.
  ST←(2×FeBV)⊖¨ST
  
  ⍝ To adjust the depths, note that for a FuncExpr the depth of the Expression 
  ⍝ will be 3, so we can subtract 2 from the depth of the Expression to lift 
  ⍝ the expression out to the top level. We must remember not to shift the 
  ⍝ FuncExpr or Function nodes.
  ST←FeBV {⍺:A⊣A[;0]+←0 0,⍨¯2⍴⍨¯2+⊃⍴⍵⊣A←⍵ ⋄ ⍵}¨ST
  
  ⍝ We can general names for each of the functions. 
  ⍝ The Vars variable is actually a set of names in a format 
  ⍝ suitable for appending onto an existing tree. The first element of this 
  ⍝ is an empty array for when we don't want to append anything at all.
  ⍝ The Exps variable is similiar but is designed to be prepended to the tree.
  Vns←'LC'∘,∘⍕¨⍳+/FeBV
  Vars←(⊂0 4⍴⍬),{1 4⍴3 'Variable' '' (2 2⍴'name' ⍵ 'class' 'array')}¨Vns
  Exps←(⊂0 4⍴⍬),{1 4⍴1 'Expression' '' (2 2⍴'name' ⍵ 'class' 'atomic')}¨Vns
  
  ⍝ We can now add this name to each expression both in the assignment of the 
  ⍝ expression and also as the variable reference in the body of the function.
  I←FeBV\1+⍳+/FeBV
  ST←Exps[I]⍪¨FeBV↓¨ST⍪¨Vars[I]
  
  ⍝ Finally, we recombine the data into the appropriate result format
  (1↑⍵)⍪⊃⍪/ST
}

⍝ GenLLVM
⍝
⍝ Intended Function: Take a namespace and convert it to an LLVM Module that is 
⍝ semantically equivalent.
⍝ 
⍝ Input: Namespace AST
⍝ Output: Semantically equivalent LLVM Module
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
  
  ⍝ All depth-1 subtrees
  G←(1=⍵[;0])⊂[0]⍵
  
  ⍝ Quit if nothing to do
  0=⍴G:Mod
  
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
  
  ⍝ Generate LLVM Integers for each of these 
  ⍝ The shape of D should be a vector, since this 
  ⍝ will be passed directly to certain foreign functions.
  D←{ConstIntOfString (Int64Type) ⍵ 10}¨,V
  
  ⍝ Build an LLVM Constant array from these values
  Da←ConstArray (Int64Type) D (⊃⍴D)
  
  ⍝ Shape of the array is a single element vector 
  ⍝ Make sure that the shape of the array is based off 
  ⍝ of V and not off of D.
  S←{ConstInt (Int32Type) ⍵ 0}¨⍴V
  Sa←ConstArray (Int64Type) S (⊃⍴S)
  
  ⍝ Rank is constant
  ⍝ Rank must also come from V and not D
  R←ConstInt (Int16Type) (⊃⍴⍴V) 0
  
  ⍝ Size is a function of the number of elements in V
  ⍝ which is really the size of D
  Sz←ConstInt (Int64Type) (⊃⍴D) 0
  
  ⍝ For now we have a constant type
  T←ConstInt (Int4Type) 2 0
  
  ⍝ We can put this all together now and insert it into the 
  ⍝ Module
  A←ConstStruct (R Sz T Sa Da) 5 0
  G←AddGlobal ⍺ (GenArrayType ⍬)(⊃'name'Prop 1↑⍵)
  0 0⍴SetInitializer G A
}

⍝ GenFunc
⍝
⍝ Intended Function: Given a FuncExpr node, build an appropriate 
⍝ Function in the LLVM Module given.
⍝
⍝ Left Argument: LLVM Module
⍝ Right Argument: FuncExpr Node
⍝
⍝ For now this is just a stub assuming that we have a function that 
⍝ has only a single variable reference in it.
GenFunc←{
  ⍝ We assume that this is a function with a single variable 
  ⍝ reference in it at the moment. The only other thing we care about 
  ⍝ is the set of names that are associated with the function. 
  ⍝ Thus, we need both the names of the function and the variable 
  ⍝ reference inside of it.
  fn vn←'name'Prop ⍵[0 2;]

  ⍝ A given function expression can have more than one name associated 
  ⍝ with it. The first name in the list will be the canonical one, 
  ⍝ and we will alias the rest of them to the first name after we have 
  ⍝ created the function. The fn variable is actually a string of 
  ⍝ space delimited names, so we split this up and take the first as 
  ⍝ the canonical. It is safe to do this because we have the invariant 
  ⍝ established in previous passes that we always have at least one 
  ⍝ name.
  fnf fnr←(⊃fn),1↓fn←(nsp/2≠/' '=' ',fn)⊂(nsp←' '≠fn)/fn

  ⍝ With the names taken care of, we can add the function under the 
  ⍝ first name.
  fr←AddFunction ⍺ fnf (ft←GenFuncType ⍬)

  ⍝ The following is a stub for handling the body of the function, 
  ⍝ which we assume right now to be a single variable reference.
  vr←GetNamedGlobal ⍺ vn
  bb←AppendBasicBlock fr ''
  bldr←CreateBuilder
  _←PositionBuilderAtEnd bldr bb
  _←BuildRet bldr vr
  _←DisposeBuilder bldr

  ⍝ We can now add additional aliases or simply return if there 
  ⍝ are none to work with.
  0=⍴fnr:0 0⍴fr
  0 0⍴fr⊣{AddAlias ⍺ ft fr ⍵}¨fnr
}

⍝ GenArrayType
⍝
⍝ Intended Function: Constant function returning the type of an 
⍝ array.
⍝ 
⍝ See the Software Architecture for details on the Array Structure.
GenArrayType←{
  p←PointerType (Int64Type) 0
  lt←(Int16Type)(Int64Type)(Int4Type) p p
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
  FunctionType (GenArrayType ⍬) ⍬ 0 0
}

⍝ Foreign Functions

∇{Z}←FFI∆INIT;P;D
Z←⍬
D←'libLLVM-3.3.so'
P←'LLVM'

⍝ LLVMTypeRef  LLVMInt4Type (void) 
'IntType'⎕NA 'P ',D,'|',P,'IntType U'

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

⍝ LLVMValueRef  LLVMConstInt (LLVMTypeRef IntTy, unsigned long long N, LLVMBool SignExtend) 
'ConstInt'⎕NA 'P ',D,'|',P,'ConstInt P U8 I'

⍝ LLVMValueRef  LLVMConstIntOfString (LLVMTypeRef IntTy, const char *Text, uint8_t Radix) 
'ConstIntOfString'⎕NA 'P ',D,'|',P,'ConstIntOfString P <0C[] U8'

⍝ LLVMValueRef
⍝ LLVMConstArray (LLVMTypeRef ElementTy, LLVMValueRef *ConstantVals, unsigned Length) 
'ConstArray'⎕NA 'P ',D,'|',P,'ConstArray P <P[] U'

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
'BuildRet'⎕NA 'P ',D,'|',P,'BuildRet P P'

⍝ void  LLVMDisposeBuilder (LLVMBuilderRef Builder) 
'DisposeBuilder'⎕NA 'P ',D,'|',P,'DisposeBuilder P'

⍝ LLVMValueRef
⍝ LLVMConstStruct (LLVMValueRef *ConstantVals, unsigned Count, LLVMBool Packed) 
'ConstStruct'⎕NA'P ',D,'|',P,'ConstStruct <P[] U I'

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

⍝ void *memcpy(void *dst, void *src, size_t size)
'cstring'⎕NA'libc.so.6|memcpy >C[] P P'

⍝ size_t strlen(char *str)
'strlen'⎕NA'P libc.so.6|strlen P'

∇

∇Z←Int4Type
 Z←IntType 4
∇

:EndNamespace
