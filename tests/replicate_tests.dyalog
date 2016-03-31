:Namespace replicate

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺/⍵}' ':EndNamespace'

⍝'01'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(⍬)	(⍬)
⍝'02'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0)	(5)
⍝'03'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 1)	(5)
⍝'04'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 1 1)	(5 5)
⍝'05'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 0)	(5 5)
⍝'06'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 1 0)	(5 5)
⍝'07'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 1)	(5 5)
⍝'08'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 1 0 1 0)	(⍳5)
⍝'09'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 1 0 2 0 3 1)	(⍳7)
⍝'10'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 1 0 ¯2 0 3 1)	(⍳7)
⍝'11'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 1 0 ¯2 0 3 1)	(7)
⍝'12'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0)	(⍳3)
⍝'13'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 1)	(⍳3)
⍝'14'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 3)	(⍳3)
⍝'15'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(I 0 1 0 ¯2 0 3 1)	(5 7⍴⍳35)
⍝'16'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(0 1 0 1 1 1 0)	(5 7⍴⍳35)
⍝'17'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(0 1 0 1 1 1 0)	(5)
'18'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(32⍴0 1 0 1 1 1 0)	(⍳32)
'19'	('replicate' S 'Run' #.util.GEN∆T2 ⎕THIS)	(14⍴0 1 0 1 1 1 0)	(⍳14)


:EndNamespace
