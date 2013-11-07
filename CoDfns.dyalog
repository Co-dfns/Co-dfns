⍝ CoDfns Namespace: Increment 2

:Namespace CoDfns

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
⍝ ∘ Generate single basic block, one-statement function bodies that reference a single global variable
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
  ~((,1)≡⍴⍴⍵)∧(∧/1≥⊃∘⍴∘⍴¨⍵)∧(∧/⊃,/' '=∊¨⍵):⎕SIGNAL 11
  
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
  ast←KillLines ast
  ast←LiftConsts ast
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
  ⍝ Potential Stimuli: Eot Nl Nse Nss V N ← { }
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
  
  ⍝ Additional Characters in domain: ←{}
  ⍝ In general, the : character should be handled as well, 
  ⍝ but for now this assumes that we only have to deal with 
  ⍝ the Nse and Nss tokens. Thus, we do not have to deal with 
  ⍝ : generally.
  ⍝ 
  ⍝ The NC variable contains the decimal digits, used in both 
  ⍝ the N and V tokens. The Nl token is already parsed, so we 
  ⍝ do not do anything with that, and the Eot token is implicit 
  ⍝ as well.
  
  ⍝ Verify that we have only valid characters in use
  AC←VCN,'←{}: ⍝'
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
  
  ⍝ Split on and remove spaces
  T←{((⍴X)⍴1 0)/X←(2≠/' '=' ',⍵)⊂⍵}¨T
  
  ⍝ Split on ← { }
  T←⊃∘(,/)¨{(B∨2≠/1,B←⍵∊'←{}')⊂⍵}¨¨T

  ⍝ At this point, all lines are split into tokens
  ⍝ Wrap each token in appropriate element:
  ⍝   Variables → Variable
  ⍝   Integer   → Number class ← 'int' 
  ⍝   ←         → Token class ← 'separator'
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
  ⍝   ←        → T∊'←'
  ⍝   { }      → T∊'{}'
  ⍝
  ⍝ Create a selection vector for each type of token
  Sv Si Sa Sd←(⊃¨T)∘∊¨VC NC '←' '{}'
  
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
  T←(T,(+/0=L)↑⊂⍬)[⍋((0≠L)/⍳⍴L),(0=L)/⍳⍴L]
  
  ⍝ Add the Namespace lines back
  T←(NSL,T)[⍋NSI,TI]
   
  ⍝ Wrap in Lines
  T←C {H←1 4⍴1 'Line' '' (1 2⍴'comment' ⍺) ⋄ 0=⊃⍴⍵:H ⋄ H⍪⊃⍪/⍵}¨T
  
  ⍝ Create and return Tokens tree
  0 'Tokens' '' EmptyAttr⍪⊃⍪/T
}

⍝ Parse
⍝
⍝ Intended Function: Convert a Tokens AST to a Namespace AST that is structurally 
⍝ equivalent and that preserves comments and line counts.
⍝ 
⍝ Input: Tokens AST
⍝ Output: Namespace AST, Top-level Names

