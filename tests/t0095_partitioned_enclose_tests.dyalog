:Require file://t0095.dyalog
:Namespace t0095_tests

 tn←'t0095' ⋄ cn←'c0095'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0095←tn #.codfns.Fix ⎕SRC dy}

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

∆partenc∆00_TEST←'partenc' MK∆T2 (⍬)(⍬)
∆partenc∆01_TEST←'partenc' MK∆T2 (0)(5)
∆partenc∆02_TEST←'partenc' MK∆T2 (1)(5)
∆partenc∆03_TEST←'partenc' MK∆T2 (2)(5)
∆partenc∆04_TEST←'partenc' MK∆T2 (1 0)(5)
∆partenc∆05_TEST←'partenc' MK∆T2 (1 1)(5)
∆partenc∆06_TEST←'partenc' MK∆T2 (1 2)(5)
∆partenc∆07_TEST←'partenc' MK∆T2 (2 0)(5)
∆partenc∆08_TEST←'partenc' MK∆T2 (2 1)(5)
∆partenc∆09_TEST←'partenc' MK∆T2 (2 2)(5)
∆partenc∆10_TEST←'partenc' MK∆T2 (3 0)(5)
∆partenc∆11_TEST←'partenc' MK∆T2 (3 1)(5)
∆partenc∆12_TEST←'partenc' MK∆T2 (3 2)(5)
∆partenc∆13_TEST←'partenc' MK∆T2 (0)(,5)
∆partenc∆14_TEST←'partenc' MK∆T2 (1)(,5)
∆partenc∆15_TEST←'partenc' MK∆T2 (2)(,5)
∆partenc∆16_TEST←'partenc' MK∆T2 (1 0)(,5)
∆partenc∆17_TEST←'partenc' MK∆T2 (1 1)(,5)
∆partenc∆18_TEST←'partenc' MK∆T2 (1 2)(,5)
∆partenc∆19_TEST←'partenc' MK∆T2 (2 0)(,5)
∆partenc∆20_TEST←'partenc' MK∆T2 (2 1)(,5)
∆partenc∆21_TEST←'partenc' MK∆T2 (2 2)(,5)
∆partenc∆22_TEST←'partenc' MK∆T2 (3 0)(,5)
∆partenc∆23_TEST←'partenc' MK∆T2 (3 1)(,5)
∆partenc∆24_TEST←'partenc' MK∆T2 (3 2)(,5)
∆partenc∆25_TEST←'partenc' MK∆T2 (5⍴0)(⍳5)
∆partenc∆26_TEST←'partenc' MK∆T2 (5⍴1)(⍳5)
∆partenc∆27_TEST←'partenc' MK∆T2 (1)(⍳5)
∆partenc∆28_TEST←'partenc' MK∆T2 (0)(⍳5)
∆partenc∆29_TEST←'partenc' MK∆T2 (5⍴2)(⍳5)
∆partenc∆30_TEST←'partenc' MK∆T2 (5⍴0 1 2)(⍳5)
∆partenc∆31_TEST←'partenc' MK∆T2 (5⍴2 1 0)(⍳5)
∆partenc∆32_TEST←'partenc' MK∆T2 (1)(5 5⍴⍳50)
∆partenc∆33_TEST←'partenc' MK∆T2 (0)(5 5⍴⍳50)
∆partenc∆34_TEST←'partenc' MK∆T2 (5⍴0)(5 5⍴⍳50)
∆partenc∆35_TEST←'partenc' MK∆T2 (5⍴2)(5 5⍴⍳50)
∆partenc∆36_TEST←'partenc' MK∆T2 (5⍴1)(5 5⍴⍳50)
∆partenc∆37_TEST←'partenc' MK∆T2 (5⍴0 1 2)(5 5⍴⍳50)
∆partenc∆38_TEST←'partenc' MK∆T2 (5⍴2 1 0)(5 5⍴⍳50)
∆partenc∆39_TEST←'partenc' MK∆T2 (6⍴0)(5 5⍴⍳50)
∆partenc∆40_TEST←'partenc' MK∆T2 (6⍴2)(5 5⍴⍳50)
∆partenc∆41_TEST←'partenc' MK∆T2 (6⍴1)(5 5⍴⍳50)
∆partenc∆42_TEST←'partenc' MK∆T2 (6⍴0 1 2)(5 5⍴⍳50)
∆partenc∆43_TEST←'partenc' MK∆T2 (6⍴2 1 0)(5 5⍴⍳50)
∆partenc∆44_TEST←'partenc_ax' MK∆T2 1((1)(5 5⍴⍳50))
∆partenc∆45_TEST←'partenc_ax' MK∆T2 1((0)(5 5⍴⍳50))
∆partenc∆46_TEST←'partenc_ax' MK∆T2 1((5⍴0)(5 5⍴⍳50))
∆partenc∆47_TEST←'partenc_ax' MK∆T2 1((5⍴1)(5 5⍴⍳50))
∆partenc∆48_TEST←'partenc_ax' MK∆T2 1((5⍴2)(5 5⍴⍳50))
∆partenc∆49_TEST←'partenc_ax' MK∆T2 1((5⍴0 1 2)(5 5⍴⍳50))
∆partenc∆50_TEST←'partenc_ax' MK∆T2 1((5⍴2 1 0)(5 5⍴⍳50))
∆partenc∆51_TEST←'partenc_ax' MK∆T2 1((6⍴0)(5 5⍴⍳50))
∆partenc∆52_TEST←'partenc_ax' MK∆T2 1((6⍴1)(5 5⍴⍳50))
∆partenc∆53_TEST←'partenc_ax' MK∆T2 1((6⍴2)(5 5⍴⍳50))
∆partenc∆54_TEST←'partenc_ax' MK∆T2 1((6⍴0 1 2)(5 5⍴⍳50))
∆partenc∆55_TEST←'partenc_ax' MK∆T2 1((6⍴2 1 0)(5 5⍴⍳50))
∆partenc∆56_TEST←'partenc' MK∆T2 (2⍴2 1 0)(5 5⍴⍳50)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
