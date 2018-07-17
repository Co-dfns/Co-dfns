:Namespace catenate_tests

catenate∆01_TEST←'catenate∆Run'#.util.MK∆T2 (⍬)         (⍬)
catenate∆02_TEST←'catenate∆Run'#.util.MK∆T2 (5)	        (5)
catenate∆03_TEST←'catenate∆Run'#.util.MK∆T2 (⍬)	        (5)
catenate∆04_TEST←'catenate∆Run'#.util.MK∆T2 (⍬)         (⍳5)
catenate∆05_TEST←'catenate∆Run'#.util.MK∆T2 (⍳7)        (⍳5)
catenate∆06_TEST←'catenate∆Run'#.util.MK∆T2 (5)         (⍳5)
catenate∆07_TEST←'catenate∆Run'#.util.MK∆T2 (2 2⍴5)     (2 2⍴5)
catenate∆08_TEST←'catenate∆Run'#.util.MK∆T2 (2 2 3⍴5)   (2 2⍴5)
catenate∆09_TEST←'catenate∆Run'#.util.MK∆T2 (2 2⍴5)     (2 2 3⍴5)
catenate∆10_TEST←'catenate∆Run'#.util.MK∆T2 (2 2⍴5)     (2 2 3⍴5)
catenate∆11_TEST←'catenate∆Run'#.util.MK∆T2 (5)         (2 2⍴5)
catenate∆12_TEST←'catenate∆Run'#.util.MK∆T2 (,5 5)      (2 2⍴5)
catenate∆13_TEST←'catenate∆Run'#.util.MK∆T2 (,5)        (,5)
catenate∆14_TEST←'catenate∆Run'#.util.MK∆T2 (,1 0)      (2 2⍴1 0 0)
catenate∆15_TEST←'catenate∆Run'#.util.MK∆T2 (,5 4)      (2 2⍴1 0 0)
catenate∆16_TEST←'catenate∆Run'#.util.MK∆T2 (2 2⍴1 0 0) (,5 4)

:EndNamespace
