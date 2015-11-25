:Namespace catenate

S←':Namespace' 'Run←{⍺,⍵}' ':EndNamespace'

'01'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I ⍬)
'02'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 5)       (#.I 5)
'03'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I 5)
'04'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I ⍳5)
'05'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍳7)      (#.I ⍳5)
'06'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 5)       (#.I ⍳5)
'07'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴5)   (#.I 2 2⍴5)
'08'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2 3⍴5) (#.I 2 2⍴5)
'09'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴5)   (#.I 2 2 3⍴5)
'10'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴5)   (#.I 2 2 3⍴5)
'11'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 5)       (#.I 2 2⍴5)
'12'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,5 5)    (#.I 2 2⍴5)
'13'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,5)      (#.I ,5)

:EndNamespace

