:Require file://t0017.dyalog
:Namespace t0017_tests

 tn←'t0017' ⋄ cn←'c0017'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0017←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
B←?100⍴2

∆circumference∆01_TEST←'circumference∆Run' MK∆T1 (13)
∆circumference∆02_TEST←'circumference∆Run' MK∆T1 (0)
∆circumference∆03_TEST←'circumference∆Run' MK∆T1 (12345)
∆circumference∆04_TEST←'circumference∆Run' MK∆T1 (⍳14)
∆commute∆ii_TEST←'commute∆Run' MK∆T2 I I
∆commute∆ff_TEST←'commute∆Run' MK∆T2 F F
∆commute∆if_TEST←'commute∆Run' MK∆T2 I F
∆commute∆fi_TEST←'commute∆Run' MK∆T2 F I
∆commute∆bb_TEST←'commute∆Run' MK∆T2 B B
∆commute∆bi_TEST←'commute∆Run' MK∆T2 B I
∆commute∆bf_TEST←'commute∆Run' MK∆T2 B F
∆commute∆ib_TEST←'commute∆Run' MK∆T2 I B
∆commute∆fb_TEST←'commute∆Run' MK∆T2 F B
∆commute∆i_TEST←'commute∆Rm' MK∆T1 I
∆commute∆f_TEST←'commute∆Rm' MK∆T1 F
∆commute∆b_TEST←'commute∆Rm' MK∆T1 B
∆compose∆01_TEST←'compose∆Rm' MK∆T1 I
∆compose∆02_TEST←'compose∆Rd' MK∆T2 I I
∆compose∆03_TEST←'compose∆Rl' MK∆T1 I
∆compose∆04_TEST←'compose∆Rr' MK∆T1 I
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
∆innerproduct∆01_TEST←'innerproduct∆R1' MK∆T2 (1)          (1)
∆innerproduct∆02_TEST←'innerproduct∆R1' MK∆T2 (1)          (⍬)
∆innerproduct∆03_TEST←'innerproduct∆R1' MK∆T2 (⍬)          (⍬)
∆innerproduct∆04_TEST←'innerproduct∆R1' MK∆T2 (5)          (1+⍳3)
∆innerproduct∆05_TEST←'innerproduct∆R1' MK∆T2 (1+⍳3)       (5)
∆innerproduct∆06_TEST←'innerproduct∆R1' MK∆T2 (1+⍳3)       (1+⍳3)
∆innerproduct∆07_TEST←'innerproduct∆R1' MK∆T2 (1+⍳7)       (7 2⍴3)
∆innerproduct∆08_TEST←'innerproduct∆R1' MK∆T2 (2 7⍴3)      (1+⍳7)
∆innerproduct∆09_TEST←'innerproduct∆R1' MK∆T2 (3 2⍴1+⍳4)   (2 5⍴1+⍳4)
∆innerproduct∆10_TEST←'innerproduct∆R1' MK∆T2 (3 2⍴1+⍳4)   (2 5⍴÷1+⍳4)
∆innerproduct∆11_TEST←'innerproduct∆R2' MK∆T2 (1)          (1)
∆innerproduct∆12_TEST←'innerproduct∆R2' MK∆T2 (5)          (1+⍳3)
∆innerproduct∆13_TEST←'innerproduct∆R2' MK∆T2 (1+⍳3)       (5)
∆innerproduct∆14_TEST←'innerproduct∆R2' MK∆T2 (1+⍳3)       (1+⍳3)
∆innerproduct∆15_TEST←'innerproduct∆R2' MK∆T2 (1+⍳7)       (7 2⍴3)
∆innerproduct∆16_TEST←'innerproduct∆R2' MK∆T2 (2 7⍴3)      (1+⍳7)
∆innerproduct∆17_TEST←'innerproduct∆R2' MK∆T2 (3 2⍴1+⍳4)   (2 5⍴1+⍳4)
∆innerproduct∆18_TEST←'innerproduct∆R2' MK∆T2 (3 2⍴1+⍳4)   (2 5⍴÷1+⍳4)
∆innerproduct∆19_TEST←'innerproduct∆R3' MK∆T2 (1)          (÷2+⍳5)
∆innerproduct∆20_TEST←'innerproduct∆R1' MK∆T2 (0 5⍴5)      (5 5⍴3)
∆innerproduct∆21_TEST←'innerproduct∆R4' MK∆T2 (1 3 2⍴1+⍳4) (1 2 5⍴1+⍳4)
∆innerproduct∆22_TEST←'innerproduct∆R1' MK∆T2 (⍉2 10⍴⍳10)  (2 10⍴⍳10)
∆innerproduct∆23_TEST←'innerproduct∆R5' MK∆T2 (⍉2 10⍴⍳10)  (2 10⍴⍳10)
∆innerproduct∆24_TEST←'innerproduct∆R6' MK∆T2 X            X
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
∆power∆01_TEST←'power∆R01' MK∆T2 3 7
∆power∆02_TEST←'power∆R02' MK∆T2 3 7
∆power∆03_TEST←'power∆R03' MK∆T2 3 7
∆power∆04_TEST←'power∆R04' MK∆T2 3 7
∆power∆05_TEST←'power∆R05' MK∆T2 3 7
∆power∆06_TEST←'power∆R06' MK∆T2 3 7
∆power∆07_TEST←'power∆R07' MK∆T2 3 7
∆power∆08_TEST←'power∆R08' MK∆T2 3 7
∆power∆09_TEST←'power∆R09' MK∆T2 3 7
∆power∆10_TEST←'power∆R10' MK∆T2 3 7
∆power∆11_TEST←'power∆R11' MK∆T2 3 7
∆power∆12_TEST←'power∆R12' MK∆T2 3 7
∆power∆13_TEST←'power∆R13' MK∆T2 3 7
∆power∆14_TEST←'power∆R14' MK∆T2 3 7
∆power∆15_TEST←'power∆R15' MK∆T2 3 7
∆power∆16_TEST←'power∆R16' MK∆T2 3 7
∆power∆17_TEST←'power∆R01' MK∆T2 3 (3 3⍴⍳9)
∆power∆18_TEST←'power∆R02' MK∆T2 3 (3 3⍴⍳9)
∆power∆19_TEST←'power∆R03' MK∆T2 3 (3 3⍴⍳9)
∆power∆20_TEST←'power∆R04' MK∆T2 3 (3 3⍴⍳9)
∆power∆21_TEST←'power∆R05' MK∆T2 3 (3 3⍴⍳9)
∆power∆22_TEST←'power∆R06' MK∆T2 3 (3 3⍴⍳9)
∆power∆23_TEST←'power∆R07' MK∆T2 3 (3 3⍴⍳9)
∆power∆24_TEST←'power∆R08' MK∆T2 3 (3 3⍴⍳9)
∆power∆25_TEST←'power∆R09' MK∆T2 3 (3 3⍴⍳9)
∆power∆26_TEST←'power∆R10' MK∆T2 3 (3 3⍴⍳9)
∆power∆27_TEST←'power∆R11' MK∆T2 3 (3 3⍴⍳9)
∆power∆28_TEST←'power∆R12' MK∆T2 3 (3 3⍴⍳9)
∆power∆29_TEST←'power∆R13' MK∆T2 3 (3 3⍴⍳9)
∆power∆30_TEST←'power∆R14' MK∆T2 3 (3 3⍴⍳9)
∆power∆31_TEST←'power∆R15' MK∆T2 3 (3 3⍴⍳9)
∆power∆32_TEST←'power∆R16' MK∆T2 3 (3 3⍴⍳9)
∆rank∆01_TEST←'rank∆R1' MK∆T2 0 ⍬
∆rank∆02_TEST←'rank∆R1' MK∆T2 0 (⍳5)
∆rank∆03_TEST←'rank∆R1' MK∆T2 0 (3 3⍴⍳9)
∆rank∆04_TEST←'rank∆R1' MK∆T2 1 ⍬
∆rank∆05_TEST←'rank∆R1' MK∆T2 1 (⍳5)
∆rank∆06_TEST←'rank∆R1' MK∆T2 1 (3 3⍴⍳9)
∆rank∆07_TEST←'rank∆R1' MK∆T2 2 ⍬
∆rank∆08_TEST←'rank∆R1' MK∆T2 2 (⍳5)
∆rank∆09_TEST←'rank∆R1' MK∆T2 2 (3 3⍴⍳9)
∆rank∆10_TEST←'rank∆R1' MK∆T2 ¯1 ⍬
∆rank∆11_TEST←'rank∆R1' MK∆T2 ¯1 (⍳5)
∆rank∆12_TEST←'rank∆R1' MK∆T2 ¯1 (3 3⍴⍳9)
∆rank∆13_TEST←'rank∆R1' MK∆T2 ¯2 ⍬
∆rank∆14_TEST←'rank∆R1' MK∆T2 ¯2 (⍳5)
∆rank∆15_TEST←'rank∆R1' MK∆T2 ¯2 (3 3⍴⍳9)
∆rank∆16_TEST←'rank∆R1' MK∆T2 ¯3 ⍬
∆rank∆17_TEST←'rank∆R1' MK∆T2 ¯3 (⍳5)
∆rank∆18_TEST←'rank∆R1' MK∆T2 ¯3 (3 3⍴⍳9)
∆rank∆19_TEST←'rank∆R1' MK∆T2 3 ⍬
∆rank∆20_TEST←'rank∆R1' MK∆T2 3 (⍳5)
∆rank∆21_TEST←'rank∆R1' MK∆T2 3 (3 3⍴⍳9)
∆rank∆22_TEST←'rank∆R2' MK∆T2 0 ⍬
∆rank∆23_TEST←'rank∆R2' MK∆T2 0 (⍳5)
∆rank∆24_TEST←'rank∆R2' MK∆T2 0 (3 3⍴⍳9)
∆rank∆25_TEST←'rank∆R2' MK∆T2 1 ⍬
∆rank∆26_TEST←'rank∆R2' MK∆T2 1 (⍳5)
∆rank∆27_TEST←'rank∆R2' MK∆T2 1 (3 3⍴⍳9)
∆rank∆28_TEST←'rank∆R2' MK∆T2 2 ⍬
∆rank∆29_TEST←'rank∆R2' MK∆T2 2 (⍳5)
∆rank∆30_TEST←'rank∆R2' MK∆T2 2 (3 3⍴⍳9)
∆rank∆31_TEST←'rank∆R2' MK∆T2 ¯1 ⍬
∆rank∆32_TEST←'rank∆R2' MK∆T2 ¯1 (⍳5)
∆rank∆33_TEST←'rank∆R2' MK∆T2 ¯1 (3 3⍴⍳9)
∆rank∆34_TEST←'rank∆R2' MK∆T2 ¯2 ⍬
∆rank∆35_TEST←'rank∆R2' MK∆T2 ¯2 (⍳5)
∆rank∆36_TEST←'rank∆R2' MK∆T2 ¯2 (3 3⍴⍳9)
∆rank∆37_TEST←'rank∆R2' MK∆T2 ¯3 ⍬
∆rank∆38_TEST←'rank∆R2' MK∆T2 ¯3 (⍳5)
∆rank∆39_TEST←'rank∆R2' MK∆T2 ¯3 (3 3⍴⍳9)
∆rank∆40_TEST←'rank∆R2' MK∆T2 3 ⍬
∆rank∆41_TEST←'rank∆R2' MK∆T2 3 (⍳5)
∆rank∆42_TEST←'rank∆R2' MK∆T2 3 (3 3⍴⍳9)
∆rank∆43_TEST←'rank∆R3' MK∆T2 (?10⍴100) (?10⍴100)
∆rank∆44_TEST←'rank∆R3' MK∆T2 (?10 10⍴100) (?10⍴100)
∆rank∆45_TEST←'rank∆R3' MK∆T2 (?10 10⍴100) (?10 10⍴100)
∆redfirst∆01_TEST←'redfirst∆R1' MK∆T1 (⍬⍴1)
∆redfirst∆02_TEST←'redfirst∆R1' MK∆T1 (5⍴⍳5)
∆redfirst∆03_TEST←'redfirst∆R1' MK∆T1 (3 3⍴⍳9)
∆redfirst∆04_TEST←'redfirst∆R2' MK∆T1 (⍬⍴3)
∆redfirst∆05_TEST←'redfirst∆R2' MK∆T1 (⍬)
∆redfirst∆06_TEST←'redfirst∆R1' MK∆T1 (⍬)
∆redfirst∆07_TEST←'redfirst∆R3' MK∆T1 (⍬⍴1)
∆redfirst∆08_TEST←'redfirst∆R3' MK∆T1 (5⍴⍳5)
∆redfirst∆09_TEST←'redfirst∆R3' MK∆T1 (3 3⍴⍳9)
∆redfirst∆10_TEST←'redfirst∆R1' MK∆T1 (?15⍴2)
∆redfirst∆11_TEST←'redfirst∆R1' MK∆T1 (?128⍴2)
∆redfirst∆12_TEST←'redfirst∆R1' MK∆T1 (?100⍴2)
∆redfirst∆13_TEST←'redfirst∆R1' MK∆T1 (?3 3⍴2)
∆redfirst∆14_TEST←'redfirst∆R1' MK∆T1 (?10 10⍴2)
∆redfirst∆15_TEST←'redfirst∆R1' MK∆T1 (?32 32⍴2)
∆redfirst∆16_TEST←'redfirst∆R1' MK∆T1 (?128 128⍴2)
∆redfirst∆17_TEST←'redfirst∆R1' MK∆T1 (?100 100⍴2)
∆redfirst∆18_TEST←'redfirst∆R1' MK∆T1 (?500 500⍴2)
∆redfirst∆19_TEST←'redfirst∆R1' MK∆T1 (?512 512⍴2)
∆redfirst∆20_TEST←'redfirst∆R1' MK∆T1 (?512⍴2)
∆redfirst∆21_TEST←'redfirst∆R4' MK∆T1 (1⍴1)
∆redfirst∆22_TEST←'redfirst∆R4' MK∆T1 (1 5⍴⍳5)
∆redfirst∆23_TEST←'redfirst∆R4' MK∆T1 (1 3 3⍴⍳9)
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
∆reduce∆40_TEST←{#.UT.expect←'NONCE' ⋄ 16::'NONCE' ⋄ cd.reduce∆R23 ⍬}
∆reduce∆41_TEST←'reduce∆R24' MK∆T1 (⍬)
∆reduce∆42_TEST←'reduce∆R25' MK∆T1 (⍬)
∆reduce∆43_TEST←'reduce∆R26' MK∆T1 (⍬)
∆reduce∆44_TEST←'reduce∆R27' MK∆T1 (⍬)
∆reduce∆45_TEST←'reduce∆R28' MK∆T1 (⍬)
∆reduce∆46_TEST←'reduce∆R29' MK∆T1 (⍬)
∆reduce∆47_TEST←'reduce∆R30' MK∆T1 (3 3⍴⍳9)
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
∆scan∆01_TEST←'scan∆R1' MK∆T1 (⍬⍴1)
∆scan∆02_TEST←'scan∆R1' MK∆T1 (5⍴⍳5)
∆scan∆03_TEST←'scan∆R1' MK∆T1 (3 3⍴⍳9)
∆scan∆04_TEST←'scan∆R3' MK∆T1 (⍬⍴3)
∆scan∆05_TEST←'scan∆R2' MK∆T1 (⍬)
∆scan∆06_TEST←'scan∆R1' MK∆T1 (⍬)
∆scan∆07_TEST←'scan∆R3' MK∆T1 (⍬⍴1)
∆scan∆08_TEST←'scan∆R3' MK∆T1 (5⍴⍳5)
∆scan∆09_TEST←'scan∆R3' MK∆T1 (3 3⍴⍳9)
∆scan∆10_TEST←'scan∆R1' MK∆T1 ((2*18)⍴2 0 0 0 0)
∆scan∆11_TEST←'scan∆R4' MK∆T1 ((2 10)⍴1)
∆scan∆12_TEST←'scan∆R4' MK∆T1 ((2 10)⍴5)
∆scan∆13_TEST←'scan∆R1' MK∆T1 ((2 10)⍴1)
∆scan∆14_TEST←'scan∆R4' MK∆T1 ((2 10)⍴1 0)
∆scan∆15_TEST←'scan∆R4' MK∆T1 ((2 10)⍴5 0)
∆scan∆16_TEST←'scan∆R4' MK∆T1 (⍬⍴1)
∆scan∆17_TEST←'scan∆R4' MK∆T1 (5⍴⍳5)
∆scan∆18_TEST←'scan∆R4' MK∆T1 (3 3⍴⍳9)
∆scan∆19_TEST←'scan∆R3' MK∆T1 (3 0⍴⍳9)
∆scan∆20_TEST←'scan∆R4' MK∆T1 (3 0⍴⍳9)
∆scan∆21_TEST←'scan∆R3' MK∆T1 (3 1⍴⍳9)
∆scan∆22_TEST←'scan∆R4' MK∆T1 (3 1⍴⍳9)
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

∆scanoverrun∆01_TEST←'scanoverrun∆Run' MK∆T2 (10⍴1) (10×⍳10)
∆uniqop_TEST←'uniqop∆Run' MK∆T1 (0 0 0 1 1 1 1 1)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
