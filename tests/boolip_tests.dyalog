:Namespace boolip_tests

S←':Namespace' 'Run←{⍺∧.=⍵}' ':EndNamespace'

'01'('boolip' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍉2 10⍴⍳10) (2 10⍴⍳10)

:EndNamespace
