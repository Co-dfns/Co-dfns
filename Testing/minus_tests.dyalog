:Namespace minus

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺-⍵}' ':EndNamespace'

'ii'('minus' S 'Run' #.util.GEN∆T2 ⎕THIS) I I
'ff'('minus' S 'Run' #.util.GEN∆T2 ⎕THIS) F F
'if'('minus' S 'Run' #.util.GEN∆T2 ⎕THIS) I F
'fi'('minus' S 'Run' #.util.GEN∆T2 ⎕THIS) F I

:EndNamespace

