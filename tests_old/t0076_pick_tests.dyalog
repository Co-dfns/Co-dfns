:Require file://t0076.dyalog
:Namespace t0076_tests

 tn←'t0076' ⋄ cn←'c0076'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0076←tn #.codfns.Fix ⎕SRC dy}

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

∆pick∆01_TEST←'pick' MK∆T2 ⍬⍬
∆pick∆02_TEST←'pick' MK∆T2 ⍬0
∆pick∆03_TEST←'pick' MK∆T2 ⍬(1 2)
∆pick∆04_TEST←'pick' MK∆T2 ⍬(2 2⍴1 2 3 4)
∆pick∆05_TEST←'pick' MK∆T2 ⍬(2 3 4⍴99)
∆pick∆06_TEST←'pick' MK∆T2 0(⍳5)
∆pick∆07_TEST←'pick' MK∆T2 3(2 4 6 8)
∆pick∆08_TEST←'pick' MK∆T2 ⍬(F ⍬)
∆pick∆09_TEST←'pick' MK∆T2 ⍬(F 0)
∆pick∆10_TEST←'pick' MK∆T2 ⍬(F 1 2)
∆pick∆11_TEST←'pick' MK∆T2 ⍬(F 2 2⍴1 2 3 4)
∆pick∆12_TEST←'pick' MK∆T2 ⍬(F 2 3 4⍴99)
∆pick∆13_TEST←'pick' MK∆T2 0(F ⍳5)
∆pick∆14_TEST←'pick' MK∆T2 3(F 2 4 6 8)
∆pick∆15_TEST←'pick' MK∆T2 (⊂1 0)(3 3⍴⍳9)
∆pick∆16_TEST←'pick' MK∆T2 (1 0)((1 2 3)(4 5 6))
∆pick∆17_TEST←'pick' MK∆T2 ((1 0)(2 3))(3 3⍴⊂4 4⍴⍳16)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
