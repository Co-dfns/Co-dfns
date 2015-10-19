:Namespace innerproduct

S←':Namespace' 'R1←{⍺+.×⍵}' 'R2←{⍺{⍺+⍵}.{⍺×⍵}⍵}' 'R3←{⍺+.|⍵}' ':EndNamespace'

'01'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(1)            (1)
⍝[c]'02'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(1)            (#.I ⍬)
⍝[c]'03'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I ⍬)        (#.I ⍬)
⍝[c]'04'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I ⍬)        (#.I 1+⍳3)
⍝[c]'05'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 1+⍳3)     (#.I ⍬)
⍝[c]'06'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(5)            (#.I 1+⍳3)
⍝[c]'07'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 1+⍳3)     (#.I 1+⍳3)
⍝[c]'08'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴3)    (#.I 1+⍳7)
⍝[c]'09'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴1+⍳4) (#.I 2 2⍴1+⍳4)
⍝[c]'10'('innerproduct' S 'R1' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴1+⍳4) (2 2⍴÷1+⍳4)
⍝[c]'11'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(1)            (1)
⍝[c]'12'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(1)            (#.I ⍬)
⍝[c]'13'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I ⍬)        (#.I ⍬)
⍝[c]'14'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I ⍬)        (#.I 1+⍳3)
⍝[c]'15'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 1+⍳3)     (#.I ⍬)
⍝[c]'16'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(5)            (#.I 1+⍳3)
⍝[c]'17'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 1+⍳3)     (#.I 1+⍳3)
⍝[c]'18'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴3)    (#.I 1+⍳7)
⍝[c]'19'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴1+⍳4) (#.I 2 2⍴1+⍳4)
⍝[c]'20'('innerproduct' S 'R2' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴1+⍳4) (2 2⍴÷1+⍳4)

:EndNamespace

