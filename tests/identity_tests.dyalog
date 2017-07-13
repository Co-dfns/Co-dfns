:Namespace identity_tests

I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

identity∆01_TEST←'identity∆Run'#.util.MK∆T1 (⍬)
identity∆02_TEST←'identity∆Run'#.util.MK∆T1 (0)
identity∆03_TEST←'identity∆Run'#.util.MK∆T1 (I32 ⍳5)
identity∆04_TEST←'identity∆Run'#.util.MK∆T1 (I16 ⍳5)
identity∆05_TEST←'identity∆Run'#.util.MK∆T1 (I8 ⍳5)
identity∆06_TEST←'identity∆Run'#.util.MK∆T1 (I32 2 3 4⍴⍳5)
identity∆07_TEST←'identity∆Run'#.util.MK∆T1 (I16 2 3 4⍴⍳5)
identity∆08_TEST←'identity∆Run'#.util.MK∆T1 (I8 2 3 4⍴⍳5)
identity∆09_TEST←'identity∆Run'#.util.MK∆T1 (2 3 4⍴0 1 1)
identity∆10_TEST←'identity∆Run'#.util.MK∆T1 (4⍴0 1 1)
identity∆11_TEST←'identity∆Run'#.util.MK∆T1 (24⍴0 1 1)

:EndNamespace

