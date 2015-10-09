:Namespace lth

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺<⍵}' ':EndNamespace'

'ii'('lth' S 'Run' #.GEN∆T2 ⎕THIS) I I
'ff'('lth' S 'Run' #.GEN∆T2 ⎕THIS) F F
'if'('lth' S 'Run' #.GEN∆T2 ⎕THIS) I F
'fi'('lth' S 'Run' #.GEN∆T2 ⎕THIS) F I

:EndNamespace

