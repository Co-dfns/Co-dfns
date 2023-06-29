:Require file://t0040.dyalog
:Namespace t0040_tests

 tn←'t0040' ⋄ cn←'c0040'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0040←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆outerproduct∆01_TEST←'outerproduct∆R1' MK∆T2 (1)            (1)
∆outerproduct∆02_TEST←'outerproduct∆R1' MK∆T2 (1)            (⍬)
∆outerproduct∆03_TEST←'outerproduct∆R1' MK∆T2 (⍬)        (⍬)
∆outerproduct∆04_TEST←'outerproduct∆R1' MK∆T2 (⍬)        (1+⍳3)
∆outerproduct∆05_TEST←'outerproduct∆R1' MK∆T2 (1+⍳3)     (⍬)
∆outerproduct∆06_TEST←'outerproduct∆R1' MK∆T2 (5)            (1+⍳3)
∆outerproduct∆07_TEST←'outerproduct∆R1' MK∆T2 (1+⍳3)     (1+⍳3)
∆outerproduct∆08_TEST←'outerproduct∆R1' MK∆T2 (2 2⍴3)    (1+⍳7)
∆outerproduct∆09_TEST←'outerproduct∆R1' MK∆T2 (2 2⍴1+⍳4) (2 2⍴1+⍳4)
∆outerproduct∆10_TEST←'outerproduct∆R1' MK∆T2 (2 2⍴1+⍳4) (2 2⍴÷1+⍳4)
∆outerproduct∆11_TEST←'outerproduct∆R2' MK∆T2 (1)            (1)
∆outerproduct∆12_TEST←'outerproduct∆R2' MK∆T2 (1)            (⍬)
∆outerproduct∆13_TEST←'outerproduct∆R2' MK∆T2 (⍬)        (⍬)
∆outerproduct∆14_TEST←'outerproduct∆R2' MK∆T2 (⍬)        (1+⍳3)
∆outerproduct∆15_TEST←'outerproduct∆R2' MK∆T2 (1+⍳3)     (⍬)
∆outerproduct∆16_TEST←'outerproduct∆R2' MK∆T2 (5)            (1+⍳3)
∆outerproduct∆17_TEST←'outerproduct∆R2' MK∆T2 (1+⍳3)     (1+⍳3)
∆outerproduct∆18_TEST←'outerproduct∆R2' MK∆T2 (2 2⍴3)    (1+⍳7)
∆outerproduct∆19_TEST←'outerproduct∆R2' MK∆T2 (2 2⍴1+⍳4) (2 2⍴1+⍳4)
∆outerproduct∆20_TEST←'outerproduct∆R2' MK∆T2 (2 2⍴1+⍳4) (2 2⍴÷1+⍳4)
∆outerproduct∆21_TEST←'outerproduct∆R3' MK∆T2 (0 0 0 1 1 1 1 1)(0 0 0 1 1 1 1 1)
∆outerproduct∆22_TEST←'outerproduct∆R3' MK∆T2 (0 0 0 1 1 5 1 1)(0 0 0 1 1 1 1 1)
∆outerproduct∆23_TEST←'outerproduct∆R3' MK∆T2 (0 0 0 1 1 1 1 1)(0 0 0 1 5 1 1 1)
∆outerproduct∆23_TEST←'outerproduct∆R3' MK∆T2 (0 0 0 1 1 5 1 1)(0 0 0 1 5 1 1 1)
∆outerproduct∆24_TEST←'outerproduct∆R4' MK∆T2 (0 0 0 1 1 1 1 1)(0 0 0 1 1 1 1 1)
∆outerproduct∆25_TEST←'outerproduct∆R4' MK∆T2 (0 0 0 1 1 5 1 1)(0 0 0 1 1 1 1 1)
∆outerproduct∆26_TEST←'outerproduct∆R4' MK∆T2 (0 0 0 1 1 1 1 1)(0 0 0 1 5 1 1 1)
∆outerproduct∆27_TEST←'outerproduct∆R4' MK∆T2 (0 0 0 1 1 5 1 1)(0 0 0 1 5 1 1 1)
∆outerproduct∆28_TEST←'outerproduct∆R3' MK∆T2 (0 1)(0 0 0 1 1 1 1 1)
∆outerproduct∆29_TEST←'outerproduct∆R5' MK∆T2 (2 2⍴1+⍳4) (1 2 2⍴÷1+⍳4)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace