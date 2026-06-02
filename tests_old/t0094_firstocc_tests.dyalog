:Require file://t0094.dyalog
:Namespace t0094_tests

 tn←'t0094' ⋄ cn←'c0094'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0094←tn #.codfns.Fix ⎕SRC dy}

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

∆firstocc∆1_TEST←'firstocc' MK∆T1 ⍬
∆firstocc∆2_TEST←'firstocc' MK∆T1 (?50⍴10)
∆firstocc∆3_TEST←'firstocc' MK∆T1 (?5 5⍴10)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
