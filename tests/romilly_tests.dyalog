:Namespace romilly_tests

g3connector←{⍺←4 ⋄ ⍺≥?25⍴⍨25,⍵}
g3inputs←{1=?⍵⍴2}

romilly∆1_TEST←'romilly∆Run'#.util.MK∆T2 (g3connector 30 30) (g3inputs 30 30)
romilly∆2_TEST←'romilly∆Run'#.util.MK∆T2 (g3connector 300 300) (g3inputs 300 300)

:EndNamespace

