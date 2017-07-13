:Namespace expand_tests

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

expand∆01_TEST←'expand∆Run'#.util.MK∆T2 (⍬)                   (⍬)
expand∆02_TEST←'expand∆Run'#.util.MK∆T2 (I 0)                 (5)
expand∆03_TEST←'expand∆Run'#.util.MK∆T2 (I 1)                 (5)
expand∆04_TEST←'expand∆Run'#.util.MK∆T2 (I 1 1)               (5 5)
expand∆05_TEST←'expand∆Run'#.util.MK∆T2 (I 0 0 1 1)           (5 5)
expand∆06_TEST←'expand∆Run'#.util.MK∆T2 (I 1 0 1 0)           (5 5)
expand∆07_TEST←'expand∆Run'#.util.MK∆T2 (I 0 0 1 1)           (5 5)
expand∆08_TEST←'expand∆Run'#.util.MK∆T2 (I 1 2 1 2 1)         (⍳5)
expand∆09_TEST←'expand∆Run'#.util.MK∆T2 (I 1 2 1 3 1 4 2)     (⍳7)
expand∆10_TEST←'expand∆Run'#.util.MK∆T2 (I 1 4 2 1 ¯2 1 3 1)  (⍳7)
expand∆11_TEST←'expand∆Run'#.util.MK∆T2 (I 1 1 1 ¯2 0 3 ¯1 2) (7)
expand∆12_TEST←'expand∆Run'#.util.MK∆T2 (I 0 1 2 3)           (⍳3)
expand∆13_TEST←'expand∆Run'#.util.MK∆T2 (I 1 1 1)             (⍳3)
expand∆14_TEST←'expand∆Run'#.util.MK∆T2 (I 3 2 1)             (⍳3)
expand∆15_TEST←'expand∆Run'#.util.MK∆T2 (I 1 4 2 1 ¯2 1 3 1)  (5 7⍴⍳35)
expand∆16_TEST←'expand∆Run'#.util.MK∆T2 (1 1 1 ¯2 1 1 3 0 2)  (5 7⍴⍳35)
expand∆17_TEST←'expand∆Run'#.util.MK∆T2 (0 1 0 1 1 1 0)       (5)

:EndNamespace
