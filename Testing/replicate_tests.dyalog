:Namespace replicate

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺/⍵}' ':EndNamespace'

'01'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(⍬)	(⍬)

:EndNamespace