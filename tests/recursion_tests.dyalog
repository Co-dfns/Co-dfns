:Namespace recursion

S1←':Namespace' 'fact←{⍵≤0: 1 ⋄ ⍵×fact ⍵-1}' ':EndNamespace'
S2←':Namespace' 'fact←{⍵≤0: 1 ⋄ ⍵×∇ ⍵-1}' ':EndNamespace'

'01'('recursion' S1 'fact' #.util.GEN∆T1 ⎕THIS) 5 
'02'('recursion' S2 'fact' #.util.GEN∆T1 ⎕THIS) 5 

:EndNamespace