Parse←{
  ⍝ We define Parsing as the Fixpoint of a specific, terminating, single 
  ⍝ step transition function which processes a single token at a time.
  ⍝ It operates over a few elements. The two which we need to care about 
  ⍝ returning are the AST and the Environment.
  ⍝
  ⍝ The transition function is a direct translation of the State Box definitions, 
  ⍝ which are included here directly inline to show the correspondence between 
  ⍝ them and the code. The State-box structures come directly from the 
  ⍝ Function Specification Black-box definitions. The state-box definition is 
  ⍝ the function specification behavior encoded as a mapping of incoming state
  ⍝ to a response and new state.
  ⍝
  ⍝ There is a hierarchy of states based on the current Context:
  ⍝
  ⍝   Ctx ∊ Top
  ⍝     Fix ← Yes No
  ⍝     Obj ← Yes No
  ⍝     Nms ← NOTSEEN OPEN CLOSED
  ⍝     Eot ← Yes No
  ⍝     Val ← UNBOUND EXPR FUNC EMPTY
  ⍝     Nam ← MAYBE BOUND UNBOUND NO
  ⍝   Ctx ∊ Func
  ⍝     Brk ← Yes No
  ⍝     Cnd ← Yes No
  ⍝     Bnd ← NO BOUND UNBOUND
  ⍝     Val ← EMPTY EXPR FUNC FVAR UNBOUND
  ⍝   Ctx ∊ Expr
  ⍝     Nst ← NONE PAREN BRACKET EBRACK RBRACK
  ⍝     Cls ← ATOM FUNC SELECT
  ⍝     LSn ← EMPTY LIT VAR NVAR UVAR MIXED EXPR SELEX
  ⍝   Ctx ∊ Fnex
  ⍝     Opn ← ATOM AMB NONE JOT MON DYA
  ⍝     Opr ← NONE DOT COMP POW ANY EACH MON DYA RED FUNC COMM SCN
  ⍝     Axs ← NO YES SEEN FILD
  ⍝     Nst ← NONE EMPTY A AA M MA D DA O OM OD COMM COMP EACH POW DOT RED SCN
  ⍝     Tgt ← Yes No
  ⍝
  ⍝ It would normally suffice to simply map the state changes given 
  ⍝ in the properties at this point. Unfortunately, we have to describe 
  ⍝ a recursive process, which is the reason for the context. Whenver we 
  ⍝ may need to deal with a recursive stimuli, we are establishing an 
  ⍝ explicit continuation where we may need to backtrack. We can process 
  ⍝ each recursive stimuli in turn, but we need to make sure that we know 
  ⍝ where to backtrack to, which requires us to carefully consider our
  ⍝ enumeration while we work to identify when we may need to switch context. 
  ⍝
  ⍝ Shifts in the Context value occur whenever we may have a recursive stimuli 
  ⍝ that we need to process, or when we have reached an error response. If we 
  ⍝ fail to parse a recursive stimuli, then we need to backtrack to the next 
  ⍝ potential situation, which amounts to a context switch. 
  ⍝ 
  ⍝ This context switching amounts to building up a stack of "recursive" calls 
  ⍝ through the machine, which necessitates Context being a stack of values. The 
  ⍝ sub-states do not need only be a single element from the sets above since 
  ⍝ they only matter within a recursion, and not between them. We need to keep 
  ⍝ track of the stack of states, however, so our total state amounts to a stack 
  ⍝ of states, with the top of the stack being the nearest state that we are 
  ⍝ currently using.
  ⍝
  ⍝ Some more consideration needs to be made with regards to error reporting, 
  ⍝ but we will handle that later. 
  
  ⍝ Defining State
  ⍝ There is a question as to the easiest way of representing state.
  ⍝ Because we have a hierarchy, it can be incovenient if we do not have a 
  ⍝ statically sized vector containing the states. 
  ⍝ Since we mostly care above the contents of specific states, and can 
  ⍝ safely ignore the states that are not part of a given hierarchy, it is 
  ⍝ okay for us to encode all states as a single vector. 
  ⍝ Since we represent the state of the system as a stack of the above 
  ⍝ properties, we want to be able to easily access the current state and 
  ⍝ change the value of the current state if we so choose. To do this we 
  ⍝ define a set of accessor variables that will allow us to access the current 
  ⍝ state from a state stack and to change that value if we so choose.
  ⍝
  ⍝ There are a total of 18 different states.
  Ctx Fix Obj Nms Eot Val Nam Brk Cnd Bnd Nst Cls LSn Opn Opr Axs Nst Tgt←0,¨⍳18
  
  ⍝ Transition Function: Next
  ⍝
  ⍝ Right Argument: Index, AST, Env, State, Response Code
  ⍝ Left Argument: Token vector
  ⍝
  ⍝ The state is a stack of states, each of which corresponds to a specific 
  ⍝ set of states as found in the Function Specification Black Box Definition.
  ⍝ The Index is a stack of indexes into the Token vector, which correspond 
  ⍝ to the indexes where each state is currently processing.
  ⍝
  ⍝ The Response Code is either a Negative value whose magnitude is an appropriate
  ⍝ Error response, or a positive integer representing one of the other responses:
  ⍝
  ⍝   0 null
  ⍝   1 wait
  ⍝   2 okay
  Next←{Ast Env Ids Sts Cod←⍵ ⋄ Idx←⊃Ids
    Tag←{⊃0 1⌷⍵} ⋄ Name←{⊃'name'Prop ⍵} ⋄ Value←{⊃'value'Prop ⍵}
    
    ⍝ Possible Stimuli: Eot Nl Nse Nss Vf Va Vu N ← { }

    ⍝ Token: Eot
    ⍝ 
    ⍝ The Eot Token is an implicit token indicated by exceeding the index of 
    ⍝ the token vector.
    ⍝
    ⍝ State-box Definition:
    ⍝   (Context ∊ Func Expr Fnex)                      → SYNTAX ERROR → ()
    ⍝   (Context ∊ Top ⋄ Namespace ∊ CLOSED ⋄ Eot ∊ No) → null         → ()
    ⍝   (Context ∊ Top ⋄ ~Namespace ∊ CLOSED)           → SYNTAX ERROR → ()
    ⍝   (Context ∊ Top ⋄ ~Eot ∊ No)                     → SYNTAX ERROR → ()
    ⍝
    ⍝ We have altered the null response of this definition to not alter the Eot state.
    ⍝ This is because we are only doing the parsing here, and not the rest of the system.
    ⍝ The Eot token signals the end of the Parsing and the start of the rest of the 
    ⍝ compiler passes, so we need to handle that separately. So, we just return the same 
    ⍝ thing that we received in, which should signal the end of the whole parser.
    ⍝
    ⍝ Furthermore, if we consider, it is impossible for us to have a reasonable parsing if we 
    ⍝ are in any of the Func, Expr, or Fnex states when we encounter an Eot. All valid parsings 
    ⍝ would have terminated these contexts when encountering a Nl token before reaching an Eot.
    ⍝ This means that we must have a syntax error, and can work accordingly. This allows us to 
    ⍝ merge all of the SYNTAX ERROR situations into one and do an immediate error report.
    Idx≥⊃⍴⍺:{
      Test←(⊂Ctx⊃⍵)∊'Func' 'Expr' 'Fnex'
      Test∨←('Top'≡Ctx⊃⍵)∧('CLOSED'≡Nms⊃⍵)⍲(0≡Eot⊃⍵)
      Test:'SYNTAX ERROR: Unexpected end of input'⎕SIGNAL 2
      ('Top'≡Ctx⊃⍵)∧('CLOSED'≡Nms⊃⍵)∧(0≡Eot⊃⍵):Ast Env Ids Sts Cod
      'UNEXPECTED STATE'⎕SIGNAL 99
    }Sts
    
    ⍝ It is now safe to extract out the token value, since we have tested for Eot
    Tok←⊃Idx⌷⍺
    
    ⍝ Token: Nss
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Func Expr Fnex)             → SYNTAX ERROR → ()
    ⍝   (Context ∊ Top ⋄ ~Namespace ∊ NOTSEEN) → SYNTAX ERROR → ()
    ⍝   (Context ∊ Top ⋄ Namespace ∊ NOTSEEN)  → null         → (Index +← 1 ⋄ Namespace ← OPEN)
    ⍝
    ⍝ Encountering an Nss token anywhere but where expected is grounds for immediate 
    ⍝ error reporting. This is because nothing happens until we see a Namespace token, 
    ⍝ and we never even enter into any of the other contexts by then. We also never expect to 
    ⍝ see another Namespace token within any context after the first.
    ('Token'≡Tag Tok)∧(':Namespace'≡Name Tok):{
      Test←(⊂Ctx⊃⍵)∊'Func' 'Expr' 'Fnex'
      Test∨←('Top'≡Ctx⊃⍵)∧('NOTSEEN'≢Nms⊃⍵)
      Test:'SYNTAX ERROR: Unexpected :Namespace encountered'⎕SIGNAL 2
      Nids←Ids ⋄ (⊃Nids)+←1 ⋄ Nsts←⍵ ⋄ (Nms⊃Nsts)←'OPEN'
      ('Top'≡Ctx⊃⍵)∧('NOTSEEN'≡Nms⊃⍵):Ast Env Nids Nsts Cod
      'UNEXPECTED STATE'⎕SIGNAL 99
    }Sts
    
    ⍝ Token: Nse
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Func Expr Fnex)                              → SYNTAX ERROR → ()
    ⍝   (Context ∊ Top ⋄ Namespace ∊ NOTSEEN CLOSED)            → SYNTAX ERROR → ()
    ⍝   (Context ∊ Top ⋄ Value ∊ EXPR FUNC)                     → null         → (Ast ← Namespace ⋄ Index +← 1 ⋄ Namespace ← CLOSED ⋄ Value ← EMPTY ⋄ Named ← NO)
    ⍝   (Context ∊ Top ⋄ Value ∊ EMPTY ⋄ Named ∊ NO)            → null         → (Ast ← Namespace ⋄ Index +← 1 ⋄ Namespace ← CLOSED)
    ⍝   (Context ∊ Top ⋄ Value ∊ UNBOUND)                       → VALUE ERROR  → ()
    ⍝   (Context ∊ Top ⋄ Value ∊ EMPTY ⋄ Named ∊ BOUND UNBOUND) → SYNTAX ERROR → ()
    ⍝
    ⍝ It is impossible to encounter an Nse token in a Func, Expr, or Fnex context 
    ⍝ unless something has gone horribly wrong. This is because an Nse token 
    ⍝ always implies two Nl tokens surrounding it. Since it always appears on a 
    ⍝ line by itself, then it will always be proceeded by an Nl token from the 
    ⍝ previous line, if any, and this Nl will terminate any of the recursive contexts
    ⍝ in any case that we have a good situation. It *will* terminate any Expr or 
    ⍝ Fnex context, but it is possible to encounter an Nse token in a Func 
    ⍝ Context if we have not seen the ending } token, which is grounds for immediate 
    ⍝ errors. Thus, it is safe to immediately error immediately in all of our 
    ⍝ SYNTAX ERROR cases. 
    ('Token'≡Tag Tok)∧(':EndNamespace'≡Name Tok):{
      Test←(⊂Ctx⊃⍵)∊'Func' 'Expr' 'Fnex'
      Test∨←('Top'≡Ctx⊃⍵)∧('NOTSEEN' 'CLOSED'∊⍨⊂Nms⊃⍵)
      Test∨←('Top'≡Ctx⊃⍵)∧('EMPTY'≡Val⊃⍵)∧('BOUND' 'UNBOUND'∊⍨⊂Nam⊃⍵)
      Test:'SYNTAX ERROR: unexpected :EndNamespace encountered'⎕SIGNAL 2
      ('Top'≡Ctx⊃⍵)∧('UNBOUND'≡Val⊃⍵):⎕SIGNAL 6
      
      Nids←Ids ⋄ (⊃Ids)+←1 ⋄ Nsts←⍵
      (Nms⊃Nsts)←'CLOSED' ⋄ (Val⊃Nsts)←'EMPTY' ⋄ (Nam⊃Nsts)←'NO'

      ⍝ There is some number of expressions or other nodes on the 
      ⍝ Ast stack and these need to be put together into a Namespace.
      Nmh←1 4⍴0 'Namespace' '' (0 2⍴⍬)
      Nast←,⊂Nmh⍪Kids⊣(0⌷⍉Kids)+←1⊣Kids←{0=⊃⍴⍵:0 4⍴⍬ ⋄ ⊃⍪/⌽⍵}Ast      
      
      Test←('Top'≡Ctx⊃⍵)∧('EMPTY'≡Val⊃⍵)∧('NO'≡Nam⊃⍵)
      Test∨←('Top'≡Ctx⊃⍵)∧('EXPR' 'FUNC'∊⍨⊂Val⊃⍵)
      Test:Nast Env Nids Nsts Cod

      'UNEXPECTED STATE'⎕SIGNAL 99
    }Sts
    
    ⍝ Token: Nl
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Expr Fnex)                                       → SYNTAX ERROR → (Finish Expr/Fnex)
    ⍝   (Context ∊ Top ⋄ Value ∊ EXPR FUNC)                         → null         → (Index +← 1 ⋄ Value ← EMPTY ⋄ Named ← NO)
    ⍝   (Context ∊ Top ⋄ Value ∊ EMPTY ⋄ Named ∊ NO)                → null         → (Index +← 1)
    ⍝   (Context ∊ Top ⋄ Value ∊ EMPTY ⋄ Named ∊ BOUND UNBOUND)     → SYNTAX ERROR → ()
    ⍝   (Context ∊ Top Func ⋄ Value ∊ UNBOUND)                      → VALUE ERROR  → ()
    ⍝   (Context ∊ Func ⋄ Value ∊ EXPR)                             → wait         → (Index +← 1 ⋄ Cond ← No ⋄ Bind ← NO ⋄ Value ← EMPTY)
    ⍝   (Context ∊ Func ⋄ Value ∊ EMPTY ⋄ Bind ∊ NO)                → wait         → (Index +← 1)
    ⍝   (Context ∊ Func ⋄ Value ∊ FUNC FVAR ⋄ Bind ∊ BOUND UNBOUND) → wait         → (Index +← 1 ⋄ Cond ← No ⋄ Bind ← NO ⋄ Value ← EMPTY)
    ⍝   (Context ∊ Func ⋄ Value ∊ FVAR ⋄ Bind ∊ NO)                 → SYNTAX ERROR → (Finish Func)
    ⍝   (context ∊ Func ⋄ Value ∊ EMPTY ⋄ Bind ∊ BOUND UNBOUND)     → SYNTAX ERROR → (Finish Func)
    
    ⍝ Token: N
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Top Func Fnex)                                                → SYNTAX ERROR →
    ⍝   (Context ∊ Expr ⋄ Nest ∊ NONE ⋄ Class ∊ ATOM ⋄ Last Seen ∊ LIT VAR NVAR) → atomic       →
    ⍝   (Context ∊ Expr ⋄ Nest ∊ NONE ⋄ Class ∊ SELECT FUNC)                     → okay         →
    ⍝   (Context ∊ Expr ⋄ Nest ∊ NONE ⋄ Last Seen ∊ UVAR MIXED)                  → VALUE ERROR  → 
    ⍝   (Context ∊ Expr ⋄ Nest ∊ RBRACK)                                         → okay         → 
    
    ⍝ Token: ←
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Top ⋄ Named ∊ MAYBE)                                   → null         →
    ⍝   (Context ∊ Top ⋄ Named ∊ BOUND ⋄ Value ∊ UNBOUND)                 → null         →
    ⍝   (Context ∊ Top ⋄ Named ∊ BOUND ⋄ ~Value ∊ UNBOUND)                → SYNTAX ERROR →
    ⍝   (Context ∊ Top ⋄ ~Named ∊ BOUND MAYBE)                            → SYNTAX ERROR →
    ⍝   (Context ∊ Func ⋄ Value ∊ UNBOUND FVAR)                           → wait         →
    ⍝   (Context ∊ Func ⋄ ~Value ∊ UNBOUND FVAR)                          → SYNTAX ERROR →
    ⍝   (Context ∊ Expr ⋄ Last Seen ∊ VAR NVAR UVAR ⋄ Nest ∊ NONE RBRACK) → wait         →
    ⍝   (Context ∊ Expr ⋄ ~Last Seen ∊ VAR NVAR UVAR)                     → SYNTAX ERROR →
    ⍝   (Context ∊ Fnex ⋄ Tgt ∊ Yes)                                      → wait         →
    ⍝   (Context ∊ Fnex ⋄ Tgt ∊ No)                                       → SYNTAX ERROR →
    
    ⍝ Token: Vf
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Expr)                                                               → SYNTAX ERROR →
    ⍝   (Context ∊ Top ⋄ Namespace ∊ NOTSEEN CLOSED)                                   → SYNTAX ERROR →
    ⍝   (Context ∊ Top ⋄ Value ∊ EMPTY)                                                → null         →
    ⍝   (Context ∊ Func ⋄ Bracket ∊ No)                                                → SYNTAX ERROR →
    ⍝   (Context ∊ Func ⋄ Value ∊ EMPTY ⋄ Cond ∊ No)                                   → wait         →
    ⍝   (Context ∊ Fnex ⋄ Opnd ∊ NONE AMB ⋄ Oper ∊ NONE DYA COMP ⋄ Nest ∊ NONE)        → ambivalent   →
    ⍝   (Context ∊ Fnex ⋄ Opnd ∊ ATOM AMB JOT DYA MON ⋄ Oper ∊ NONE MON ⋄ Nest ∊ NONE) → SYNTAX ERROR →
    ⍝   (Context ∊ Fnex ⋄ Nest ∊ EMPTY)                                                → wait         →
    ⍝   (Context ∊ Fnex ⋄ Opnd ∊ ATOM MON ⋄ Oper ∊ COMP ⋄ Nest ∊ NONE)                 → monadic      →
    ⍝   (Context ∊ Fnex ⋄ Opnd ∊ DYA ⋄ Oper ∊ COMP POW ⋄ Nest ∊ NONE)                  → dyadic       →
    ⍝   (Context ∊ Fnex ⋄ Oper ∊ DOT ⋄ Nest ∊ NONE)                                    → dyadic       → 
    
    ⍝ Token: Vu
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Expr)                             → SYNTAX ERROR →
    ⍝   (Context ∊ Top ⋄ Namespace ∊ NOTSEEN CLOSED) → SYNTAX ERROR →
    ⍝   (Context ∊ Top ⋄ Value ∊ EMPTY)              → null         →
    ⍝   (Context ∊ Func ⋄ Bracket ∊ No)              → SYNTAX ERROR →
    ⍝   (Context ∊ Func ⋄ Value ∊ EMPTY ⋄ Cond ∊ No) → wait         →
    ⍝   (Context ∊ Fnex ⋄ Nest ∊ NONE ⋄ ~Oper ∊ MON) → VALUE ERROR  →
    ⍝   (Context ∊ Fnex ⋄ Oper ∊ MON ⋄ Nest ∊ NONE)  → SYNTAX ERROR →
    ⍝   (Context ∊ Fnex ⋄ Nest ∊ EMPTY)              → wait         →
        
    
    ⍝ Token: Va
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Top Func Fnex)                                             → SYNTAX ERROR →
    ⍝   (Context ∊ Expr ⋄ Nest ∊ NONE ⋄ Class ∊ FUNC ⋄ Last Seen ∊ EMPTY LIT) → okay         →
    ⍝   (Context ∊ Expr ⋄ Nest ∊ RBRACK)                                      → okay         →
    ⍝   (Context ∊ Expr ⋄ Nest ∊ NONE ⋄ Class ∊ ATOM ⋄ Last Seen ∊ EMPTY LIT) → atomic       →
    ⍝   (Context ∊ Expr ⋄ Nest ∊ NONE ⋄ Class ∊ SELECT ⋄ Last Seen ∊ EMPTY)   → selective    →
    ⍝   (Context ∊ Expr ⋄ Nest ∊ NONE ⋄ Class ∊ SELECT ⋄ Last Seen ∊ LIT)     → okay         →
    
    ⍝ Token: {
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Top Expr Fnex)        → SYNTAX ERROR →
    ⍝   (Context ∊ Func ⋄ Bracket ∊ No)  → wait         →
    ⍝   (Context ∊ Func ⋄ Bracket ∊ Yes) → SYNTAX ERROR →
    
    ⍝ Token: }
    ⍝
    ⍝ State-Box Definition:
    ⍝   (Context ∊ Top Expr Fnex)                               → SYNTAX ERROR →
    ⍝   (Context ∊ Func ⋄ Value ∊ EXPR FUNC)                    → okay         →
    ⍝   (Context ∊ Func ⋄ Bind ∊ NO ⋄ Value ∊ EMPTY)            → okay         →
    ⍝   (Context ∊ Func ⋄ Bind ∊ BOUND ⋄ Value ∊ FVAR FUNC)     → okay         →
    ⍝   (Context ∊ Func ⋄ Bracket ∊ No)                         → SYNTAX ERROR →
    ⍝   (Context ∊ Func ⋄ Value ∊ UNBOUND)                      → VALUE ERROR  →
    ⍝   (Context ∊ Func ⋄ Bind ∊ NO ⋄ Value ∊ FVAR)             → SYNTAX ERROR →
    ⍝   (Context ∊ Func ⋄ Bind ∊ BOUND UNBOUND ⋄ Value ∊ EMPTY) → SYNTAX ERROR →
  }
  
  ⍝ We convert the tokens into a vector of token elements, inserting Nl Tokens 
  ⍝ as appropriate.
  Nl←1 4⍴2 'Newline' '' (0 2⍴⍬)
  Tks←(1=0⌷⍉Tks)⊂[0]Tks←(1≤0⌷⍉⍵)⌿⍵
  Tks←1 4∘⍴¨↓(2≤0⌷⍉Tks)⌿⊃⍪/,(⍪Tks),⊂Nl
  
  ⍝ The trasition function is applied as a fixpoint with the initial state 
  ⍝ and the vector of tokens. We return the contents of the AST and Names cells.
  (⊃Asts)Env⊣Asts Env←2↑Tks Next⍣≡XXX
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
  
  ⍝ It is helpful to know which nodes are functions expressions and which are 
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
  ST←{A⊣A[;0]←1+3|A[;0]⊣A←⍵}¨(2×FeBV)⊖¨ST
  
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
  
  ⍝ For each global we general some code
  Mod⊣Mod∘GenGlobal¨(1=⍵[;0])⊂[0]⍵
}

