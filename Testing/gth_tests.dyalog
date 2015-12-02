:Namespace gth

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺>⍵}' ':EndNamespace'

'ii'('gth' S 'Run' #.util.GEN∆T2 ⎕THIS) I I
'ff'('gth' S 'Run' #.util.GEN∆T2 ⎕THIS) F F
'if'('gth' S 'Run' #.util.GEN∆T2 ⎕THIS) I F
'fi'('gth' S 'Run' #.util.GEN∆T2 ⎕THIS) F I

:EndNamespace

