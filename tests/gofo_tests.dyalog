:Namespace gofo_tests

S←':Namespace' 'go←{⍵+⍺}' 'fo←{⍺=⍵}' 'ao←{⍺ go ⍺ fo ⍵}' ':EndNamespace'

'01'('gofo' S 'ao' #.util.GEN∆T2 ⎕THIS) 3 (1 2 3 1 2 3)

:EndNamespace

