:Namespace uniqop_tests

S←':Namespace' 'Run←{(∪⍵)∘.=⍵}' ':EndNamespace'

'01'('uniqop' S 'Run' #.util.GEN∆T1 ⎕THIS) (0 0 0 1 1 1 1 1)

:EndNamespace
