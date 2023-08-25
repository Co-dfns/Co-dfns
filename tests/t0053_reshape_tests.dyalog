:Require file://t0053.dyalog
:Namespace t0053_tests

 tn←'t0053' ⋄ cn←'c0053'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0053←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}
 MK∆T4←{fn tl←⍺⍺ ⋄ nv←(⍎'dy.',fn)⍵⍵ ⋄ cv←(⍎'cd.',fn)⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}

F←{⊃((⎕DR ⍵)645)⎕DR ⍵}
B←{⊃((⎕DR ⍵)11)⎕DR ⍵}
I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

∆reshape∆01_TEST←'reshape∆Rv' MK∆T2 (2 2)     (⍳4)
∆reshape∆02_TEST←'reshape∆Rv' MK∆T2 (2 2)     (1+⍳2)
∆reshape∆03_TEST←'reshape∆Rv' MK∆T2 (2 2)     (⍳6)
∆reshape∆04_TEST←'reshape∆Rv' MK∆T2 (⍬)       (⌽⍳6)
∆reshape∆05_TEST←'reshape∆Rv' MK∆T2 (2 2)     (⍬)
∆reshape∆06_TEST←'reshape∆Rl' MK∆T2 (2 2)     (⍳4)
∆reshape∆07_TEST←'reshape∆Rl' MK∆T2 (2 2)     (1+⍳2)
∆reshape∆08_TEST←'reshape∆Rl' MK∆T2 (2 2)     (⍳6)
∆reshape∆09_TEST←'reshape∆Rl' MK∆T2 (⍬)       (⌽⍳6)
∆reshape∆10_TEST←'reshape∆Rl' MK∆T2 (2 2)     (⍬)
∆reshape∆11_TEST←'reshape∆Rr' MK∆T2 (2 2)     (⍳4)
∆reshape∆12_TEST←'reshape∆Rr' MK∆T2 (2 2)     (1+⍳2)
∆reshape∆13_TEST←'reshape∆Rr' MK∆T2 (2 2)     (⍳6)
∆reshape∆14_TEST←'reshape∆Rr' MK∆T2 (⍬)       (⌽⍳6)
∆reshape∆15_TEST←'reshape∆Rr' MK∆T2 (2 2)     (⍬)
∆reshape∆16_TEST←'reshape∆Rv' MK∆T2 5         (⍳10)
∆reshape∆17_TEST←'reshape∆Rv' MK∆T2 (3 7)     (0 1)
∆reshape∆18_TEST←'reshape∆Rv' MK∆T2 3         (0 1 1 1 0 0 1 0 1)
∆reshape∆19_TEST←'reshape∆Rv' MK∆T2 0         14
∆reshape∆20_TEST←'reshape∆Rs' MK∆T2 (⍉⍪5)     (25 25⍴1 2 3)
∆reshape∆21_TEST←'reshape∆Rs' MK∆T2 (⍉⍪5 5)   (25 25⍴1 2 3)
∆reshape∆22_TEST←'reshape∆Rs' MK∆T2 (⍉⍪0)     (25 25⍴1 2 3)
∆reshape∆23_TEST←'reshape∆Rs' MK∆T2 (⍉⍪1 2 3) (25 25⍴1 2 3)
∆reshape∆24_TEST←'reshape∆Rs' MK∆T2 (⍉⍪5)     (5 5⍴⍳10)
∆reshape∆25_TEST←'reshape∆Rs' MK∆T2 (⍉⍪5 5)   (5 5⍴⍳30)
∆reshape∆26_TEST←'reshape∆Rs' MK∆T2 (⍉⍪0)     (5 5⍴5)
∆reshape∆27_TEST←'reshape∆Rs' MK∆T2 (⍉⍪1 2 3) (5 5⍴⍳10)
∆reshape∆28_TEST←'reshape∆Rv' MK∆T2 ⍬         (1 2 3)
∆reshape∆29_TEST←'reshape∆R0' MK∆T2 ⍬         ⍬
∆reshape∆30_TEST←'reshape∆Pr' MK∆T1 0 0 0
∆reshape∆31_TEST←'reshape∆Pr' MK∆T1 5 5 5
∆reshape∆32_TEST←'reshape∆Pr' MK∆T1 '   '
∆reshape∆33_TEST←'reshape∆Pr' MK∆T1 'abc'

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
