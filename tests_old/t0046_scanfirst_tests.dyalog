:Require file://t0046.dyalog
:Namespace t0046_tests

 tn←'t0046' ⋄ cn←'c0046'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0046←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆scanfirst∆01_TEST←'scanfirst∆R1' MK∆T1 (⍬⍴1)
∆scanfirst∆02_TEST←'scanfirst∆R1' MK∆T1 (5⍴⍳5)
∆scanfirst∆03_TEST←'scanfirst∆R1' MK∆T1 (3 3⍴⍳9)
∆scanfirst∆04_TEST←'scanfirst∆R3' MK∆T1 (⍬⍴3)
∆scanfirst∆05_TEST←'scanfirst∆R2' MK∆T1 (⍬)
∆scanfirst∆06_TEST←'scanfirst∆R1' MK∆T1 (⍬)
∆scanfirst∆07_TEST←'scanfirst∆R3' MK∆T1 (⍬⍴1)
∆scanfirst∆08_TEST←'scanfirst∆R3' MK∆T1 (5⍴⍳5)
∆scanfirst∆09_TEST←'scanfirst∆R2' MK∆T1 (3 3⍴⍳9)
∆scanfirst∆10_TEST←'scanfirst∆R1' MK∆T1 ((2*18)⍴2 0 0 0 0)
∆scanfirst∆11_TEST←'scanfirst∆R4' MK∆T1 ((10 2)⍴1)
∆scanfirst∆12_TEST←'scanfirst∆R4' MK∆T1 ((10 2)⍴5)
∆scanfirst∆13_TEST←'scanfirst∆R1' MK∆T1 ((10 2)⍴1)
∆scanfirst∆14_TEST←'scanfirst∆R4' MK∆T1 ((10 2)⍴1 0)
∆scanfirst∆15_TEST←'scanfirst∆R4' MK∆T1 ((10 2)⍴5 0)
∆scanfirst∆16_TEST←'scanfirst∆R4' MK∆T1 (⍬⍴1)
∆scanfirst∆17_TEST←'scanfirst∆R4' MK∆T1 (5⍴⍳5)
∆scanfirst∆18_TEST←'scanfirst∆R4' MK∆T1 (3 3⍴⍳9)
∆scanfirst∆19_TEST←'scanfirst∆R3' MK∆T1 (0 3⍴⍳9)
∆scanfirst∆20_TEST←'scanfirst∆R4' MK∆T1 (0 3⍴⍳9)
∆scanfirst∆21_TEST←'scanfirst∆R3' MK∆T1 (1 3⍴⍳9)
∆scanfirst∆22_TEST←'scanfirst∆R4' MK∆T1 (1 3⍴⍳9)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace