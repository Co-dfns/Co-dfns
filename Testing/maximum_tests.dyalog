:Namespace maximum

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺⌈⍵}' ':EndNamespace'

'ii'('maximum' S 'Run' #.GEN∆T2 ⎕THIS) I I
'ff'('maximum' S 'Run' #.GEN∆T2 ⎕THIS) F F
'if'('maximum' S 'Run' #.GEN∆T2 ⎕THIS) I F
'fi'('maximum' S 'Run' #.GEN∆T2 ⎕THIS) F I

:EndNamespace

