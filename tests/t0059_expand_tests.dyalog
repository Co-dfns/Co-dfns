:Require file://t0059.dyalog
:Namespace t0059_tests

 tn←'t0059' ⋄ cn←'c0059'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0059←tn #.codfns.Fix ⎕SRC dy}

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

∆expand∆01_TEST←'expand' MK∆T2 (⍬)                   (⍬)
∆expand∆02_TEST←'expand' MK∆T2 (I 0)                 (5)
∆expand∆03_TEST←'expand' MK∆T2 (I 1)                 (5)
∆expand∆04_TEST←'expand' MK∆T2 (I 1 1)               (5 5)
∆expand∆05_TEST←'expand' MK∆T2 (I 0 0 1 1)           (5 5)
∆expand∆06_TEST←'expand' MK∆T2 (I 1 0 1 0)           (5 5)
∆expand∆07_TEST←'expand' MK∆T2 (I 0 0 1 1)           (5 5)
∆expand∆08_TEST←'expand' MK∆T2 (I 1 2 1 2 1)         (⍳5)
∆expand∆09_TEST←'expand' MK∆T2 (I 1 2 1 3 1 4 2)     (⍳7)
∆expand∆10_TEST←'expand' MK∆T2 (I 1 4 2 1 ¯2 1 3 1)  (⍳7)
∆expand∆11_TEST←'expand' MK∆T2 (I 1 1 1 ¯2 0 3 ¯1 2) (7)
∆expand∆12_TEST←'expand' MK∆T2 (I 0 1 2 3)           (⍳3)
∆expand∆13_TEST←'expand' MK∆T2 (I 1 1 1)             (⍳3)
∆expand∆14_TEST←'expand' MK∆T2 (I 3 2 1)             (⍳3)
∆expand∆15_TEST←'expand' MK∆T2 (I 1 4 2 1 ¯2 1 3 1)  (5 7⍴⍳35)
∆expand∆16_TEST←'expand' MK∆T2 (1 1 1 ¯2 1 1 3 0 2)  (5 7⍴⍳35)
∆expand∆17_TEST←'expand' MK∆T2 (0 1 0 1 1 1 0)       (5)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
