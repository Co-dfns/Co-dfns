:Namespace bitvector

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺∧0≠⍵}' ':EndNamespace'

B1←?15⍴3
B2←?15⍴3

Fn←{A←⍵ #.codfns.MKA 15⍴1
 B←⍵ #.codfns.MKA B1 ⋄ _←⍺⍺ A A B ⋄ _←⍵ #.codfns.FREA B
 B←⍵ #.codfns.MKA B2 ⋄ _←⍺⍺ A A B
 Z←⍵ #.codfns.EXA A ⋄ (⎕DR Z) Z}

bitvector∆01_TEST←{id ns fn←'bitvector01' S 'Run'
 #.UT.expect←0 ⋄ EX←⊃{⍵∧0≠⍺}/B1 B2 1
 #.UT.expect←(⎕DR EX) EX
 CS←id #.codfns.Fix ns ⋄ so←#.codfns.BSO id
 _←'Run'⎕NA so,'|Run_cdf P P P' ⋄ Run Fn id}

:EndNamespace

