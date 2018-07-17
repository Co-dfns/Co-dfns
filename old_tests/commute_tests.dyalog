:Namespace commute_tests

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
B←?100⍴2

commute∆ii_TEST←'commute∆Run'#.util.MK∆T2 I I
commute∆ff_TEST←'commute∆Run'#.util.MK∆T2 F F
commute∆if_TEST←'commute∆Run'#.util.MK∆T2 I F
commute∆fi_TEST←'commute∆Run'#.util.MK∆T2 F I
commute∆bb_TEST←'commute∆Run'#.util.MK∆T2 B B
commute∆bi_TEST←'commute∆Run'#.util.MK∆T2 B I
commute∆bf_TEST←'commute∆Run'#.util.MK∆T2 B F
commute∆ib_TEST←'commute∆Run'#.util.MK∆T2 I B
commute∆fb_TEST←'commute∆Run'#.util.MK∆T2 F B
commute∆i_TEST←'commute∆Rm'#.util.MK∆T1 I
commute∆f_TEST←'commute∆Rm'#.util.MK∆T1 F
commute∆b_TEST←'commute∆Rm'#.util.MK∆T1 B

:EndNamespace

