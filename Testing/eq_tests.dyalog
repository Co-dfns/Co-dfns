:Namespace eq

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺=⍵}' ':EndNamespace'

'ii'('eq' S 'Run' #.GEN∆T2 ⎕THIS) I I
'ff'('eq' S 'Run' #.GEN∆T2 ⎕THIS) F F
'if'('eq' S 'Run' #.GEN∆T2 ⎕THIS) I F
'fi'('eq' S 'Run' #.GEN∆T2 ⎕THIS) F I

:EndNamespace

