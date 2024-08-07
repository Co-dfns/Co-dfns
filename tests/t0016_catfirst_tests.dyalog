﻿:Require file://t0016.dyalog
:Namespace t0016_tests

 tn←'t0016' ⋄ cn←'c0016'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0016←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}
 MK∆T4←{fn tl←⍺⍺ ⋄ nv←(⍎'dy.',fn)⍵⍵ ⋄ cv←(⍎'cd.',fn)⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}

∆catfirst∆01_TEST←'catfirst' MK∆T2 (⍬)           (⍬)
∆catfirst∆02_TEST←'catfirst' MK∆T2 (5)           (5)
∆catfirst∆03_TEST←'catfirst' MK∆T2 (⍬)           (5)
∆catfirst∆04_TEST←'catfirst' MK∆T2 (⍬)           (⍳5)
∆catfirst∆05_TEST←'catfirst' MK∆T2 (⍳7)          (⍳5)
∆catfirst∆06_TEST←'catfirst' MK∆T2 (5)           (⍳5)
∆catfirst∆07_TEST←'catfirst' MK∆T2 (2 2⍴5)       (2 2⍴5)
∆catfirst∆08_TEST←'catfirst' MK∆T2 (2 2 3⍴5)     (2 3⍴5)
∆catfirst∆09_TEST←'catfirst' MK∆T2 (2 3⍴5)       (2 2 3⍴⌽⍳12)
∆catfirst∆10_TEST←'catfirst' MK∆T2 (2 3⍴5)       (2 2 3⍴5)
∆catfirst∆11_TEST←'catfirst' MK∆T2 (5)           (2 2⍴5)
∆catfirst∆12_TEST←'catfirst' MK∆T2 (,5 5)        (2 2⍴5)
∆catfirst∆13_TEST←'catfirst' MK∆T2 (,5)          (,5)
∆catfirst∆14_TEST←'catfirst' MK∆T2 (7⍴1 0)       (2 7⍴0 1)
∆catfirst∆15_TEST←'catfirst' MK∆T2 (,5 4)        (2 2⍴1 0 0)
∆catfirst∆16_TEST←'catfirst' MK∆T2 (2 2⍴1 0 0)   (,5 4)
∆catfirst∆17_TEST←'catfirst' MK∆T2 (10 10⍴⌽⍳100) (3 10⍴-⌽⍳30)
∆catfirst∆18_TEST←'catfirst' MK∆T2 (3 10⍴-⌽⍳30)  (10 10⍴⌽⍳100)
∆catfirst∆19_TEST←'catfirst' MK∆T2 (5)           (÷5)
∆catfirst∆20_TEST←'catfirst' MK∆T2 (⍬)           (÷5)
∆catfirst∆21_TEST←'catfirst' MK∆T2 (⍬)           (÷1+⍳5)
∆catfirst∆22_TEST←'catfirst' MK∆T2 (⍳7)          (÷1+⍳5)
∆catfirst∆23_TEST←'catfirst' MK∆T2 (5)           (÷1+⍳5)
∆catfirst∆24_TEST←'catfirst' MK∆T2 (2 2⍴5)       (÷2 2⍴5)
∆catfirst∆25_TEST←'catfirst' MK∆T2 (2 2 3⍴5)     (÷2 3⍴5)
∆catfirst∆26_TEST←'catfirst' MK∆T2 (2 3⍴5)       (÷2 2 3⍴⌽1+⍳12)
∆catfirst∆27_TEST←'catfirst' MK∆T2 (2 3⍴5)       (÷2 2 3⍴5)
∆catfirst∆28_TEST←'catfirst' MK∆T2 (5)           (÷2 2⍴5)
∆catfirst∆29_TEST←'catfirst' MK∆T2 (,5 5)        (÷2 2⍴5)
∆catfirst∆30_TEST←'catfirst' MK∆T2 (,5)          (÷,5)
∆catfirst∆31_TEST←'catfirst' MK∆T2 (?128⍴2)      (?128⍴2)
∆catfirst∆32_TEST←'catfirst' MK∆T2 (?120⍴2)      (?120⍴2)
∆catfirst∆33_TEST←'catfirst' MK∆T2 (?70⍴2)       (?70⍴2)
∆catfirst∆34_TEST←'catfirst' MK∆T2 (5)           (?5 5⍴2)
∆catfirst∆35_TEST←'catfirst' MK∆T2 (5)           (⍬⍴1 0 0 0)
∆catfirst∆36_TEST←'catfirst' MK∆T2 (5)           (⍬⍴0 1 0 1)
∆catfirst∆37_TEST←'catfirst' MK∆T2 (,5 4 3)      (⍬⍴1 0 0 0)
∆catfirst∆38_TEST←'catfirst' MK∆T2 (,5 4 3)      (⍬⍴0 1 0 0)
∆catfirst∆39_TEST←'catfirst' MK∆T2 (?5 5⍴2)      (5)
∆catfirst∆40_TEST←'catfirst' MK∆T2 (⍬⍴1 0 0 0)   (5)
∆catfirst∆41_TEST←'catfirst' MK∆T2 (⍬⍴0 1 0 1)   (5)
∆catfirst∆42_TEST←'catfirst' MK∆T2 (⍬⍴1 0 0 0)   (,5 4 3)
∆catfirst∆43_TEST←'catfirst' MK∆T2 (⍬⍴0 1 0 0)   (,5 4 3)
∆catfirst∆44_TEST←'catfirst' MK∆T2 (÷5)          (÷5)
∆catfirst∆45_TEST←'catfirst' MK∆T2 (÷⍬)          (÷5)
∆catfirst∆46_TEST←'catfirst' MK∆T2 (÷⍬)          (÷1+⍳5)
∆catfirst∆47_TEST←'catfirst' MK∆T2 (÷1+⍳7)       (÷1+⍳5)
∆catfirst∆48_TEST←'catfirst' MK∆T2 (÷5)          (÷1+⍳5)
∆catfirst∆49_TEST←'catfirst' MK∆T2 (÷2 2⍴5)      (÷2 2⍴5)
∆catfirst∆50_TEST←'catfirst' MK∆T2 (÷2 2 3⍴5)    (÷2 3⍴5)
∆catfirst∆51_TEST←'catfirst' MK∆T2 (÷2 3⍴5)      (÷2 2 3⍴⌽1+⍳12)
∆catfirst∆52_TEST←'catfirst' MK∆T2 (÷2 3⍴5)      (÷2 2 3⍴5)
∆catfirst∆53_TEST←'catfirst' MK∆T2 (÷5)          (÷2 2⍴5)
∆catfirst∆54_TEST←'catfirst' MK∆T2 (÷,5 5)       (÷2 2⍴5)
∆catfirst∆55_TEST←'catfirst' MK∆T2 (÷,5)         (÷,5)
∆catfirst∆56_TEST←'catfirst' MK∆T2 (÷5)          (5)
∆catfirst∆57_TEST←'catfirst' MK∆T2 (÷⍬)          (5)
∆catfirst∆58_TEST←'catfirst' MK∆T2 (÷⍬)          (1+⍳5)
∆catfirst∆59_TEST←'catfirst' MK∆T2 (÷1+⍳7)       (1+⍳5)
∆catfirst∆60_TEST←'catfirst' MK∆T2 (÷5)          (1+⍳5)
∆catfirst∆61_TEST←'catfirst' MK∆T2 (÷2 2⍴5)      (2 2⍴5)
∆catfirst∆62_TEST←'catfirst' MK∆T2 (÷2 2 3⍴5)    (2 3⍴5)
∆catfirst∆63_TEST←'catfirst' MK∆T2 (÷2 3⍴5)      (2 2 3⍴⌽1+⍳12)
∆catfirst∆64_TEST←'catfirst' MK∆T2 (÷2 3⍴5)      (2 2 3⍴5)
∆catfirst∆65_TEST←'catfirst' MK∆T2 (÷5)          (2 2⍴5)
∆catfirst∆66_TEST←'catfirst' MK∆T2 (÷,5 5)       (2 2⍴5)
∆catfirst∆67_TEST←'catfirst' MK∆T2 (÷,5)         (,5)
∆catfirst∆68_TEST←'catfirst' MK∆T2 (÷5)          (?5 5⍴2)
∆catfirst∆69_TEST←'catfirst' MK∆T2 (÷5)          (⍬⍴1 0 0 0)
∆catfirst∆70_TEST←'catfirst' MK∆T2 (÷5)          (⍬⍴0 1 0 1)
∆catfirst∆71_TEST←'catfirst' MK∆T2 (,÷5 4 3)     (⍬⍴1 0 0 0)
∆catfirst∆72_TEST←'catfirst' MK∆T2 (,÷5 4 3)     (⍬⍴0 1 0 0)
∆catfirst∆73_TEST←'catfirst' MK∆T2 (?5 5⍴2)      (÷5)
∆catfirst∆74_TEST←'catfirst' MK∆T2 (⍬⍴1 0 0 0)   (÷5)
∆catfirst∆75_TEST←'catfirst' MK∆T2 (⍬⍴0 1 0 1)   (÷5)
∆catfirst∆76_TEST←'catfirst' MK∆T2 (⍬⍴1 0 0 0)   (,÷5 4 3)
∆catfirst∆77_TEST←'catfirst' MK∆T2 (⍬⍴0 1 0 0)   (,÷5 4 3)
∆catfirst∆78_TEST←'catfirst' MK∆T2 (⍬⍴1 0 0 0)   (5 5⍴1 0 0 0)
∆catfirst∆79_TEST←'catfirst' MK∆T2 (5 5⍴1 0 0 0) (⍬⍴1 0 0 0)
∆catfirst∆80_TEST←'catfirst' MK∆T2 (⍬⍴1 0 0 0)   (?5 200⍴2)
∆catfirst∆81_TEST←'catfirst' MK∆T2 (⍬⍴1 0 0 0)   (?5 196⍴2)
∆catfirst∆82_TEST←'catfirst' MK∆T2 (?5 200⍴2)    (⍬⍴1 0 0 0)
∆catfirst∆83_TEST←'catfirst' MK∆T2 (?5 196⍴2)    (⍬⍴1 0 0 0)
∆catfirst∆84_TEST←'catfirst' MK∆T2 3             (0 5⍴⍬)
∆catfirst∆85_TEST←'catfirst' MK∆T2 (0 5⍴⍬)       3

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
