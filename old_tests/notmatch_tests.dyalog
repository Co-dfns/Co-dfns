:Namespace notmatch_tests

notmatch∆01_TEST←'notmatch∆Run'#.util.MK∆T2 (⍬)(⍬)
notmatch∆02_TEST←'notmatch∆Run'#.util.MK∆T2 (0)(0)
notmatch∆03_TEST←'notmatch∆Run'#.util.MK∆T2 (⍬)(0)
notmatch∆04_TEST←'notmatch∆Run'#.util.MK∆T2 (⍬)(⍳5)
notmatch∆05_TEST←'notmatch∆Run'#.util.MK∆T2 (⍳7)(⍳5)
notmatch∆06_TEST←'notmatch∆Run'#.util.MK∆T2 (0)(⍳5)
notmatch∆07_TEST←'notmatch∆Run'#.util.MK∆T2 (2 2⍴⍳4)(2 2⍴⍳4)
notmatch∆08_TEST←'notmatch∆Run'#.util.MK∆T2 (2 2 3⍴⍳12)(2 2⍴⍳4)
notmatch∆09_TEST←'notmatch∆Run'#.util.MK∆T2 (2 2⍴⍳4)(2 2 3⍴⍳12)
notmatch∆10_TEST←'notmatch∆Run'#.util.MK∆T2 (2 2 3⍴⍳12)(2 2 3⍴1+⍳12)
notmatch∆11_TEST←'notmatch∆Run'#.util.MK∆T2 (0)(2 2⍴⍳4)
notmatch∆12_TEST←'notmatch∆Run'#.util.MK∆T2 (,0)(2 2⍴⍳4)
notmatch∆13_TEST←'notmatch∆Run'#.util.MK∆T2 (,0)(,0)

:EndNamespace

