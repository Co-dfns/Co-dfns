:Namespace index

S1←':Namespace' 'Run←{⍺⌷⍵}' 'Lit←{1⌷⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{X←⍳⍺ ⋄ Y←⍳⍺ ⋄ X Y⌷⍵}' ':EndNamespace'
S3←':Namespace' 'Run←{R←0⌷⍺ ⋄ C←1⌷⍺ ⋄ I←R↑2↓⍺ ⋄ J←C↑(2+R)↓⍺ ⋄ I J⌷⍵}' ':EndNamespace'

'01' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)	(5)
'02' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)	(⍳5)
'03' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(,1)	(⍳5)
'04' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(1)	(⍳5)
'05' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(1 2)	(3 3⍴⍳5)
'06' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(1 2)	(3 3 3⍴⍳27)
'07' ('index' S1 'Lit' #.util.GEN∆T1 ⎕THIS) 	⍳5
'08' ('index' S2 'Run' #.util.GEN∆T2 ⎕THIS)(5)	(?30 30⍴5)
'09' ('index' S3 'Run' #.util.GEN∆T2 ⎕THIS)(7 15,,?7 15⍴30)	(?50 50⍴10)
'10' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(1)	(3 3 3⍴⍳27)
'11' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(0)	(20 20⍴⍳400)
'12' ('index' S1 'Lit' #.util.GEN∆T1 ⎕THIS) 	20 20⍴⍳400
'13' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(0)	(?3 20⍴1000)


:EndNamespace
