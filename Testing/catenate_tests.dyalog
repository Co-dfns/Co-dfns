:Namespace catenate

S←':Namespace' 'Run←{⍺,⍵}' ':EndNamespace'

'01'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I ⍬)
'02'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)       (#.I 0)
'03'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I 0)
'04'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)       (#.I ⍳5)
'05'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍳7)      (#.I ⍳5)
'06'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)       (#.I ⍳5)
'07'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴0)   (#.I 2 2⍴0)
'08'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2 3⍴0) (#.I 2 2⍴0)
'09'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴0)   (#.I 2 2 3⍴0)
'10'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴0)   (#.I 2 2 3⍴0)
'11'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)       (#.I 2 2⍴0)
'12'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,0 0)    (#.I 2 2⍴0)
'13'('catenate' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,0)      (#.I ,0)

:EndNamespace

