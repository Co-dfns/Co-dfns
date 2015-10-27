:Namespace innerproduct

S←':Namespace' 'R1←{⍺+.×⍵}' 'R2←{⍺{⍺+⍵}.{⍺×⍵}⍵}' 'R3←{⍺=.+⍵}' ':EndNamespace'

'01'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(1)	(1)
'02'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(1)	(#.I ⍬)
'03'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I ⍬)	(#.I ⍬)
'04'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 5)	(#.I 1+⍳3)
'05'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 1+⍳3)	(#.I 5)
'06'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 1+⍳3)	(#.I 1+⍳3)
'07'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 1+⍳7)	(#.I 7 2⍴3)
'08'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 2 7⍴3)	(#.I 1+⍳7)
'09'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 3 2⍴1+⍳4)	(#.I 2 5⍴1+⍳4)
'10'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 3 2⍴1+⍳4)	(2 5⍴÷1+⍳4)
'11'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(1)	(1)
'12'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 5)	(#.I 1+⍳3)
'13'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 1+⍳3)	(#.I 5)
'14'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 1+⍳3)	(#.I 1+⍳3)
'15'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 1+⍳7)	(#.I 7 2⍴3)
'16'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 2 7⍴3)	(#.I 1+⍳7)
'17'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 3 2⍴1+⍳4)	(#.I 2 5⍴1+⍳4)
'18'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 3 2⍴1+⍳4)	(2 5⍴÷1+⍳4)
'19'('innerproduct' S 'R3' #.GEN∆T2 ⎕THIS)(#.I 1)	(÷2+⍳5)

:EndNamespace
