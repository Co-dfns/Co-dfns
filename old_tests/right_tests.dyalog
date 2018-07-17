:Namespace right_tests

I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

right∆01_TEST←'right∆Run'#.util.MK∆T2 (⍬)(0)
right∆02_TEST←'right∆Run'#.util.MK∆T2 (0)(⍬)
right∆03_TEST←'right∆Run'#.util.MK∆T2 (I32 ⍳5)(⍬)
right∆04_TEST←'right∆Run'#.util.MK∆T2 (I16 ⍳5)(⍬)
right∆05_TEST←'right∆Run'#.util.MK∆T2 (I8 ⍳5)(⍬)
right∆06_TEST←'right∆Run'#.util.MK∆T2 (I32 2 3 4⍴⍳5)(⍬)
right∆07_TEST←'right∆Run'#.util.MK∆T2 (I16 2 3 4⍴⍳5)(⍬)
right∆08_TEST←'right∆Run'#.util.MK∆T2 (I8 2 3 4⍴⍳5)(⍬)
right∆09_TEST←'right∆Run'#.util.MK∆T2 (2 3 4⍴0 1 1)(⍬)
right∆10_TEST←'right∆Run'#.util.MK∆T2 (4⍴0 1 1)(⍬)
right∆11_TEST←'right∆Run'#.util.MK∆T2 (24⍴0 1 1)(⍬)
right∆12_TEST←'right∆Run'#.util.MK∆T2 (⍬)(I32 ⍳5)
right∆14_TEST←'right∆Run'#.util.MK∆T2 (⍬)(I16 ⍳5)
right∆15_TEST←'right∆Run'#.util.MK∆T2 (⍬)(I8 ⍳5)
right∆16_TEST←'right∆Run'#.util.MK∆T2 (⍬)(I32 2 3 4⍴⍳5)
right∆17_TEST←'right∆Run'#.util.MK∆T2 (⍬)(I16 2 3 4⍴⍳5)
right∆18_TEST←'right∆Run'#.util.MK∆T2 (⍬)(I8 2 3 4⍴⍳5)
right∆19_TEST←'right∆Run'#.util.MK∆T2 (⍬)(2 3 4⍴0 1 1)
right∆20_TEST←'right∆Run'#.util.MK∆T2 (⍬)(4⍴0 1 1)
right∆21_TEST←'right∆Run'#.util.MK∆T2 (⍬)(24⍴0 1 1)

:EndNamespace

