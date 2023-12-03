:Require file://t0052.dyalog
:Namespace t0052_tests

 tn←'t0052' ⋄ cn←'c0052'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0052←tn #.codfns.Fix ⎕SRC dy}

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

∆replicatefirst∆01_TEST←'replicatefirst' MK∆T2 (⍬)                (⍬)
∆replicatefirst∆02_TEST←'replicatefirst' MK∆T2 (I 0)              (5)
∆replicatefirst∆03_TEST←'replicatefirst' MK∆T2 (I 1)              (5)
∆replicatefirst∆04_TEST←'replicatefirst' MK∆T2 (I 1 1)            (5 5)
∆replicatefirst∆05_TEST←'replicatefirst' MK∆T2 (I 0 0)            (5 5)
∆replicatefirst∆06_TEST←'replicatefirst' MK∆T2 (I 1 0)            (5 5)
∆replicatefirst∆07_TEST←'replicatefirst' MK∆T2 (I 0 1)            (5 5)
∆replicatefirst∆08_TEST←'replicatefirst' MK∆T2 (I 0 1 0 1 0)      (⍳5)
∆replicatefirst∆09_TEST←'replicatefirst' MK∆T2 (I 0 1 0 2 0 3 1)  (⍳7)
∆replicatefirst∆10_TEST←'replicatefirst' MK∆T2 (I 0 1 0 ¯2 0 3 1) (⍳7)
∆replicatefirst∆11_TEST←'replicatefirst' MK∆T2 (I 0 1 0 ¯2 0 3 1) (7)
∆replicatefirst∆12_TEST←'replicatefirst' MK∆T2 (I 0)              (⍳3)
∆replicatefirst∆13_TEST←'replicatefirst' MK∆T2 (I 1)              (⍳3)
∆replicatefirst∆14_TEST←'replicatefirst' MK∆T2 (I 3)              (⍳3)
∆replicatefirst∆15_TEST←'replicatefirst' MK∆T2 (I 0 1 0 ¯2 0 3 1) (7 5⍴⍳35)
∆replicatefirst∆16_TEST←'replicatefirst' MK∆T2 (0 1 0 1 1 1 0)    (7 5⍴⍳35)
∆replicatefirst∆17_TEST←'replicatefirst' MK∆T2 (0 1 0 1 1 1 0)    (5)
∆replicatefirst∆18_TEST←'replicatefirst' MK∆T2 (32⍴0 1 0 1 1 1 0) (⍳32)
∆replicatefirst∆19_TEST←'replicatefirst' MK∆T2 (14⍴0 1 0 1 1 1 0) (⍳14)
∆replicatefirst∆20_TEST←'replicatefirst' MK∆T2 (0 ¯1)             (2 3⍴⍳6)
∆replicatefirst∆21_TEST←'replicatefirst' MK∆T2 (¯1 0)             (2 3⍴⍳6)
∆replicatefirst∆22_TEST←'replicatefirst' MK∆T2 (1 1 1)            (,5)
∆replicatefirst∆23_TEST←'replicatefirst' MK∆T2 (⍳5)               (,5)
∆replicatefirst∆24_TEST←'replicatefirst' MK∆T2 (1 0 1 0)          ('abc' 'def' 'ghi' 'd')

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
