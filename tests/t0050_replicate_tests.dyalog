:Require file://t0050.dyalog
:Namespace t0050_tests

 tn←'t0050' ⋄ cn←'c0050'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0050←tn #.codfns.Fix ⎕SRC dy}

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

∆replicate∆01_TEST←'replicate' MK∆T2 (⍬)                (⍬)
∆replicate∆02_TEST←'replicate' MK∆T2 (I 0)              (5)
∆replicate∆03_TEST←'replicate' MK∆T2 (I 1)              (5)
∆replicate∆04_TEST←'replicate' MK∆T2 (I 1 1)            (5 5)
∆replicate∆05_TEST←'replicate' MK∆T2 (I 0 0)            (5 5)
∆replicate∆06_TEST←'replicate' MK∆T2 (I 1 0)            (5 5)
∆replicate∆07_TEST←'replicate' MK∆T2 (I 0 1)            (5 5)
∆replicate∆08_TEST←'replicate' MK∆T2 (I 0 1 0 1 0)	(⍳5)
∆replicate∆09_TEST←'replicate' MK∆T2 (I 0 1 0 2 0 3 1)	(⍳7)
∆replicate∆10_TEST←'replicate' MK∆T2 (I 0 1 0 ¯2 0 3 1)	(⍳7)
∆replicate∆11_TEST←'replicate' MK∆T2 (I 0 1 0 ¯2 0 3 1)	(7)
∆replicate∆12_TEST←'replicate' MK∆T2 (I 0)              (⍳3)
∆replicate∆13_TEST←'replicate' MK∆T2 (I 1)              (⍳3)
∆replicate∆14_TEST←'replicate' MK∆T2 (I 3)              (⍳3)
∆replicate∆15_TEST←'replicate' MK∆T2 (I 0 1 0 ¯2 0 3 1)	(5 7⍴⍳35)
∆replicate∆16_TEST←'replicate' MK∆T2 (0 1 0 1 1 1 0)	(5 7⍴⍳35)
∆replicate∆17_TEST←'replicate' MK∆T2 (0 1 0 1 1 1 0)	(5)
∆replicate∆18_TEST←'replicate' MK∆T2 (32⍴0 1 0 1 1 1 0)	(⍳32)
∆replicate∆19_TEST←'replicate' MK∆T2 (14⍴0 1 0 1 1 1 0)	(⍳14)
∆replicate∆20_TEST←'replicate' MK∆T2 (0 ¯1 0)           (2 3⍴⍳6)
∆replicate∆21_TEST←'replicate' MK∆T2 (¯1 0 0)           (2 3⍴⍳6)
∆replicate∆22_TEST←'replicate' MK∆T2 (1 1 1)            (,5)
∆replicate∆23_TEST←'replicate' MK∆T2 (⍳5)               (,5)


 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
