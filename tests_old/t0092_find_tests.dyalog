:Require file://t0092.dyalog
:Namespace t0092_tests

 tn←'t0092' ⋄ cn←'c0092'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0092←tn #.codfns.Fix ⎕SRC dy}

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

∆find∆001_TEST←'find' MK∆T2 (⍬)(⍬)
∆find∆002_TEST←'find' MK∆T2 (⍬)(5)
∆find∆003_TEST←'find' MK∆T2 (⍬)(⍳5)
∆find∆004_TEST←'find' MK∆T2 (⍬)(2 2⍴⍳4)
∆find∆005_TEST←'find' MK∆T2 (⍬)(3 3 3⍴⍳9)
∆find∆006_TEST←'find' MK∆T2 (1)(⍬)
∆find∆007_TEST←'find' MK∆T2 (2)(5)
∆find∆008_TEST←'find' MK∆T2 (3)(⍳5)
∆find∆009_TEST←'find' MK∆T2 (4)(2 2⍴⍳4)
∆find∆010_TEST←'find' MK∆T2 (5)(3 3 3⍴⍳9)
∆find∆011_TEST←'find' MK∆T2 (⍳3)(⍬)
∆find∆012_TEST←'find' MK∆T2 (⍳3)(0)
∆find∆013_TEST←'find' MK∆T2 (⍳3)(⍳5)
∆find∆014_TEST←'find' MK∆T2 (⍳3)(2 2⍴⍳4)
∆find∆015_TEST←'find' MK∆T2 (⍳4)(3 3 4⍴1,⍳4)
∆find∆016_TEST←'find' MK∆T2 (2 2⍴⍳4)(⍬)
∆find∆017_TEST←'find' MK∆T2 (2 2⍴⍳4)(0)
∆find∆018_TEST←'find' MK∆T2 (2 2⍴⍳4)(⍳5)
∆find∆019_TEST←'find' MK∆T2 (2 2⍴⍳4)(2 2⍴⍳4)
∆find∆020_TEST←'find' MK∆T2 (2 2⍴3 1 2 3)(3 3 4⍴1,⍳4)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