GenGlobal←{
  'Expression'≡⊃0 1⌷⍵:⍺ GenConst ⍵
  'FuncExpr'≡⊃0 1⌷⍵:⍺ GenFunc ⍵
  ⎕SIGNAL 99
}

GenArrayType←{
  lt←(Int16Type)(Int64Type)(Int4Type)(Int64Type)(Int64Type)
  StructType lt 5 0
}

GenFuncType←{
  FunctionType (GenArrayType ⍬) ⍬ 0 0
}

GenConst←{
  V←'value'Prop 1↓⍵
  D←{ConstIntOfString (Int64Type) ⍵ 10}¨V
  Da←ConstArray (Int64Type) D (⊃⍴D)
  S←{ConstInt (Int32Type) ⍵ 0}¨⍴V
  Sa←ConstArray (Int64Type) S (⊃⍴S)
  R←ConstInt (Int16Type) (⊃⍴⍴V) 0
  Sz←ConstInt (Int64Type) (⊃⍴V) 0
  T←ConstInt (Int4Type) 2 0
  A←ConstStruct (R Sz T Sa Da) 5 0
  G←AddGlobal ⍺ (GenArrayType ⍬)(⊃'name'Prop 1↑⍵)
  0 0⍴SetInitializer G A
}

GenFunc←{
  fn←(0 3)(0 1)⊃⍵
  vn←(2 3)(0 1)⊃⍵
  fr←AddFunction ⍺ fn (GenFuncType ⍬)
  vr←GetNamedGlobal ⍺ vn
  bb←AppendBasicBlock fr ''
  bldr←CreateBuilder
  _←PositionBuilderAtEnd bldr bb
  _←BuildRet bldr vr
  _←DisposeBuilder bldr
  0 0⍴fr
}

