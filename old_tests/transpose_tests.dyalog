:Namespace transpose_tests

transpose∆01_TEST←'transpose∆R1'#.util.MK∆T1 (5 5⍴⍳25)
transpose∆02_TEST←'transpose∆R1'#.util.MK∆T1 (⍬)
transpose∆03_TEST←'transpose∆R1'#.util.MK∆T1 (5)
transpose∆04_TEST←'transpose∆R1'#.util.MK∆T1 (⍳5)
transpose∆05_TEST←'transpose∆R1'#.util.MK∆T1 (2 3 4 1⍴⍳24)
transpose∆06_TEST←'transpose∆R1'#.util.MK∆T1 (÷5 5⍴1+⍳25)
transpose∆07_TEST←'transpose∆R1'#.util.MK∆T1 (÷2 3 4 1⍴1+⍳24)
transpose∆08_TEST←'transpose∆R1'#.util.MK∆T1 (5 5⍴0 1 1)
transpose∆09_TEST←'transpose∆R1'#.util.MK∆T1 (2 3 4 1⍴0 1 1)
transpose∆10_TEST←'transpose∆R2'#.util.MK∆T2 (1 0)(5 5⍴⍳25)
transpose∆11_TEST←'transpose∆R2'#.util.MK∆T2 (0)(⍬)
transpose∆12_TEST←'transpose∆R2'#.util.MK∆T2 (⍬)(5)
transpose∆13_TEST←'transpose∆R2'#.util.MK∆T2 (0)(⍳5)
transpose∆14_TEST←'transpose∆R2'#.util.MK∆T2 (3 2 0 1)(2 3 4 1⍴⍳24)
transpose∆15_TEST←'transpose∆R2'#.util.MK∆T2 (0 1)(÷5 7⍴1+⍳25)
transpose∆16_TEST←'transpose∆R2'#.util.MK∆T2 (2 3 1 0)(÷2 3 4 1⍴1+⍳24)
transpose∆17_TEST←'transpose∆R2'#.util.MK∆T2 (1 0)(7 5⍴0 1 1)
transpose∆18_TEST←'transpose∆R2'#.util.MK∆T2 (0 1 2 3)(2 3 4 1⍴0 1 1)

:EndNamespace
