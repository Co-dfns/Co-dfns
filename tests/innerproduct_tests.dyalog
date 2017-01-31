:Namespace innerproduct

S1←':Namespace' 'R1←{⍺+.×⍵}' ':EndNamespace'
S2←':Namespace' 'R2←{⍺{⍺+⍵}.{⍺×⍵}⍵}' ':EndNamespace'
S3←':Namespace' 'R3←{⍺=.+⍵}' ':EndNamespace'

'01'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(1)        (1)
'02'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(1)        (⍬)
'03'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(⍬)        (⍬)
'04'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(5)        (1+⍳3)
'05'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(1+⍳3)     (5)
'06'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(1+⍳3)     (1+⍳3)
'07'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(1+⍳7)     (7 2⍴3)
'08'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(2 7⍴3)    (1+⍳7)
'09'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(3 2⍴1+⍳4) (2 5⍴1+⍳4)
'10'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(3 2⍴1+⍳4) (2 5⍴÷1+⍳4)
'11'('innerproduct' S2 'R2' #.util.GEN∆T2 ⎕THIS)(1)        (1)
'12'('innerproduct' S2 'R2' #.util.GEN∆T2 ⎕THIS)(5)        (1+⍳3)
'13'('innerproduct' S2 'R2' #.util.GEN∆T2 ⎕THIS)(1+⍳3)     (5)
'14'('innerproduct' S2 'R2' #.util.GEN∆T2 ⎕THIS)(1+⍳3)     (1+⍳3)
'15'('innerproduct' S2 'R2' #.util.GEN∆T2 ⎕THIS)(1+⍳7)     (7 2⍴3)
'16'('innerproduct' S2 'R2' #.util.GEN∆T2 ⎕THIS)(2 7⍴3)    (1+⍳7)
'17'('innerproduct' S2 'R2' #.util.GEN∆T2 ⎕THIS)(3 2⍴1+⍳4) (2 5⍴1+⍳4)
'18'('innerproduct' S2 'R2' #.util.GEN∆T2 ⎕THIS)(3 2⍴1+⍳4) (2 5⍴÷1+⍳4)
'19'('innerproduct' S3 'R3' #.util.GEN∆T2 ⎕THIS)(1)        (÷2+⍳5)
'20'('innerproduct' S1 'R1' #.util.GEN∆T2 ⎕THIS)(0 5⍴5)    (5 5⍴3)

:EndNamespace
