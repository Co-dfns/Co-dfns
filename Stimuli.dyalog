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

⍝ (Case Increment)Expand TopLevelSequence
⍝   Case      The Use Case to use 
⍝   Increment The Increment to use
⍝
⍝ Expand a Top Level stimuli sequence into a valid input to ⎕FIX
⍝ The basic idea here is to treat each stimuli as a function and 
⍝ reduce the stimuli sequence by evaluating each of the stimuli function. 

Expand←{⊃⍺{⍺⍺(⍎⍺)⍵}/(Trans ¯1↓¨(1,¯1↓' '=⍵)⊂⍵),⊂⍬}

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

Trans←{(((⍳⍴⍵)×I=⍴⍵)+I←(0⌷⍉TransTbl)⍳⍵)⊃¨⊂(1⌷⍉TransTbl),⍵}

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Recursive Stimuli

E←{}

Fe←{}

Fn←{}

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Non-recursive Stimuli

:EndNamespace 