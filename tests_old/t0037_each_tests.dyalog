:Require file://t0037.dyalog
:Namespace t0037_tests

 tn←'t0037' ⋄ cn←'c0037'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0037←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆each∆dpii_TEST←'each∆R1' MK∆T2  I	I
∆each∆dpiis_TEST←'each∆R1' MK∆T2 4	5
∆each∆dpff_TEST←'each∆R1' MK∆T2  F	F
∆each∆dpif_TEST←'each∆R1' MK∆T2  I	F
∆each∆dpfi_TEST←'each∆R1' MK∆T2  F	I
∆each∆duffs_TEST←'each∆R2' MK∆T2 5.5	3.1
∆each∆duii_TEST←'each∆R2' MK∆T2  I	I
∆each∆duff_TEST←'each∆R2' MK∆T2  F	F
∆each∆duif_TEST←'each∆R2' MK∆T2  I	F
∆each∆dufi_TEST←'each∆R2' MK∆T2  F	I
∆each∆mui_TEST←'each∆R3' MK∆T2   I	(I~0)
∆each∆muf_TEST←'each∆R3' MK∆T2   F	F
∆each∆mub_TEST←'each∆R6' MK∆T2   B	B
∆each∆mpi_TEST←'each∆R4' MK∆T2   I	(I~0)
∆each∆mpf_TEST←'each∆R4' MK∆T2   F	F
∆each∆mpb_TEST←'each∆R5' MK∆T2   B	B
∆each∆durep_TEST←'each∆R7' MK∆T2 I (⍉⍪I)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace