:Namespace match_tests

match∆01_TEST←'match∆Run'#.util.MK∆T2 (⍬)	(⍬)
match∆02_TEST←'match∆Run'#.util.MK∆T2 (0)	(0)
match∆03_TEST←'match∆Run'#.util.MK∆T2 (⍬)	(0)
match∆04_TEST←'match∆Run'#.util.MK∆T2 (⍬)	(⍳5)
match∆05_TEST←'match∆Run'#.util.MK∆T2 (⍳7)	(⍳5)
match∆06_TEST←'match∆Run'#.util.MK∆T2 (0)	(⍳5)
match∆07_TEST←'match∆Run'#.util.MK∆T2 (2 2⍴⍳4)	(2 2⍴⍳4)
match∆08_TEST←'match∆Run'#.util.MK∆T2 (2 2 3⍴⍳12)	(2 2⍴⍳4)
match∆09_TEST←'match∆Run'#.util.MK∆T2 (2 2⍴⍳4)	(2 2 3⍴⍳12)
match∆10_TEST←'match∆Run'#.util.MK∆T2 (2 2 3⍴⍳12)	(2 2 3⍴1+⍳12)
match∆11_TEST←'match∆Run'#.util.MK∆T2 (0)	(2 2⍴⍳4)
match∆12_TEST←'match∆Run'#.util.MK∆T2 (,0)	(2 2⍴⍳4)
match∆13_TEST←'match∆Run'#.util.MK∆T2 (,0)	(,0)

:EndNamespace

