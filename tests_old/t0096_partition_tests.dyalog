:Require file://t0096.dyalog
:Namespace t0096_tests

 tn←'t0096' ⋄ cn←'c0096'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0096←tn #.codfns.Fix ⎕SRC dy}

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

∆partition∆00_TEST←'partition' MK∆T2 (⍬)(⍬)
∆partition∆01_TEST←'partition' MK∆T2 (0)(,5)
∆partition∆02_TEST←'partition' MK∆T2 (1)(,5)
∆partition∆03_TEST←'partition' MK∆T2 (2)(,5)
∆partition∆04_TEST←'partition' MK∆T2 (1 0)(⍳2)
∆partition∆05_TEST←'partition' MK∆T2 (1 1)(⍳2)
∆partition∆06_TEST←'partition' MK∆T2 (1 2)(⍳2)
∆partition∆07_TEST←'partition' MK∆T2 (2 0)(⍳2)
∆partition∆08_TEST←'partition' MK∆T2 (2 1)(⍳2)
∆partition∆09_TEST←'partition' MK∆T2 (2 2)(⍳2)
∆partition∆10_TEST←'partition' MK∆T2 (3 0)(⍳2)
∆partition∆11_TEST←'partition' MK∆T2 (3 1)(⍳2)
∆partition∆12_TEST←'partition' MK∆T2 (2 3)(⍳2)
∆partition∆13_TEST←'partition' MK∆T2 (5⍴0)(⍳5)
∆partition∆14_TEST←'partition' MK∆T2 (5⍴1)(⍳5)
∆partition∆15_TEST←'partition' MK∆T2 (1)(⍳5)
∆partition∆16_TEST←'partition' MK∆T2 (0)(⍳5)
∆partition∆17_TEST←'partition' MK∆T2 (5⍴2)(⍳5)
∆partition∆18_TEST←'partition' MK∆T2 (5⍴0 1 2)(⍳5)
∆partition∆19_TEST←'partition' MK∆T2 (5⍴2 1 0)(⍳5)
∆partition∆20_TEST←'partition' MK∆T2 (5⍴2 2 0)(⍳5)
∆partition∆21_TEST←'partition' MK∆T2 (5⍴0 2 2)(⍳5)
∆partition∆22_TEST←'partition' MK∆T2 (5⍴0)(5 5⍴⍳50)
∆partition∆23_TEST←'partition' MK∆T2 (5⍴1)(5 5⍴⍳50)
∆partition∆24_TEST←'partition' MK∆T2 (1)(5 5⍴⍳50)
∆partition∆25_TEST←'partition' MK∆T2 (0)(5 5⍴⍳50)
∆partition∆26_TEST←'partition' MK∆T2 (5⍴2)(5 5⍴⍳50)
∆partition∆27_TEST←'partition' MK∆T2 (5⍴0 1 2)(5 5⍴⍳50)
∆partition∆28_TEST←'partition' MK∆T2 (5⍴2 1 0)(5 5⍴⍳50)
∆partition∆29_TEST←'partition' MK∆T2 (5⍴2 2 0)(5 5⍴⍳50)
∆partition∆30_TEST←'partition' MK∆T2 (5⍴0 2 2)(5 5⍴⍳50)
∆partition∆31_TEST←'partition_ax' MK∆T2 1((5⍴0)(5 5⍴⍳50))
∆partition∆32_TEST←'partition_ax' MK∆T2 1((5⍴1)(5 5⍴⍳50))
∆partition∆33_TEST←'partition_ax' MK∆T2 1((1)(5 5⍴⍳50))
∆partition∆34_TEST←'partition_ax' MK∆T2 1((0)(5 5⍴⍳50))
∆partition∆35_TEST←'partition_ax' MK∆T2 1((5⍴2)(5 5⍴⍳50))
∆partition∆36_TEST←'partition_ax' MK∆T2 1((5⍴0 1 2)(5 5⍴⍳50))
∆partition∆37_TEST←'partition_ax' MK∆T2 1((5⍴2 1 0)(5 5⍴⍳50))
∆partition∆38_TEST←'partition_ax' MK∆T2 1((5⍴2 2 0)(5 5⍴⍳50))
∆partition∆39_TEST←'partition_ax' MK∆T2 1((5⍴0 2 2)(5 5⍴⍳50))

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
