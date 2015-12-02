:Namespace materialize

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?10⍴10000
F←100÷⍨?10⍴10000

S←':Namespace' 'Run←{⌷⍵}' ':EndNamespace'

'i'('materialize' S 'Run' #.util.GEN∆T1 ⎕THIS) I
'f'('materialize' S 'Run' #.util.GEN∆T1 ⎕THIS) F

:EndNamespace

