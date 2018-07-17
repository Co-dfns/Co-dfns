:Namespace gradeup_tests

F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

gradeup∆01_TEST←'gradeup∆Run'#.util.MK∆T1 (⍬)
gradeup∆02_TEST←'gradeup∆Run'#.util.MK∆T1 (,1)
gradeup∆03_TEST←'gradeup∆Run'#.util.MK∆T1 (⍳3)
gradeup∆04_TEST←'gradeup∆Run'#.util.MK∆T1 (⌽⍳3)
gradeup∆05_TEST←'gradeup∆Run'#.util.MK∆T1 (?25⍴20)
gradeup∆06_TEST←'gradeup∆Run'#.util.MK∆T1 (?100⍴50)
gradeup∆07_TEST←'gradeup∆Run'#.util.MK∆T1 (10⍴50)
gradeup∆08_TEST←'gradeup∆Run'#.util.MK∆T1 (F ⍬)
gradeup∆09_TEST←'gradeup∆Run'#.util.MK∆T1 (F ,1)
gradeup∆10_TEST←'gradeup∆Run'#.util.MK∆T1 (F ⍳3)
gradeup∆11_TEST←'gradeup∆Run'#.util.MK∆T1 (F ⌽⍳3)
gradeup∆12_TEST←'gradeup∆Run'#.util.MK∆T1 (F ?25⍴20)
gradeup∆13_TEST←'gradeup∆Run'#.util.MK∆T1 (F ?100⍴50)
gradeup∆14_TEST←'gradeup∆Run'#.util.MK∆T1 (F 10⍴50)
gradeup∆15_TEST←'gradeup∆Run'#.util.MK∆T1 (?10 10⍴50)
gradeup∆16_TEST←'gradeup∆Run'#.util.MK∆T1 (?10 10 15⍴50)
gradeup∆17_TEST←'gradeup∆Run'#.util.MK∆T1 (F ?10 10⍴50)
gradeup∆18_TEST←'gradeup∆Run'#.util.MK∆T1 (F ?10 10 15⍴50)

:EndNamespace
