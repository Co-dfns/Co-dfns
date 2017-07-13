:Namespace replicatefirst_tests

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

replicatefirst∆01_TEST←'replicatefirst∆Run'#.util.MK∆T2 (⍬)                (⍬)
replicatefirst∆02_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0)              (5)
replicatefirst∆03_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 1)              (5)
replicatefirst∆04_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 1 1)            (5 5)
replicatefirst∆05_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0 0)            (5 5)
replicatefirst∆06_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 1 0)            (5 5)
replicatefirst∆07_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0 1)            (5 5)
replicatefirst∆08_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0 1 0 1 0)      (⍳5)
replicatefirst∆09_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0 1 0 2 0 3 1)  (⍳7)
replicatefirst∆10_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0 1 0 ¯2 0 3 1) (⍳7)
replicatefirst∆11_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0 1 0 ¯2 0 3 1) (7)
replicatefirst∆12_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0)              (⍳3)
replicatefirst∆13_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 1)              (⍳3)
replicatefirst∆14_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 3)              (⍳3)
replicatefirst∆15_TEST←'replicatefirst∆Run'#.util.MK∆T2 (I 0 1 0 ¯2 0 3 1) (7 5⍴⍳35)
replicatefirst∆16_TEST←'replicatefirst∆Run'#.util.MK∆T2 (0 1 0 1 1 1 0)    (7 5⍴⍳35)
replicatefirst∆17_TEST←'replicatefirst∆Run'#.util.MK∆T2 (0 1 0 1 1 1 0)    (5)
replicatefirst∆18_TEST←'replicatefirst∆Run'#.util.MK∆T2 (32⍴0 1 0 1 1 1 0) (⍳32)
replicatefirst∆19_TEST←'replicatefirst∆Run'#.util.MK∆T2 (14⍴0 1 0 1 1 1 0) (⍳14)


:EndNamespace
