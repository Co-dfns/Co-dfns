⍝ CoDfns Namespace: Increment 1

:Namespace CoDfns

⍝ Increment 1 Overview:
⍝
⍝ ∘ Support an empty namespace
⍝ ∘ Generate an empty LLVM Object to a file
⍝ ∘ Create passes Tokenize, GenLLVM, Parse
⍝ ∘ Add support for stimuli: Fix Break Eot Fnb Fne Fnf Lle Lls Nl Nse Nss

⍝ Handling of the Break Stimuli is automatic, and does not need to be handled 
⍝ explicitly

⍝ Fix
⍝
⍝ Top-level, primary input, corresponds to the Fix stimuli
⍝ State: Context ← Top ⋄ Fix ← No

Fix←{
  ⍝ State: Fix ← Yes
  
  _←FFI∆INIT
  
  ⍝ Input Validation, Signal DOMAIN ERROR if not valid
  ((,1)≡⍴⍵)∧(∧/1≥⊃∘⍴∘⍴¨⍵)∧(∧/⊃,/' '=∊¨⍵):⎕SIGNAL 11
  
  ⍝ Identify Obj property
  ⍝ This is based on the arity of the Fix call
  ⍺←⊢ ⋄ Obj←⍺⊣''
  
  ⍝ We must handle the other transitions: 
  ⍝   Fnb → DOMAIN ERROR    → (Fix ← No)
  ⍝   Fnf → FILE NAME ERROR → (Fix ← No)
  ⍝   Fne → null            → (Obj ← Yes)
  IsFnb Obj:⎕SIGNAL 11
  IsFnf Obj:⎕SIGNAL 22
  
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
IsFnf←{0}

⍝ Compile
⍝
⍝ Intended Function: Compile the given Fix input into an LLVM Module.
⍝ 
⍝ Input: Valid Fix right argument
⍝ Output: Semantically equivalent LLVM Module and a (name, type) mapping of top-level bindings
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No
⍝ Return State: Namespace ← CLOSED ⋄ Eot ← Yes
⍝ 
⍝ Each of the passes of the compiler returns us to the same starting state, 
⍝ conceptually, but refines the details over and over again, returning a 
⍝ slightly different namespace than the one before.

Compile←{
  tks←Tokenize ⍵
  ast names←Parse tks
  mod←GenLLVM ast
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

ErrorMessage←{
  len←strlen ⍵
  res←⊃cstring len ⍵ len
  _←DisposeMessage ⍵
  res
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
  ⍝ Potential Stimuli: Eot Nl Nse Nss
  ⍝ 
  ⍝ The only real job of this pass is to get to these stimuli, not do anything
  ⍝ more with them.

  ⍝ Strip leading and trailing whitespace from each line
  A←((⌽∘(∨\)∘⌽¨A)∧∨\¨A←' '≠⍵)/¨⍵
  
  ⍝ Divide into comment and code
  I←A⍳¨'⍝' ⋄ T←I↑¨A ⋄ C←I↓¨A
  
  ⍝ Split code on spaces
  T←(1,¨2≠/¨' '=T)⊂¨T
  
  ⍝ Wrap in Token containers
  ⍝ This works right now because we do not have any other elements to 
  ⍝ worry about besides tokens
  T←{1 4⍴2 'Token' '' (2 2⍴'class' 'delimiter' 'name' ⍵)}¨¨T
  
  ⍝ Wrap in Lines
  T←C {1 'Line' '' (1 2⍴'comment' ⍺)⍪⊃⍪/⍵}¨T
  
  ⍝ Create and return Tokens tree
  0 'Tokens' '' (0 2⍴'')⍪⊃⍪/T
}

⍝ Parse
⍝
⍝ Intended Function: Convert a Tokens AST to a Namespace AST that is structurally equivalent 
⍝ and that preserves comments and line counts.
⍝ 
⍝ Input: Tokens tree
⍝ Output: Namespace AST
⍝ State: Context ← Top ⋄ Fix ← Yes ⋄ Namespace ← NOTSEEN ⋄ Eot ← No

Parse←{
  ⍝ Potential Stimuli: Eot Nl Nse Nss
  ⍝
  ⍝ State Transitions:
  ⍝   Eot → SYNTAX ERROR → (Fix ← No)
  ⍝   Nl  → null         → ()
  ⍝   Nse → SYNTAX ERROR → (Fix ← No)
  ⍝   Nss → null         → (Namespace ← OPEN)

  ⍝ Stimuli: Eot
  ⍝ This corresponds to an empty namespace
  ⍝ This means that there are no tokens, which we can 
  ⍝ check easily
  0=+/⍵[;1]∊⊂'Token':⎕SIGNAL 2
  
  ⍝ Stimuli: Nl
  ⍝
  ⍝ Empty lines don't matter, and Nl has already been 
  ⍝ parsed for us by Tokenize, so there is no need to deal 
  ⍝ with this explicitly. We leave the empty or comment
  ⍝ only lines around for idempotency's sake
  
  ⍝ Stimuli: Nss and Nse
  ⍝
  ⍝ These are specifically allowed in only a few places, and this makes it easy. 
  ⍝ They may only appear at the beginning and end of a namespace document, 
  ⍝ and thus they should be the first and the last tokens that we see 
  ⍝ in the document. If they are not then we have a syntax error.
  
  NS←(⊃N),⊃⌽N←(¯1⌽T∊⊂'name')/T←,↑(⍵[;1]∊⊂'Token')/⍵[;3]
  ':Namespace' ':EndNamespace'≢NS:⎕SIGNAL 2
  
  ⍝ Remove Nss and Nse tokens
  ⍝ This corresponds to lifting the tokens to part of the structure
  ⍝ This changes the root from Tokens to Namespace
  
  NS←(~⍵[;1]∊⊂'Token')/[0]⍵
  0 'Namespace' '' (1 2⍴'name' '')⍪1↓NS
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
  
  ModuleCreateWithName Nam
}

⍝ Foreign Functions

∇{Z}←FFI∆INIT
Z←⍬

⍝ LLVMBool LLVMPrintModuleToFile (LLVMModuleRef M, const char *Filename, char **ErrorMessage)
'PrintModuleToFile'⎕NA'I4 CoDfns|PrintModuleToFile P <0C >P'

⍝ void LLVMDisposeMessage (char *Message)
'DisposeMessage'⎕NA'CoDfns|DisposeMessage P'

⍝ LLVMModuleRef LLVMModuleCreateWithName (const char *ModuleID)
'ModuleCreateWithName'⎕NA'P CoDfns|ModuleCreateWithName <0C'

⍝ void *memcpy(void *dst, void *src, size_t size)
'cstring'⎕NA'dyalog64|MEMCPY >C[] P P'

⍝ size_t strlen(char *str)
'strlen'⎕NA'P dyalog64|STRLEN P'

∇

:EndNamespace