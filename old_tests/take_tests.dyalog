:Namespace take_tests

take∆01_TEST←'take∆R1'#.util.MK∆T2 5	(⍳35)
take∆02_TEST←'take∆R2'#.util.MK∆T2 (7 5)	(⍳12)
take∆03_TEST←'take∆R1'#.util.MK∆T2 (¯5)	(⍳12)
take∆04_TEST←'take∆R1'#.util.MK∆T2 (0)	(⍳12)
take∆05_TEST←'take∆R1'#.util.MK∆T2 (1)	(12)
take∆06_TEST←'take∆R1'#.util.MK∆T2 (⍬)	(12)
take∆07_TEST←'take∆R1'#.util.MK∆T2 (⍬)	(⍳12)
take∆08_TEST←'take∆R1'#.util.MK∆T2 (2)	(5 5⍴⍳25)
take∆09_TEST←'take∆R1'#.util.MK∆T2 (2 2)	(5 5⍴⍳25)
take∆10_TEST←'take∆R1'#.util.MK∆T2 (¯2 2)	(5 5⍴⍳25)
take∆11_TEST←'take∆R1'#.util.MK∆T2 (¯2 ¯3)	(5 5⍴⍳25)
take∆12_TEST←'take∆R1'#.util.MK∆T2 (¯2)	(5 5⍴⍳25)
take∆13_TEST←'take∆R1'#.util.MK∆T2 (¯2 2)	(5 5 3⍴⍳75)
take∆14_TEST←'take∆R1'#.util.MK∆T2 (25)	(⍳12)
take∆15_TEST←'take∆R1'#.util.MK∆T2 (10 10)	(5 5⍴⍳25)
take∆16_TEST←'take∆R1'#.util.MK∆T2 (10 10)	(5)
take∆17_TEST←'take∆R1'#.util.MK∆T2 (10)	(5)
take∆18_TEST←'take∆R1'#.util.MK∆T2 (2 5 5)	(3 3 3⍴⍳27)
take∆19_TEST←'take∆R1'#.util.MK∆T2 (2 ¯5 5)	(3 3 3⍴⍳27)

:EndNamespace
