:Require file://t0057.dyalog
:Namespace t0057_tests

 tn←'t0057' ⋄ cn←'c0057'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0057←tn #.codfns.Fix ⎕SRC dy}

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

BIG←0 0 0 255 65535 130815 196095 261375 326655 391935 457215 522495 587775 653055 718335 783615 848895 914175 979454 1044224 978944 913664 848384 783104 717824 652544 587264 521984 456704 391424 326144 260864 195584 130304 65025

∆encode∆01_TEST←'encode' MK∆T2 ⍬           ⍬
∆encode∆02_TEST←'encode' MK∆T2 ⍬           (⍳5)
∆encode∆03_TEST←'encode' MK∆T2 (⍳5)        ⍬
∆encode∆04_TEST←'encode' MK∆T2 (5 2⍴⍳5)    (3 0⍴⍬)
∆encode∆05_TEST←'encode' MK∆T2 (0 2⍴⍬)     (3 5⍴⍬)
∆encode∆06_TEST←'encode' MK∆T2 0           (3 5⍴⍳15)
∆encode∆07_TEST←'encode' MK∆T2 (,0)        (3 5⍴⍳15)
∆encode∆08_TEST←'encode' MK∆T2 5           (⍳30)
∆encode∆09_TEST←'encode' MK∆T2 (,5)        (⍳30)
∆encode∆10_TEST←'encode' MK∆T2 (5⍴0)       (⍳30)
∆encode∆11_TEST←'encode' MK∆T2 (5⍴5)       (⍳30)
∆encode∆12_TEST←'encode' MK∆T2 (5⍴2)       (⍳30)
∆encode∆13_TEST←'encode' MK∆T2 (2 3 4)     (⍳30)
∆encode∆14_TEST←'encode' MK∆T2 (0 3 4)     (⍳100)
∆encode∆15_TEST←'encode' MK∆T2 (3 0 4)     (⍳100)
∆encode∆16_TEST←'encode' MK∆T2 (3 4 0)     (⍳100)
∆encode∆17_TEST←'encode' MK∆T2 (3 3⍴2)     (⍳10)
∆encode∆18_TEST←'encode' MK∆T2 (3 3⍴2 3 4) (⍳30)
∆encode∆19_TEST←'encode' MK∆T2 (32⍴2)      (3 3 3⍴⍳81)
∆encode∆20_TEST←'encode∆Ovr' MK∆T2 (32⍴2)      (3 3 3 3⍴⍳81)
∆encode∆21_TEST←'encode' MK∆T2 (0 5)       (-⍳20)
∆encode∆22_TEST←'encode' MK∆T2 256         (⍉30 35⍴BIG)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
