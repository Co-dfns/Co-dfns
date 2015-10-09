:Namespace ravel

S←':Namespace' 'Run←{,⍵}' ':EndNamespace'

'1'('ravel' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'2'('ravel' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'3'('ravel' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'4'('ravel' S 'Run' #.GEN∆T1 ⎕THIS) ÷2 2⍴1+⍳5

:EndNamespace

