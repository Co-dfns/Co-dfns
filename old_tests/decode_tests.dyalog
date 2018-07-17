:Namespace decode_tests

decode∆01_TEST←'decode∆Run'#.util.MK∆T2 ⍬           ⍬
decode∆02_TEST←'decode∆Run'#.util.MK∆T2 (0 0⍴0)     ⍬
decode∆03_TEST←'decode∆Run'#.util.MK∆T2 ⍬           (0 0⍴1)
decode∆04_TEST←'decode∆Run'#.util.MK∆T2 (5 5⍴0)     (5 0⍴1)
decode∆05_TEST←'decode∆Run'#.util.MK∆T2 (5 0⍴0)     (0 5⍴1)
decode∆06_TEST←'decode∆Run'#.util.MK∆T2 (0 5⍴0)     (5 5⍴1)
decode∆07_TEST←'decode∆Run'#.util.MK∆T2 (8⍴2)       ((8⍴2)⊤⍳30)
decode∆08_TEST←'decode∆Run'#.util.MK∆T2 (5 4 3)     (5 4 3⊤5 6⍳30)
decode∆09_TEST←'decode∆Run'#.util.MK∆T2 (3 3⍴5 4 3) ((3 3⍴5 4 3)⊤5 6⍳30)
decode∆10_TEST←'decode∆Run'#.util.MK∆T2 (8⍴2)       (1 3⍴⍳10)
decode∆11_TEST←'decode∆Run'#.util.MK∆T2 2           ((8⍴2)⊤⍳30)
decode∆12_TEST←'decode∆Run'#.util.MK∆T2 (5 1⍴2)     ((8⍴2)⊤⍳30)
decode∆13_TEST←'decode∆Run'#.util.MK∆T2 (5 0 4)     (0⍪⍨0⍪⍨⍉⍪⍳5)

:EndNamespace
