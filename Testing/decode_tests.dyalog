:Namespace decode

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{2⊥⍵}' ':EndNamespace'

'01'('decode' S 'Run' #.util.GEN∆T1 ⎕THIS) I (31⍴2)⊤1+⍳5
'02'('decode' S 'Run' #.util.GEN∆T1 ⎕THIS) (32⍴2)⊤1+⍳5

:EndNamespace