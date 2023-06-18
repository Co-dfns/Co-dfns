:Require file://t0033.dyalog
:Namespace t0033_tests

 tn←'t0033' ⋄ cn←'c0033'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0033←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆reducenwisefirst∆01_TEST←'reducenwisefirst∆R1' MK∆T2 (0)(⍳4)
∆reducenwisefirst∆02_TEST←'reducenwisefirst∆R1' MK∆T2 (1)(⍳4)
∆reducenwisefirst∆03_TEST←'reducenwisefirst∆R1' MK∆T2 (2)(⍳4)
∆reducenwisefirst∆04_TEST←'reducenwisefirst∆R1' MK∆T2 (4)(⍳4)
∆reducenwisefirst∆05_TEST←'reducenwisefirst∆R1' MK∆T2 (5)(⍳4)
∆reducenwisefirst∆06_TEST←'reducenwisefirst∆R1' MK∆T2 (2)(3 3⍴⍳4)
∆reducenwisefirst∆07_TEST←'reducenwisefirst∆R2' MK∆T2 (0)(⍳4)
∆reducenwisefirst∆08_TEST←'reducenwisefirst∆R2' MK∆T2 (1)(⍳4)
∆reducenwisefirst∆09_TEST←'reducenwisefirst∆R2' MK∆T2 (2)(⍳4)
∆reducenwisefirst∆10_TEST←'reducenwisefirst∆R2' MK∆T2 (4)(⍳4)
∆reducenwisefirst∆11_TEST←'reducenwisefirst∆R2' MK∆T2 (5)(⍳4)
∆reducenwisefirst∆12_TEST←'reducenwisefirst∆R2' MK∆T2 (2)(3 3⍴⍳4)
∆reducenwisefirst∆13_TEST←'reducenwisefirst∆R3' MK∆T2 (1)(⍳4)
∆reducenwisefirst∆14_TEST←'reducenwisefirst∆R3' MK∆T2 (2)(⍳4)
∆reducenwisefirst∆15_TEST←'reducenwisefirst∆R3' MK∆T2 (4)(⍳4)
∆reducenwisefirst∆16_TEST←'reducenwisefirst∆R3' MK∆T2 (5)(⍳4)
∆reducenwisefirst∆17_TEST←'reducenwisefirst∆R3' MK∆T2 (2)(3 3⍴⍳4)
∆reducenwisefirst∆18_TEST←'reducenwisefirst∆R1' MK∆T2 (¯1)(⍳4)
∆reducenwisefirst∆19_TEST←'reducenwisefirst∆R1' MK∆T2 (¯2)(⍳4)
∆reducenwisefirst∆20_TEST←'reducenwisefirst∆R1' MK∆T2 (¯4)(⍳4)
∆reducenwisefirst∆21_TEST←'reducenwisefirst∆R1' MK∆T2 (¯5)(⍳4)
∆reducenwisefirst∆22_TEST←'reducenwisefirst∆R1' MK∆T2 (¯2)(3 3⍴⍳4)
∆reducenwisefirst∆23_TEST←'reducenwisefirst∆R2' MK∆T2 (¯1)(⍳4)
∆reducenwisefirst∆24_TEST←'reducenwisefirst∆R2' MK∆T2 (¯2)(⍳4)
∆reducenwisefirst∆25_TEST←'reducenwisefirst∆R2' MK∆T2 (¯4)(⍳4)
∆reducenwisefirst∆26_TEST←'reducenwisefirst∆R2' MK∆T2 (¯5)(⍳4)
∆reducenwisefirst∆27_TEST←'reducenwisefirst∆R2' MK∆T2 (¯2)(3 3⍴⍳4)
∆reducenwisefirst∆28_TEST←'reducenwisefirst∆R3' MK∆T2 (¯1)(⍳4)
∆reducenwisefirst∆29_TEST←'reducenwisefirst∆R3' MK∆T2 (¯2)(⍳4)
∆reducenwisefirst∆30_TEST←'reducenwisefirst∆R3' MK∆T2 (¯4)(⍳4)
∆reducenwisefirst∆31_TEST←'reducenwisefirst∆R3' MK∆T2 (¯5)(⍳4)
∆reducenwisefirst∆32_TEST←'reducenwisefirst∆R3' MK∆T2 (¯2)(3 3⍴⍳4)

:EndNamespace