⍝ Utility Constants

EmptyAttr←0 2⍴⊂''
EmptyAST←0 4⍴0 '' '' EmptyAttr
EmptyNTEnv←0 2⍴'' 0

⍝ Utility Functions

Prop←{(¯1⌽P∊⊂⍺)/P←,↑⍵[;3]}
ByElem←{(⍺[;1]∊⊂⍵)/[0]⍺}
ByDepth←{(⍵=⍺[;0])/[0]⍺}

Bind←{
  An←(A←⊃0 3⌷⍵)[;0]
  Ns←⊃'name'Prop 1↑⍵
  Ns,←⍺
  A←(~An∊⊂'name')/[0]A
  A⍪←'name' Ns
  Ast←⍵
  Ast[0;3]←⊂A
  Ast
}

Comment←{⍺}

VarType←{
  (⍺[;1],0)[⍺[;0]⍳⊂⍵]
}

⍝ Foreign Functions

∇{Z}←FFI∆INIT
Z←⍬

'Int16Type'⎕NA 'P CoDfns|Int16Type'
'Int64Type'⎕NA 'P CoDfns|Int64Type'
'Int32Type'⎕NA 'P CoDfns|Int32Type'
'Int4Type'⎕NA 'P CoDfns|Int4Type'
'StructType'⎕NA 'P CoDfns|StructType <P[] U I'
'FunctionType'⎕NA 'P CoDfns|FunctionType P <P[] U I'
'ConstIntOfString'⎕NA 'P CoDfns|ConstIntOfString P <0C[] U8'
'ConstArray'⎕NA 'P CoDfns|ConstArray P <P[] U'
'ConstInt'⎕NA 'P CoDfns|ConstInt P U8 I'
'AddGlobal'⎕NA 'P CoDfns|AddGlobal P P <0C[]'
'SetInitializer'⎕NA 'CoDfns|SetInitializer P P'
'AddFunction'⎕NA 'P CoDfns|AddFunction P <0C[] P'
'GetNamedGlobal'⎕NA 'P CoDfns|GetNamedGlobal P <0C[]'
'AppendBasicBlock'⎕NA 'P CoDfns|AppendBasicBlock P <0C[]'
'CreateBuilder'⎕NA 'P CoDfns|CreateBuilder'
'PositionBuilderAtEnd'⎕NA 'P CoDfns|PositionBuilderAtEnd P P'
'BuildRet'⎕NA 'P CoDfns|BuildRet P P'
'DisposeBuilder'⎕NA 'P CoDfns|DisposeBuilder P'
'ConstStruct'⎕NA'P CoDfns|ConstStruct <P[] U I'

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