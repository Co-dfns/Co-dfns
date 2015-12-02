:Namespace not

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}?10⍴2

S←':Namespace' 'Run←{~⍵}' ':EndNamespace'

'i'('negative' S 'Run' #.util.GEN∆T1 ⎕THIS) I

:EndNamespace

