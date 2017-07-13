:Namespace expandfirst_tests

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

expandfirst∆01_TEST←'expandfirst∆Run'#.util.MK∆T2 (⍬)                   (⍬)
expandfirst∆02_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 0)                 (5)
expandfirst∆03_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1)                 (5)
expandfirst∆04_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1 1)               (5 5)
expandfirst∆05_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 0 0 1 1)           (5 5)
expandfirst∆06_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1 0 1 0)           (5 5)
expandfirst∆07_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 0 0 1 1)           (5 5)
expandfirst∆08_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1 2 1 2 1)         (⍳5)
expandfirst∆09_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1 2 1 3 1 4 2)     (⍳7)
expandfirst∆10_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1 4 2 1 ¯2 1 3 1)  (⍳7)
expandfirst∆11_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1 1 1 ¯2 0 3 ¯1 2) (7)
expandfirst∆12_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 0 1 2 3)           (⍳3)
expandfirst∆13_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1 1 1)             (⍳3)
expandfirst∆14_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 3 2 1)             (⍳3)
expandfirst∆15_TEST←'expandfirst∆Run'#.util.MK∆T2 (I 1 4 2 1 ¯2 1 3 1)  (7 5⍴⍳35)
expandfirst∆16_TEST←'expandfirst∆Run'#.util.MK∆T2 (1 1 1 ¯2 1 1 3 0 2)  (7 5⍴⍳35)
expandfirst∆17_TEST←'expandfirst∆Run'#.util.MK∆T2 (0 1 0 1 1 1 0)       (5)

:EndNamespace
