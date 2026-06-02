:Require file://t0034.dyalog
:Namespace t0034_tests

 tn←'t0034' ⋄ cn←'c0034'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0034←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆reducenwise∆01_TEST←'reducenwise∆R1' MK∆T2 (0)(⍳4)
∆reducenwise∆02_TEST←'reducenwise∆R1' MK∆T2 (1)(⍳4)
∆reducenwise∆03_TEST←'reducenwise∆R1' MK∆T2 (2)(⍳4)
∆reducenwise∆04_TEST←'reducenwise∆R1' MK∆T2 (4)(⍳4)
∆reducenwise∆05_TEST←'reducenwise∆R1' MK∆T2 (5)(⍳4)
∆reducenwise∆06_TEST←'reducenwise∆R1' MK∆T2 (2)(3 3⍴⍳4)
∆reducenwise∆07_TEST←'reducenwise∆R2' MK∆T2 (0)(⍳4)
∆reducenwise∆08_TEST←'reducenwise∆R2' MK∆T2 (1)(⍳4)
∆reducenwise∆09_TEST←'reducenwise∆R2' MK∆T2 (2)(⍳4)
∆reducenwise∆10_TEST←'reducenwise∆R2' MK∆T2 (4)(⍳4)
∆reducenwise∆11_TEST←'reducenwise∆R2' MK∆T2 (5)(⍳4)
∆reducenwise∆12_TEST←'reducenwise∆R2' MK∆T2 (2)(3 3⍴⍳4)
∆reducenwise∆13_TEST←'reducenwise∆R3' MK∆T2 (1)(⍳4)
∆reducenwise∆14_TEST←'reducenwise∆R3' MK∆T2 (2)(⍳4)
∆reducenwise∆15_TEST←'reducenwise∆R3' MK∆T2 (4)(⍳4)
∆reducenwise∆16_TEST←'reducenwise∆R3' MK∆T2 (5)(⍳4)
∆reducenwise∆17_TEST←'reducenwise∆R3' MK∆T2 (2)(3 3⍴⍳4)
∆reducenwise∆18_TEST←'reducenwise∆R1' MK∆T2 (¯1)(⍳4)
∆reducenwise∆19_TEST←'reducenwise∆R1' MK∆T2 (¯2)(⍳4)
∆reducenwise∆20_TEST←'reducenwise∆R1' MK∆T2 (¯4)(⍳4)
∆reducenwise∆21_TEST←'reducenwise∆R1' MK∆T2 (¯5)(⍳4)
∆reducenwise∆22_TEST←'reducenwise∆R1' MK∆T2 (¯2)(3 3⍴⍳4)
∆reducenwise∆23_TEST←'reducenwise∆R2' MK∆T2 (¯1)(⍳4)
∆reducenwise∆24_TEST←'reducenwise∆R2' MK∆T2 (¯2)(⍳4)
∆reducenwise∆25_TEST←'reducenwise∆R2' MK∆T2 (¯4)(⍳4)
∆reducenwise∆26_TEST←'reducenwise∆R2' MK∆T2 (¯5)(⍳4)
∆reducenwise∆27_TEST←'reducenwise∆R2' MK∆T2 (¯2)(3 3⍴⍳4)
∆reducenwise∆28_TEST←'reducenwise∆R3' MK∆T2 (¯1)(⍳4)
∆reducenwise∆29_TEST←'reducenwise∆R3' MK∆T2 (¯2)(⍳4)
∆reducenwise∆30_TEST←'reducenwise∆R3' MK∆T2 (¯4)(⍳4)
∆reducenwise∆31_TEST←'reducenwise∆R3' MK∆T2 (¯5)(⍳4)
∆reducenwise∆32_TEST←'reducenwise∆R3' MK∆T2 (¯2)(3 3⍴⍳4)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace