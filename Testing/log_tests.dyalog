:Namespace log

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺⍟⍵}' ':EndNamespace'

'ii'('log' S 'Run' #.GEN∆T2 ⎕THIS) I I
'ff'('log' S 'Run' #.GEN∆T2 ⎕THIS) F F
'if'('log' S 'Run' #.GEN∆T2 ⎕THIS) I F
'fi'('log' S 'Run' #.GEN∆T2 ⎕THIS) F I

:EndNamespace

