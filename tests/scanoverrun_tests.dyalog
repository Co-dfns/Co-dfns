:Namespace scanoverrun_tests

S←':Namespace' 'Run←{(⍺=⍺)/⍵}' ':EndNamespace'

'01'('scanoverrun' S 'Run' #.util.GEN∆T2 ⎕THIS) (1 1 1 1 1 1 1 1 1 1) (10×⍳10)

:EndNamespace
