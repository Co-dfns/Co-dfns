:Require file://t0060.dyalog
:Namespace t0060_tests

 tn←'t0060' ⋄ cn←'c0060'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0060←tn #.codfns.Fix ⎕SRC dy}

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

∆expandfirst∆01_TEST←'expandfirst' MK∆T2 (⍬)                   (⍬)
∆expandfirst∆02_TEST←'expandfirst' MK∆T2 (I 0)                 (5)
∆expandfirst∆03_TEST←'expandfirst' MK∆T2 (I 1)                 (5)
∆expandfirst∆04_TEST←'expandfirst' MK∆T2 (I 1 1)               (5 5)
∆expandfirst∆05_TEST←'expandfirst' MK∆T2 (I 0 0 1 1)           (5 5)
∆expandfirst∆06_TEST←'expandfirst' MK∆T2 (I 1 0 1 0)           (5 5)
∆expandfirst∆07_TEST←'expandfirst' MK∆T2 (I 0 0 1 1)           (5 5)
∆expandfirst∆08_TEST←'expandfirst' MK∆T2 (I 1 2 1 2 1)         (⍳5)
∆expandfirst∆09_TEST←'expandfirst' MK∆T2 (I 1 2 1 3 1 4 2)     (⍳7)
∆expandfirst∆10_TEST←'expandfirst' MK∆T2 (I 1 4 2 1 ¯2 1 3 1)  (⍳7)
∆expandfirst∆11_TEST←'expandfirst' MK∆T2 (I 1 1 1 ¯2 0 3 ¯1 2) (7)
∆expandfirst∆12_TEST←'expandfirst' MK∆T2 (I 0 1 2 3)           (⍳3)
∆expandfirst∆13_TEST←'expandfirst' MK∆T2 (I 1 1 1)             (⍳3)
∆expandfirst∆14_TEST←'expandfirst' MK∆T2 (I 3 2 1)             (⍳3)
∆expandfirst∆15_TEST←'expandfirst' MK∆T2 (I 1 4 2 1 ¯2 1 3 1)  (7 5⍴⍳35)
∆expandfirst∆16_TEST←'expandfirst' MK∆T2 (1 1 1 ¯2 1 1 3 0 2)  (7 5⍴⍳35)
∆expandfirst∆17_TEST←'expandfirst' MK∆T2 (0 1 0 1 1 1 0)       (5)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
