:Namespace multiply

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺×⍵}' ':EndNamespace'

'ii'('multiply' S 'Run' #.GEN∆T2 ⎕THIS) I I
'ff'('multiply' S 'Run' #.GEN∆T2 ⎕THIS) F F
'if'('multiply' S 'Run' #.GEN∆T2 ⎕THIS) I F
'fi'('multiply' S 'Run' #.GEN∆T2 ⎕THIS) F I

:EndNamespace

