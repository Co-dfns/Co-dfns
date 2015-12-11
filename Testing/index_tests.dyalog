:Namespace index

S1←':Namespace' 'Run←{⍺⌷⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{X←⍳⍺ ⋄ Y←⍳⍺ ⋄ X Y⌷⍵}' ':EndNamespace'

'01' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)	(5)
'02' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)	(⍳5)
'03' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(,1)	(⍳5)
'04' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(1)	(⍳5)
'05' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(1 2)	(3 3⍴⍳5)
'06' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(1 2)	(3 3 3⍴⍳27)
'07' ('index' S2 'Run' #.util.GEN∆T2 ⎕THIS)(5)	(?30 30⍴5)

:EndNamespace
