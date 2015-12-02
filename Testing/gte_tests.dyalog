:Namespace gte

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺≥⍵}' ':EndNamespace'

'ii'('gte' S 'Run' #.util.GEN∆T2 ⎕THIS) I I
'ff'('gte' S 'Run' #.util.GEN∆T2 ⎕THIS) F F
'if'('gte' S 'Run' #.util.GEN∆T2 ⎕THIS) I F
'fi'('gte' S 'Run' #.util.GEN∆T2 ⎕THIS) F I

:EndNamespace

