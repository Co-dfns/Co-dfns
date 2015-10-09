:Namespace catfirst

S←':Namespace' 'Run←{⍺⍪⍵}' ':EndNamespace'

'01'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I ⍬)
'02'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)       (#.I 0)
'03'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I 0)
'04'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I ⍳5)
'05'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍳7)      (#.I ⍳5)
'06'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)       (#.I ⍳5)
'07'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴0)   (#.I 2 2⍴0)
'08'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2 3⍴0) (#.I 2 3⍴0)
'09'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 3⍴0)   (#.I 2 2 3⍴0)
'10'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 3⍴0)   (#.I 2 2 3⍴0)
'11'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)       (#.I 2 2⍴0)
'12'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,0 0)    (#.I 2 2⍴0)
'13'('catfirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,0)      (#.I ,0)

:EndNamespace

