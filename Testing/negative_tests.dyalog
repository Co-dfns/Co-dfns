:Namespace negative

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{-⍵}' ':EndNamespace'

'i'('negative' S 'Run' #.util.GEN∆T1 ⎕THIS) I
'f'('negative' S 'Run' #.util.GEN∆T1 ⎕THIS) F

:EndNamespace

