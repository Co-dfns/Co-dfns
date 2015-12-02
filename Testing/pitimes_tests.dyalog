:Namespace pitimes

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{○⍵}' ':EndNamespace'

'i'('pitimes' S 'Run' #.util.GEN∆T1 ⎕THIS) I
'f'('pitimes' S 'Run' #.util.GEN∆T1 ⎕THIS) F

:EndNamespace

