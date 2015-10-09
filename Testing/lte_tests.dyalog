:Namespace lte

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺≤⍵}' ':EndNamespace'

'ii'('lte' S 'Run' #.GEN∆T2 ⎕THIS) I I
'ff'('lte' S 'Run' #.GEN∆T2 ⎕THIS) F F
'if'('lte' S 'Run' #.GEN∆T2 ⎕THIS) I F
'fi'('lte' S 'Run' #.GEN∆T2 ⎕THIS) F I

:EndNamespace

