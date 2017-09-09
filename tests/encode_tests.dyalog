:Namespace encode_tests

encode∆01_TEST←'encode∆Run'#.util.MK∆T2 ⍬           ⍬
encode∆02_TEST←'encode∆Run'#.util.MK∆T2 ⍬           (⍳5)
encode∆03_TEST←'encode∆Run'#.util.MK∆T2 (⍳5)        ⍬
encode∆04_TEST←'encode∆Run'#.util.MK∆T2 (5 2⍴⍳5)    (3 0⍴⍬)
encode∆05_TEST←'encode∆Run'#.util.MK∆T2 (0 2⍴⍬)     (3 5⍴⍬)
encode∆06_TEST←'encode∆Run'#.util.MK∆T2 0           (3 5⍴⍳15)
encode∆07_TEST←'encode∆Run'#.util.MK∆T2 (,0)        (3 5⍴⍳15)
encode∆08_TEST←'encode∆Run'#.util.MK∆T2 5           (⍳30)
encode∆09_TEST←'encode∆Run'#.util.MK∆T2 (,5)        (⍳30)
encode∆10_TEST←'encode∆Run'#.util.MK∆T2 (5⍴0)       (⍳30)
encode∆11_TEST←'encode∆Run'#.util.MK∆T2 (5⍴5)       (⍳30)
encode∆12_TEST←'encode∆Run'#.util.MK∆T2 (5⍴2)       (⍳30)
encode∆13_TEST←'encode∆Run'#.util.MK∆T2 (2 3 4)     (⍳30)
encode∆14_TEST←'encode∆Run'#.util.MK∆T2 (0 3 4)     (⍳100)
encode∆15_TEST←'encode∆Run'#.util.MK∆T2 (3 0 4)     (⍳100)
encode∆16_TEST←'encode∆Run'#.util.MK∆T2 (3 4 0)     (⍳100)
encode∆17_TEST←'encode∆Run'#.util.MK∆T2 (3 3⍴2)     (⍳10)
encode∆18_TEST←'encode∆Run'#.util.MK∆T2 (3 3⍴2 3 4) (⍳30)
encode∆19_TEST←'encode∆Run'#.util.MK∆T2 (32⍴2)      (3 3 3⍴⍳81)
encode∆20_TEST←'encode∆Ovr'#.util.MK∆T2 (32⍴2)      (3 3 3 3⍴⍳81)

:EndNamespace
