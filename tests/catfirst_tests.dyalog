:Namespace catfirst

S←':Namespace' 'Run←{⍺⍪⍵}' ':EndNamespace'

'01'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)       (⍬)
'02'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)       (5)
'03'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)       (5)
'04'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)       (⍳5)
'05'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳7)      (⍳5)
'06'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)       (⍳5)
'07'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴5)   (2 2⍴5)
'08'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 3⍴5) (2 3⍴5)
'09'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 3⍴5)   (2 2 3⍴5)
'10'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 3⍴5)   (2 2 3⍴5)
'11'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)       (2 2⍴5)
'12'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(,5 5)    (2 2⍴5)
'13'('catfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(,5)      (,5)

:EndNamespace

