:Namespace natlog

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{⍟⍵}' ':EndNamespace'

'i'('natlog' S 'Run' #.util.GEN∆T1 ⎕THIS) I
'f'('natlog' S 'Run' #.util.GEN∆T1 ⎕THIS) F

:EndNamespace

