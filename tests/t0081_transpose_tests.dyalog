:Require file://t0081.dyalog
:Namespace t0081_tests

 tn←'t0081' ⋄ cn←'c0081'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0081←tn #.codfns.Fix ⎕SRC dy}

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

MK∆T←{nv←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ cv←⊃(⍎'cd.',⍺⍺)/⍵⍵
 res←|1-(0.5⌈(⌈/1⊃⍵⍵)÷2)÷(+⌿÷≢)cv ⋄ _←{0.05≤⍵:⎕←⍵ ⋄ ⍬}res
 ##.UT.expect←(⍴nv)(1) ⋄ (⍴cv)(0.05>res)}

∆transpose∆01_TEST←'transpose∆R1' MK∆T1 (5 5⍴⍳25)
∆transpose∆02_TEST←'transpose∆R1' MK∆T1 (⍬)
∆transpose∆03_TEST←'transpose∆R1' MK∆T1 (5)
∆transpose∆04_TEST←'transpose∆R1' MK∆T1 (⍳5)
∆transpose∆05_TEST←'transpose∆R1' MK∆T1 (2 3 4 1⍴⍳24)
∆transpose∆06_TEST←'transpose∆R1' MK∆T1 (÷5 5⍴1+⍳25)
∆transpose∆07_TEST←'transpose∆R1' MK∆T1 (÷2 3 4 1⍴1+⍳24)
∆transpose∆08_TEST←'transpose∆R1' MK∆T1 (5 5⍴0 1 1)
∆transpose∆09_TEST←'transpose∆R1' MK∆T1 (2 3 4 1⍴0 1 1)
∆transpose∆10_TEST←'transpose∆R2' MK∆T2 (1 0)(5 5⍴⍳25)
∆transpose∆11_TEST←'transpose∆R2' MK∆T2 (0)(⍬)
∆transpose∆12_TEST←'transpose∆R2' MK∆T2 (⍬)(5)
∆transpose∆13_TEST←'transpose∆R2' MK∆T2 (0)(⍳5)
∆transpose∆14_TEST←'transpose∆R2' MK∆T2 (3 2 0 1)(2 3 4 1⍴⍳24)
∆transpose∆15_TEST←'transpose∆R2' MK∆T2 (0 1)(÷5 7⍴1+⍳25)
∆transpose∆16_TEST←'transpose∆R2' MK∆T2 (2 3 1 0)(÷2 3 4 1⍴1+⍳24)
∆transpose∆17_TEST←'transpose∆R2' MK∆T2 (1 0)(7 5⍴0 1 1)
∆transpose∆18_TEST←'transpose∆R2' MK∆T2 (0 1 2 3)(2 3 4 1⍴0 1 1)
∆transpose∆19_TEST←'transpose∆R2' MK∆T2 (0 0 1 1)(2 3 4 1⍴⍳24)
∆transpose∆20_TEST←'transpose∆R2' MK∆T2 (0 2 2 1)(2 3 4 2⍴⍳48)
∆transpose∆21_TEST←'transpose∆R2' MK∆T2 (2 1 0 2)(2 3 4 5⍴⍳120)
∆transpose∆22_TEST←'transpose∆R2' MK∆T2 (2 1 1 0)(2 3 4 5⍴⍳120)
∆transpose∆23_TEST←'transpose∆R2' MK∆T2 (0 0)(2 3⍴⍳6)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
