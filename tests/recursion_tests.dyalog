:Namespace recursion

S1←':Namespace' 'fact←{⍵≤0: 1 ⋄ ⍵×fact ⍵-1}' ':EndNamespace'
S2←':Namespace' 'fact←{⍵≤0: 1 ⋄ ⍵×∇ ⍵-1}' ':EndNamespace'

'01'('guards' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5 
'02'('guards' S2 'Run' #.util.GEN∆T1 ⎕THIS) 5 

:EndNamespace
