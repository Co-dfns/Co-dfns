:Namespace gradedown_tests

F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

gradedown∆01_TEST←'gradedown∆Run'#.util.MK∆T1 (⍬)
gradedown∆02_TEST←'gradedown∆Run'#.util.MK∆T1 (,1)
gradedown∆03_TEST←'gradedown∆Run'#.util.MK∆T1 (⍳3)
gradedown∆04_TEST←'gradedown∆Run'#.util.MK∆T1 (⌽⍳3)
gradedown∆05_TEST←'gradedown∆Run'#.util.MK∆T1 (?25⍴20)
gradedown∆06_TEST←'gradedown∆Run'#.util.MK∆T1 (?100⍴50)
gradedown∆07_TEST←'gradedown∆Run'#.util.MK∆T1 (10⍴50)
gradedown∆08_TEST←'gradedown∆Run'#.util.MK∆T1 (F ⍬)
gradedown∆09_TEST←'gradedown∆Run'#.util.MK∆T1 (F ,1)
gradedown∆10_TEST←'gradedown∆Run'#.util.MK∆T1 (F ⍳3)
gradedown∆11_TEST←'gradedown∆Run'#.util.MK∆T1 (F ⌽⍳3)
gradedown∆12_TEST←'gradedown∆Run'#.util.MK∆T1 (F ?25⍴20)
gradedown∆13_TEST←'gradedown∆Run'#.util.MK∆T1 (F ?100⍴50)
gradedown∆14_TEST←'gradedown∆Run'#.util.MK∆T1 (F 10⍴50)
gradedown∆15_TEST←'gradedown∆Run'#.util.MK∆T1 (?10 10⍴50)
gradedown∆16_TEST←'gradedown∆Run'#.util.MK∆T1 (?10 10 15⍴50)
gradedown∆17_TEST←'gradedown∆Run'#.util.MK∆T1 (F ?10 10⍴50)
gradedown∆18_TEST←'gradedown∆Run'#.util.MK∆T1 (F ?10 10 15⍴50)

:EndNamespace
