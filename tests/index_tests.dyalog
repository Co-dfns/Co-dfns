:Namespace index_tests

index∆01_TEST←'index∆R1'#.util.MK∆T2 (⍬)	(5)
index∆02_TEST←'index∆R1'#.util.MK∆T2 (⍬)	(⍳5)
index∆03_TEST←'index∆R1'#.util.MK∆T2 (,1)	(⍳5)
index∆04_TEST←'index∆R1'#.util.MK∆T2 (1)	(⍳5)
index∆05_TEST←'index∆R1'#.util.MK∆T2 (1 2)	(3 3⍴⍳5)
index∆06_TEST←'index∆R1'#.util.MK∆T2 (1 2)	(3 3 3⍴⍳27)
index∆07_TEST←'index∆R2'#.util.MK∆T1  	(⍳5)
index∆08_TEST←'index∆R3'#.util.MK∆T2 (5)	(?30 30⍴5)
index∆09_TEST←'index∆R4'#.util.MK∆T2 (7 15,,?7 15⍴30)	(?50 50⍴10)
index∆10_TEST←'index∆R1'#.util.MK∆T2 (1)	(3 3 3⍴⍳27)
index∆11_TEST←'index∆R1'#.util.MK∆T2 (0)	(20 20⍴⍳400)
index∆12_TEST←'index∆R2'#.util.MK∆T1  	(20 20⍴⍳400)
index∆13_TEST←'index∆R1'#.util.MK∆T2 (0)	(?3 20⍴1000)


:EndNamespace
