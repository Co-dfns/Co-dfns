:Namespace unique_tests

F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

unique∆01_TEST←'unique∆Run'#.util.MK∆T1 (⍬)
unique∆02_TEST←'unique∆Run'#.util.MK∆T1 (1)
unique∆03_TEST←'unique∆Run'#.util.MK∆T1 (⍳5)
unique∆04_TEST←'unique∆Run'#.util.MK∆T1 (10⍴5)
unique∆05_TEST←'unique∆Run'#.util.MK∆T1 (25⍴⍳10)
unique∆06_TEST←'unique∆Run'#.util.MK∆T1 (?50⍴10)
unique∆07_TEST←'unique∆Run'#.util.MK∆T1 (F ⍬)
unique∆08_TEST←'unique∆Run'#.util.MK∆T1 (F 1)
unique∆09_TEST←'unique∆Run'#.util.MK∆T1 (F ⍳5)
unique∆10_TEST←'unique∆Run'#.util.MK∆T1 (F 10⍴5)
unique∆11_TEST←'unique∆Run'#.util.MK∆T1 (F 25⍴⍳10)
unique∆12_TEST←'unique∆Run'#.util.MK∆T1 (F ?50⍴10)
unique∆13_TEST←'unique∆Run'#.util.MK∆T1 (0 0 1 1 1)
unique∆14_TEST←'unique∆Run'#.util.MK∆T1 (1 1 0 0)
unique∆15_TEST←'unique∆Run'#.util.MK∆T1 (0 0 0 0)
unique∆16_TEST←'unique∆Run'#.util.MK∆T1 (1 1 1 1)
unique∆17_TEST←'unique∆Run'#.util.MK∆T1 (0 0 0 1 1 1 1 1)
unique∆18_TEST←'unique∆Run'#.util.MK∆T1 (1 0 0 0 0 1 1 1 1 1)

:EndNamespace

