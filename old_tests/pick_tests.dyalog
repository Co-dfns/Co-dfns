:Namespace pick_tests

F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

pick∆01_TEST←'pick∆Run'#.util.MK∆T2 ⍬⍬
pick∆02_TEST←'pick∆Run'#.util.MK∆T2 ⍬0
pick∆03_TEST←'pick∆Run'#.util.MK∆T2 ⍬(1 2)
pick∆04_TEST←'pick∆Run'#.util.MK∆T2 ⍬(2 2⍴1 2 3 4)
pick∆05_TEST←'pick∆Run'#.util.MK∆T2 ⍬(2 3 4⍴99)
pick∆06_TEST←'pick∆Run'#.util.MK∆T2 0(⍳5)
pick∆07_TEST←'pick∆Run'#.util.MK∆T2 3(2 4 6 8)
pick∆08_TEST←'pick∆Run'#.util.MK∆T2 ⍬(F ⍬)
pick∆09_TEST←'pick∆Run'#.util.MK∆T2 ⍬(F 0)
pick∆10_TEST←'pick∆Run'#.util.MK∆T2 ⍬(F 1 2)
pick∆11_TEST←'pick∆Run'#.util.MK∆T2 ⍬(F 2 2⍴1 2 3 4)
pick∆12_TEST←'pick∆Run'#.util.MK∆T2 ⍬(F 2 3 4⍴99)
pick∆13_TEST←'pick∆Run'#.util.MK∆T2 0(F ⍳5)
pick∆14_TEST←'pick∆Run'#.util.MK∆T2 3(F 2 4 6 8)

:EndNamespace
