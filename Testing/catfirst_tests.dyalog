:Namespace catfirst

S←':Namespace' 'Run←{⍺⍪⍵}' ':EndNamespace'

'01'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I ⍬)
'02'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 5)       (#.I 5)
'03'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I 5)
'04'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I ⍳5)
'05'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍳7)      (#.I ⍳5)
'06'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 5)       (#.I ⍳5)
'07'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴5)   (#.I 2 2⍴5)
'08'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2 3⍴5) (#.I 2 3⍴5)
'09'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 3⍴5)   (#.I 2 2 3⍴5)
'10'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 3⍴5)   (#.I 2 2 3⍴5)
'11'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 5)       (#.I 2 2⍴5)
'12'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,5 5)    (#.I 2 2⍴5)
'13'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,5)      (#.I ,5)

:EndNamespace

