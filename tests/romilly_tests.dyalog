:Namespace romilly_tests

S←⊂':Namespace'
S,←⊂'spin←{z←(¯2⊖⍵)⍪(¯1⊖⍵)⍪⍵⍪(1⊖⍵)⍪2⊖⍵ ⋄ (25,⍴⍵)⍴(¯2⌽z)⍪(¯1⌽z)⍪z⍪(1⌽z)⍪2⌽z}'
S,←⊂'granule3←{s←spin ⍵ ⋄ (4×+⌿⍺×s)>+⌿s}'
S,←⊂':EndNamespace'

g3connector←{⍺←4 ⋄ ⍺≥?25⍴⍨25,⍵}
g3inputs←{1=?⍵⍴2}

'1'('romilly' S 'granule3' #.util.GEN∆T2 ⎕THIS) (g3connector 30 30) (g3inputs 30 30)
'2'('romilly' S 'granule3' #.util.GEN∆T2 ⎕THIS) (g3connector 300 300) (g3inputs 300 300)

:EndNamespace

