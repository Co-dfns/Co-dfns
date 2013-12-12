:Namespace Stimuli

⎕IO ⎕ML←0 1

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Overview
⍝
⍝ The Stimuli namespace allows you to map the abstract sequences of
⍝ the function specification to real life code in one form or
⍝ another. It also contains convenience sets that can be used when
⍝ developing the various usage models.
⍝
⍝ The namespace is designed so that you should be able to take any given 
⍝ Top Level Stimuli sequence and obtain a valid input to the ⎕FIX or 
⍝ CoDfns.Fix function. This is done with the Expand function.

⍝ (Case Increment)Expand Sequence
⍝   Case      The Use Case to use 
⍝   Increment The Increment to use
⍝
⍝ Expand a stimuli sequence into a valid input to ⎕FIX
⍝ The basic idea here is to treat each stimuli as a function and 
⍝ reduce the stimuli sequence by evaluating each of the stimuli function. 

Expand←{⊃⍺{⍺⍺(⍎⍺)⍵}/(Trans ¯1↓¨(' '=⍵)⊂1⌽⍵),⊂0⍴⊂''}

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Stimuli Sets

Expression←,¨'E' 'Es' 'Fea' 'Fed' 'Fem' '[' ']' '(' ')' ';' '←' 'Break' 'N' 'S'
Expression,←'Sm' 'Sd' 'Va' 'Vna' 'Vi' 'Vnu'

FuncExpr←,¨'E' 'Ea' 'Fea' 'Feaa' 'Fed' 'Feda' 'Fem' 'Fema' 'Feo' 'Fn' 'Fnd' 
FuncExpr,←,¨'Fnm' '[' ']' '(' ')' '←' '⍨' '∘' '¨' '.' '⍣' '/' '⌿' '\' '⍀' 
FuncExpr,←,¨'Break' 'D' 'Da' 'M' 'Ma' 'Vi' 'Vf' 'Vo' 'Vu'

Function←,¨'E' 'Fe' 'Fnm' 'Fnd' '{' '}' ':' '::' '⋄' '←' 'Break' 'Nl' 'Vfo' 'Vu'

TopLevel←,¨'E' 'Fe' 'Fnm' 'Fnd' '⋄' '←' 'Break' 'Eot' 'Fix' 'Fnb' 'Fne' 'Fnf' 
TopLevel,←'Lle' 'Lls' 'Nl' 'Nse' 'Nss' 'Vi' 'Vfo' 'Vu'

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Translations
⍝ 
⍝ While most of the stimuli above are valid function names, some of them 
⍝ correspond to other syntax in the language, and they cannot be executed 
⍝ directly. We setup a set of translations to ensure that the stimuli get 
⍝ translated into function names that we can bind to functions below.

TransTbl←,¨↑('[' 'Lbrk') (']' 'Rbrk') ('(' 'Lpar') (')' 'Rpar') (';' 'Semi') 
TransTbl⍪←,¨↑('←' 'Gets') ('⍨' 'Comm') ('∘' 'Jot') ('¨' 'Each') ('.' 'Dot') 
TransTbl⍪←,¨↑('⍣' 'Pow') ('/' 'Red') ('⌿' 'Fred') ('\' 'Scn') ('⍀' 'Fscn')
TransTbl⍪←,¨↑('{' 'Lbrc') ('}' 'Rbrc') (':' 'Col') ('::' 'Dcol') ('⋄' 'Sep')

Trans←{(((⍳⍴⍵)×I=⊃⍴TransTbl)+I←(0⌷⍉TransTbl)⍳⍵)⊃¨⊂(1⌷⍉TransTbl),⍵}

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Stimuli Functions
⍝
⍝ Each stimuli function mentioned below is designed to fit the same interface,
⍝ which is to have the (UseCase Increment) as the left argument and the current 
⍝ code object as the right argument.
⍝
⍝ The code object is a vector of strings, which may be empty. We actively rely 
⍝ on the invariant that ⊃⍵ will be the top string of the code and 1↓⍵ will give 
⍝ the rest of the code. 

⍝ Recursive Stimuli

MkRec←{
  X←⍺ Expand ⊃1 #.Generate.Distribution ⍺ #.Generate.DModel ⍺⍺
  ((¯1↓X),⊂(⊃⌽X),⊃⍵),1↓⍵
}

E←'Expression'MkRec
Fe←'FuncExpr'MkRec

⍝ Fn←'Function'MkRec
⍝ Hack to make Increment 2 work right for now
Fn←{(⊂'{',(⍕?(1+?10)⍴2*20),'}',⊃⍵),1↓⍵}

⍝ Non-recursive Stimuli

Counter←0
Vu←{(⊃Counter)+←1 ⋄ (⊂'V',(⍕Counter),' ',⊃⍵),1↓⍵}
Vnu←{⍺ Vu ⍵}
Gets←{(⊂'← ',⊃⍵),1↓⍵}
Eot←{⍵}
Fix←{⍵}
Fne←{⍵}
Lls←{⍵}
Nl←{(⊂''),⍵}
Nse←{'' ':EndNamespace',⍵}
Nss←{'' ':Namespace',⍵}
Lbrc←{(⊂'{ ',⊃⍵),1↓⍵}
Rbrc←{(⊂'} ',⊃⍵),1↓⍵}
N←{(⊂(⍕?2*30),' ',⊃⍵),1↓⍵}

:EndNamespace 