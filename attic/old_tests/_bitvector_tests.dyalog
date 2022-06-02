:Namespace bitvector_tests

B1←?15⍴3
B2←?15⍴3

Fn←{A←⍵ #.codfns.MKA 15⍴1
 B←⍵ #.codfns.MKA B1 ⋄ _←⍺⍺ A A B ⋄ _←⍵ #.codfns.FREA B
 B←⍵ #.codfns.MKA B2 ⋄ _←⍺⍺ A A B
 Z←⍵ #.codfns.EXA A ⋄ (⎕DR Z) Z}

bitvector∆01_TEST←{#.UT.expect←(⎕DR EX),⊂EX←⊃{⍵∧0≠⍺}/B1 B2 1
 _←'Run'⎕NA(#.codfns.BSO'tfns_cdf'),'|bitvector__Run_cdf P P P'
 Run Fn 'tfns_cdf'}

:EndNamespace

