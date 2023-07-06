:Require file://t0044.dyalog
:Namespace t0044_tests

 tn←'t0044' ⋄ cn←'c0044'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0044←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆reduce∆01_TEST←'reduce∆R01' MK∆T1 (⍬⍴1)
∆reduce∆02_TEST←'reduce∆R01' MK∆T1 (5⍴⍳5)
∆reduce∆03_TEST←'reduce∆R01' MK∆T1 (3 3⍴⍳9)
∆reduce∆04_TEST←'reduce∆R02' MK∆T1 (⍬⍴3)
∆reduce∆05_TEST←'reduce∆R02' MK∆T1 (⍬)
∆reduce∆06_TEST←'reduce∆R01' MK∆T1 (⍬)
∆reduce∆07_TEST←'reduce∆R03' MK∆T1 (⍬⍴1)
∆reduce∆08_TEST←'reduce∆R03' MK∆T1 (5⍴⍳5)
∆reduce∆09_TEST←'reduce∆R03' MK∆T1 (3 3⍴⍳9)
∆reduce∆10_TEST←'reduce∆R04' MK∆T1 (3 3⍴⍳9)
∆reduce∆11_TEST←'reduce∆R05' MK∆T1 (3 3⍴⍳9)
∆reduce∆12_TEST←'reduce∆R04' MK∆T1 (⍬⍴1)
∆reduce∆13_TEST←'reduce∆R04' MK∆T1 (5⍴⍳5)
∆reduce∆14_TEST←'reduce∆R04' MK∆T1 (⍬)
∆reduce∆15_TEST←'reduce∆R01' MK∆T1 (10⍴0 1)
∆reduce∆16_TEST←'reduce∆R04' MK∆T1 (10 5 0⍴0 1)
∆reduce∆17_TEST←'reduce∆R04' MK∆T1 (10 0 5⍴0 1)
∆reduce∆18_TEST←'reduce∆R06' MK∆T1 (10 5 0⍴0 1)
∆reduce∆19_TEST←'reduce∆R06' MK∆T1 (10 0 5⍴0 1)
∆reduce∆20_TEST←'reduce∆R05' MK∆T1 (10⍴0 1)
∆reduce∆21_TEST←'reduce∆R01' MK∆T1 (10 15⍴0 1)
∆reduce∆22_TEST←'reduce∆R05' MK∆T1 (5⍴⍳5)
∆reduce∆23_TEST←'reduce∆R06' MK∆T1 (⍬)
∆reduce∆24_TEST←'reduce∆R07' MK∆T1 (⍬)
∆reduce∆25_TEST←'reduce∆R08' MK∆T1 (⍬)
∆reduce∆26_TEST←'reduce∆R09' MK∆T1 (⍬)
∆reduce∆27_TEST←'reduce∆R10' MK∆T1 (⍬)
∆reduce∆28_TEST←'reduce∆R11' MK∆T1 (⍬)
∆reduce∆29_TEST←'reduce∆R12' MK∆T1 (⍬)
∆reduce∆30_TEST←'reduce∆R13' MK∆T1 (⍬)
∆reduce∆31_TEST←'reduce∆R14' MK∆T1 (⍬)
∆reduce∆32_TEST←'reduce∆R15' MK∆T1 (⍬)
∆reduce∆33_TEST←'reduce∆R16' MK∆T1 (⍬)
∆reduce∆34_TEST←'reduce∆R17' MK∆T1 (⍬)
∆reduce∆35_TEST←'reduce∆R18' MK∆T1 (⍬)
∆reduce∆36_TEST←'reduce∆R19' MK∆T1 (⍬)
∆reduce∆37_TEST←'reduce∆R20' MK∆T1 (⍬)
∆reduce∆38_TEST←'reduce∆R21' MK∆T1 (⍬)
∆reduce∆39_TEST←'reduce∆R22' MK∆T1 (⍬)
∆reduce∆40_TEST←'reduce∆R23' MK∆T1 (⍬)
∆reduce∆41_TEST←'reduce∆R24' MK∆T1 (⍬)
∆reduce∆42_TEST←'reduce∆R25' MK∆T1 (⍬)
∆reduce∆43_TEST←'reduce∆R26' MK∆T1 (⍬)
∆reduce∆44_TEST←'reduce∆R27' MK∆T1 (⍬)
∆reduce∆45_TEST←'reduce∆R28' MK∆T1 (⍬)
∆reduce∆46_TEST←'reduce∆R29' MK∆T1 (⍬)
∆reduce∆47_TEST←'reduce∆R30' MK∆T1 (3 3⍴⍳9)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace