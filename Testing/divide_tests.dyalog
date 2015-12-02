:Namespace divide

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺÷⍵}' ':EndNamespace'

'ii'('divide' S 'Run' #.util.GEN∆T2 ⎕THIS) I I
'ff'('divide' S 'Run' #.util.GEN∆T2 ⎕THIS) F F
'if'('divide' S 'Run' #.util.GEN∆T2 ⎕THIS) I F
'fi'('divide' S 'Run' #.util.GEN∆T2 ⎕THIS) F I

:EndNamespace

