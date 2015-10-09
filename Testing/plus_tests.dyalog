:Namespace plus

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺+⍵}' ':EndNamespace'

'ii'('plus' S 'Run' #.GEN∆T2 ⎕THIS) I I
'ff'('plus' S 'Run' #.GEN∆T2 ⎕THIS) F F
'if'('plus' S 'Run' #.GEN∆T2 ⎕THIS) I F
'fi'('plus' S 'Run' #.GEN∆T2 ⎕THIS) F I

:EndNamespace

