:Require file://t0039.dyalog
:Namespace t0039_tests

 tn←'t0039' ⋄ cn←'c0039'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0039←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆laminate∆01_TEST←'laminate∆R1' MK∆T2 (⍳5)       (⍳5)
∆laminate∆02_TEST←'laminate∆R1' MK∆T2 (2 2 2⍴⍳8) (2 2 2⍴⍳8)
∆laminate∆03_TEST←'laminate∆R1' MK∆T2 (2 2⍴⍳8)   (2 2⍴⍳8)
∆laminate∆04_TEST←'laminate∆R2' MK∆T2 (7)        (8 8 8⍴⍳8)
∆laminate∆05_TEST←'laminate∆R3' MK∆T2 (7)        (8 8 8⍴⍳8)
∆laminate∆06_TEST←'laminate∆R4' MK∆T2 (7)        (8 8 8⍴⍳8)
∆laminate∆07_TEST←'laminate∆R2' MK∆T2 (8 8 8⍴⍳8) (7)
∆laminate∆08_TEST←'laminate∆R3' MK∆T2 (8 8 8⍴⍳8) (7)
∆laminate∆09_TEST←'laminate∆R4' MK∆T2 (8 8 8⍴⍳8) (7)
∆laminate∆10_TEST←'laminate∆R5' MK∆T2 (⍳5)       (⍳5)
∆laminate∆11_TEST←'laminate∆R5' MK∆T2 (2 2 2⍴⍳8) (2 2 2⍴⍳8)
∆laminate∆12_TEST←'laminate∆R5' MK∆T2 (2 2⍴⍳8)   (2 2⍴⍳8)
∆laminate∆13_TEST←'laminate∆R2' MK∆T2 (⍳8)       (8 8⍴⍳8)
∆laminate∆14_TEST←'laminate∆R3' MK∆T2 (⍳8)       (8 8⍴⍳8)
∆laminate∆15_TEST←'laminate∆R2' MK∆T2 (8 8⍴⍳8) (⍳8)
∆laminate∆16_TEST←'laminate∆R3' MK∆T2 (8 8⍴⍳8) (⍳8)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace