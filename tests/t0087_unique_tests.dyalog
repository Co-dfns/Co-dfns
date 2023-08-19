:Require file://t0087.dyalog
:Namespace t0087_tests

 tn←'t0087' ⋄ cn←'c0087'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0087←tn #.codfns.Fix ⎕SRC dy}

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

∆unique∆01_TEST←'unique' MK∆T1 (⍬)
∆unique∆02_TEST←'unique' MK∆T1 (1)
∆unique∆03_TEST←'unique' MK∆T1 (⍳5)
∆unique∆04_TEST←'unique' MK∆T1 (10⍴5)
∆unique∆05_TEST←'unique' MK∆T1 (25⍴⍳10)
∆unique∆06_TEST←'unique' MK∆T1 (?50⍴10)
∆unique∆07_TEST←'unique' MK∆T1 (F ⍬)
∆unique∆08_TEST←'unique' MK∆T1 (F 1)
∆unique∆09_TEST←'unique' MK∆T1 (F ⍳5)
∆unique∆10_TEST←'unique' MK∆T1 (F 10⍴5)
∆unique∆11_TEST←'unique' MK∆T1 (F 25⍴⍳10)
∆unique∆12_TEST←'unique' MK∆T1 (F ?50⍴10)
∆unique∆13_TEST←'unique' MK∆T1 (0 0 1 1 1)
∆unique∆14_TEST←'unique' MK∆T1 (1 1 0 0)
∆unique∆15_TEST←'unique' MK∆T1 (0 0 0 0)
∆unique∆16_TEST←'unique' MK∆T1 (1 1 1 1)
∆unique∆17_TEST←'unique' MK∆T1 (0 0 0 1 1 1 1 1)
∆unique∆18_TEST←'unique' MK∆T1 (1 0 0 0 0 1 1 1 1 1)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
