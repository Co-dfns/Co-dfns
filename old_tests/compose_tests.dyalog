:Namespace compose_tests

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
B←?100⍴2

compose∆01_TEST←'compose∆Rm'#.util.MK∆T1 I
compose∆02_TEST←'compose∆Rd'#.util.MK∆T2 I I
compose∆03_TEST←'compose∆Rl'#.util.MK∆T1 I
compose∆04_TEST←'compose∆Rr'#.util.MK∆T1 I

:EndNamespace

