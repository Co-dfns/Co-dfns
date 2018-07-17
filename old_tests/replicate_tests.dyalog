:Namespace replicate_tests

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

replicate∆01_TEST←'replicate∆Run'#.util.MK∆T2 (⍬)	(⍬)
replicate∆02_TEST←'replicate∆Run'#.util.MK∆T2 (I 0)	(5)
replicate∆03_TEST←'replicate∆Run'#.util.MK∆T2 (I 1)	(5)
replicate∆04_TEST←'replicate∆Run'#.util.MK∆T2 (I 1 1)	(5 5)
replicate∆05_TEST←'replicate∆Run'#.util.MK∆T2 (I 0 0)	(5 5)
replicate∆06_TEST←'replicate∆Run'#.util.MK∆T2 (I 1 0)	(5 5)
replicate∆07_TEST←'replicate∆Run'#.util.MK∆T2 (I 0 1)	(5 5)
replicate∆08_TEST←'replicate∆Run'#.util.MK∆T2 (I 0 1 0 1 0)	(⍳5)
replicate∆09_TEST←'replicate∆Run'#.util.MK∆T2 (I 0 1 0 2 0 3 1)	(⍳7)
replicate∆10_TEST←'replicate∆Run'#.util.MK∆T2 (I 0 1 0 ¯2 0 3 1)	(⍳7)
replicate∆11_TEST←'replicate∆Run'#.util.MK∆T2 (I 0 1 0 ¯2 0 3 1)	(7)
replicate∆12_TEST←'replicate∆Run'#.util.MK∆T2 (I 0)	(⍳3)
replicate∆13_TEST←'replicate∆Run'#.util.MK∆T2 (I 1)	(⍳3)
replicate∆14_TEST←'replicate∆Run'#.util.MK∆T2 (I 3)	(⍳3)
replicate∆15_TEST←'replicate∆Run'#.util.MK∆T2 (I 0 1 0 ¯2 0 3 1)	(5 7⍴⍳35)
replicate∆16_TEST←'replicate∆Run'#.util.MK∆T2 (0 1 0 1 1 1 0)	(5 7⍴⍳35)
replicate∆17_TEST←'replicate∆Run'#.util.MK∆T2 (0 1 0 1 1 1 0)	(5)
replicate∆18_TEST←'replicate∆Run'#.util.MK∆T2 (32⍴0 1 0 1 1 1 0)	(⍳32)
replicate∆19_TEST←'replicate∆Run'#.util.MK∆T2 (14⍴0 1 0 1 1 1 0)	(⍳14)


:EndNamespace
