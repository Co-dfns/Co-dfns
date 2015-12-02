:Namespace ravel

S←':Namespace' 'Run←{,⍵}' ':EndNamespace'

'1'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'2'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'3'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'4'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) ÷2 2⍴1+⍳5

:EndNamespace

