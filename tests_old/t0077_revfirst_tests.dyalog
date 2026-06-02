:Require file://t0077.dyalog
:Namespace t0077_tests

 tn←'t0077' ⋄ cn←'c0077'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0077←tn #.codfns.Fix ⎕SRC dy}

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

∆revfirst∆01_TEST←'revfirst∆R1' MK∆T1 (⍬)
∆revfirst∆02_TEST←'revfirst∆R1' MK∆T1 (0)
∆revfirst∆03_TEST←'revfirst∆R1' MK∆T1 (⍳5)
∆revfirst∆04_TEST←'revfirst∆R1' MK∆T1 (2 3 4⍴⍳5)
∆revfirst∆05_TEST←'revfirst∆R1' MK∆T1 (2 3 4⍴1 0 0)
∆revfirst∆06_TEST←'revfirst∆R1' MK∆T1 (40⍴0 1)
∆revfirst∆07_TEST←'revfirst∆R1' MK∆T1 (0 1 1 0 0 1 1 1 1 0 0)
∆revfirst∆08_TEST←'revfirst∆R1' MK∆T1 (0 1 1 0 0 1 1)
∆revfirst∆09_TEST←'revfirst∆R2' MK∆T2 (2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
∆revfirst∆10_TEST←'revfirst∆R2' MK∆T2 (2 3 4⍴⍳5)
∆revfirst∆11_TEST←'revfirst∆R1' MK∆T1 (13⍴0 1)
∆revfirst∆12_TEST←'revfirst∆R1' MK∆T1 (7⍴0 1)
∆revfirst∆13_TEST←'revfirst∆R1' MK∆T1 (2 3 5⍴1 0 0)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
