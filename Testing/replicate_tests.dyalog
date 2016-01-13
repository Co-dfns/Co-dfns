:Namespace replicate

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺/⍵}' ':EndNamespace'

'01'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(⍬)	(⍬)
'02'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0)	(5)
'03'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 1)	(5)
'04'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 1 1)	(5 5)
'05'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 0)	(5 5)
'06'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 1 0)	(5 5)
'07'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 1)	(5 5)
'08'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 1 0 1 0)	(⍳5)

:EndNamespace