:Namespace split_tests

I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

split∆01_TEST←'split∆Run'#.util.MK∆T1 (I32 7)
split∆02_TEST←'split∆Run'#.util.MK∆T1 (I16 7)
split∆03_TEST←'split∆Run'#.util.MK∆T1 (I8 7)
split∆04_TEST←'split∆Run'#.util.MK∆T1 (7.5)


:EndNamespace

