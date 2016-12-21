:Namespace ravel_tests

S←':Namespace' 'Run←{,⍵}' ':EndNamespace'

'1'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'2'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'3'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'4'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) ÷2 2⍴1+⍳5
'5'('ravel' S 'Run' #.util.GEN∆T1 ⎕THIS) 3 7⍴0 1

:EndNamespace
