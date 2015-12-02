:Namespace catenate

S←':Namespace' 'Run←{⍺,⍵}' ':EndNamespace'

'01'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)       (⍬)
'02'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)       (5)
'03'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)       (5)
'04'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)       (⍳5)
'05'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳7)      (⍳5)
'06'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)       (⍳5)
'07'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴5)   (2 2⍴5)
'08'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 3⍴5) (2 2⍴5)
'09'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴5)   (2 2 3⍴5)
'10'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴5)   (2 2 3⍴5)
'11'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)       (2 2⍴5)
'12'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(,5 5)    (2 2⍴5)
'13'('catenate' S 'Run' #.util.GEN∆T2 ⎕THIS)(,5)      (,5)

:EndNamespace

