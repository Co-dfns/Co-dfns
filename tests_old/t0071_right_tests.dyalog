:Require file://t0071.dyalog
:Namespace t0071_tests

 tn←'t0071' ⋄ cn←'c0071'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0071←tn #.codfns.Fix ⎕SRC dy}

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

∆right∆01_TEST←'right' MK∆T2 (⍬)(0)
∆right∆02_TEST←'right' MK∆T2 (0)(⍬)
∆right∆03_TEST←'right' MK∆T2 (I32 ⍳5)(⍬)
∆right∆04_TEST←'right' MK∆T2 (I16 ⍳5)(⍬)
∆right∆05_TEST←'right' MK∆T2 (I8 ⍳5)(⍬)
∆right∆06_TEST←'right' MK∆T2 (I32 2 3 4⍴⍳5)(⍬)
∆right∆07_TEST←'right' MK∆T2 (I16 2 3 4⍴⍳5)(⍬)
∆right∆08_TEST←'right' MK∆T2 (I8 2 3 4⍴⍳5)(⍬)
∆right∆09_TEST←'right' MK∆T2 (2 3 4⍴0 1 1)(⍬)
∆right∆10_TEST←'right' MK∆T2 (4⍴0 1 1)(⍬)
∆right∆11_TEST←'right' MK∆T2 (24⍴0 1 1)(⍬)
∆right∆12_TEST←'right' MK∆T2 (⍬)(I32 ⍳5)
∆right∆14_TEST←'right' MK∆T2 (⍬)(I16 ⍳5)
∆right∆15_TEST←'right' MK∆T2 (⍬)(I8 ⍳5)
∆right∆16_TEST←'right' MK∆T2 (⍬)(I32 2 3 4⍴⍳5)
∆right∆17_TEST←'right' MK∆T2 (⍬)(I16 2 3 4⍴⍳5)
∆right∆18_TEST←'right' MK∆T2 (⍬)(I8 2 3 4⍴⍳5)
∆right∆19_TEST←'right' MK∆T2 (⍬)(2 3 4⍴0 1 1)
∆right∆20_TEST←'right' MK∆T2 (⍬)(4⍴0 1 1)
∆right∆21_TEST←'right' MK∆T2 (⍬)(24⍴0 1 1)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
