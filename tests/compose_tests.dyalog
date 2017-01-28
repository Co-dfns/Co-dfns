:Namespace compose

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
B←?100⍴2
S←':Namespace' 'Rm←{×∘-⍵}' 'Rd←{⍺×∘-⍵}' ':EndNamespace'

'01'('compose' S 'Rm' #.util.GEN∆T1 ⎕THIS) I
'02'('compose' S 'Rd' #.util.GEN∆T2 ⎕THIS) I I

:EndNamespace

