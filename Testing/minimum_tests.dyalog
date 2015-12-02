:Namespace minimum

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺⌊⍵}' ':EndNamespace'

'ii'('minimum' S 'Run' #.util.GEN∆T2 ⎕THIS) I I
'ff'('minimum' S 'Run' #.util.GEN∆T2 ⎕THIS) F F
'if'('minimum' S 'Run' #.util.GEN∆T2 ⎕THIS) I F
'fi'('minimum' S 'Run' #.util.GEN∆T2 ⎕THIS) F I

:EndNamespace

