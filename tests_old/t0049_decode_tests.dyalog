:Require file://t0049.dyalog
:Namespace t0049_tests

 tn←'t0049' ⋄ cn←'c0049'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0049←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}
 MK∆T4←{fn tl←⍺⍺ ⋄ nv←(⍎'dy.',fn)⍵⍵ ⋄ cv←(⍎'cd.',fn)⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}

∆decode∆01_TEST←'decode' MK∆T2 ⍬           ⍬
∆decode∆02_TEST←'decode' MK∆T2 (0 0⍴0)     ⍬
∆decode∆03_TEST←'decode' MK∆T2 ⍬           (0 0⍴1)
∆decode∆04_TEST←'decode' MK∆T2 (5 5⍴0)     (5 0⍴1)
∆decode∆05_TEST←'decode' MK∆T2 (5 0⍴0)     (0 5⍴1)
∆decode∆06_TEST←'decode' MK∆T2 (0 5⍴0)     (5 5⍴1)
∆decode∆07_TEST←'decode' MK∆T2 (8⍴2)       ((8⍴2)⊤⍳30)
∆decode∆08_TEST←'decode' MK∆T2 (5 4 3)     (5 4 3⊤5 6⍳30)
∆decode∆09_TEST←'decode' MK∆T2 (3 3⍴5 4 3) ((3 3⍴5 4 3)⊤5 6⍳30)
∆decode∆10_TEST←'decode' MK∆T2 (8⍴2)       (1 3⍴⍳10)
∆decode∆11_TEST←'decode' MK∆T2 2           ((8⍴2)⊤⍳30)
∆decode∆12_TEST←'decode' MK∆T2 (5 1⍴2)     ((8⍴2)⊤⍳30)
∆decode∆13_TEST←'decode' MK∆T2 (5 0 4)     (0⍪⍨0⍪⍨⍉⍪⍳5)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
