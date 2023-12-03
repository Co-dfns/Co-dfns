:Require file://t0083.dyalog
:Namespace t0083_tests

 tn←'t0083' ⋄ cn←'c0083'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0083←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}
 MK∆T4←{fn tl←⍺⍺ ⋄ nv←(⍎'dy.',fn)⍵⍵ ⋄ cv←(⍎'cd.',fn)⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}

F←{⊃((⎕DR ⍵)645)⎕DR ⍵}
B←{⊃((⎕DR ⍵)11)⎕DR ⍵}
I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

MK∆T←{nv←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ cv←⊃(⍎'cd.',⍺⍺)/⍵⍵
 res←|1-(0.5⌈(⌈/1⊃⍵⍵)÷2)÷(+⌿÷≢)cv ⋄ _←{0.05≤⍵:⎕←⍵ ⋄ ⍬}res
 ##.UT.expect←(⍴nv)(1) ⋄ (⍴cv)(0.05>res)}

∆indexof∆01_TEST←'indexof' MK∆T2 (⍬)(⍬)
∆indexof∆02_TEST←'indexof' MK∆T2 (⍬)(1)
∆indexof∆03_TEST←'indexof' MK∆T2 (⍬)(⍳5)
∆indexof∆04_TEST←'indexof' MK∆T2 (⍳5)(⍬)
∆indexof∆05_TEST←'indexof' MK∆T2 (⍳5)(0)
∆indexof∆06_TEST←'indexof' MK∆T2 (⍳5)(1)
∆indexof∆07_TEST←'indexof' MK∆T2 (⍳5)(2)
∆indexof∆08_TEST←'indexof' MK∆T2 (⍳5)(⍳5)
∆indexof∆09_TEST←'indexof' MK∆T2 (⍳5)(⌽⍳5)
∆indexof∆10_TEST←'indexof' MK∆T2 (⌽⍳5)(⍳5)
∆indexof∆11_TEST←'indexof' MK∆T2 (⌽⍳5)(⌽⍳5)
∆indexof∆12_TEST←'indexof' MK∆T2 (⌽⍳5)(5 5⍴⍳5)
∆indexof∆13_TEST←'indexof' MK∆T2 (⌽⍳5)(5 5 5⍴⍳5)
∆indexof∆14_TEST←'indexof' MK∆T2 (⍳2)(2)
∆indexof∆15_TEST←'indexof' MK∆T2 (⍳2)(⍳5)
∆indexof∆16_TEST←'indexof' MK∆T2 (⍳2)(⌽⍳5)
∆indexof∆17_TEST←'indexof' MK∆T2 (⌽⍳2)(⍳5)
∆indexof∆18_TEST←'indexof' MK∆T2 (⌽⍳2)(⌽⍳5)
∆indexof∆19_TEST←'indexof' MK∆T2 (⌽⍳2)(5 5⍴⍳5)
∆indexof∆20_TEST←'indexof' MK∆T2 (⌽⍳2)(5 5 5⍴⍳5)
∆indexof∆21_TEST←'indexof' MK∆T2 (?1024⍴2*19)(?1024⍴2*19)
∆indexof∆22_TEST←'indexof' MK∆T2 (F ⍬)(⍬)
∆indexof∆23_TEST←'indexof' MK∆T2 (F ⍬)(1)
∆indexof∆24_TEST←'indexof' MK∆T2 (F ⍬)(⍳5)
∆indexof∆25_TEST←'indexof' MK∆T2 (F ⍳5)(⍬)
∆indexof∆26_TEST←'indexof' MK∆T2 (F ⍳5)(0)
∆indexof∆27_TEST←'indexof' MK∆T2 (F ⍳5)(1)
∆indexof∆28_TEST←'indexof' MK∆T2 (F ⍳5)(2)
∆indexof∆29_TEST←'indexof' MK∆T2 (F ⍳5)(⍳5)
∆indexof∆30_TEST←'indexof' MK∆T2 (F ⍳5)(⌽⍳5)
∆indexof∆31_TEST←'indexof' MK∆T2 (F ⌽⍳5)(⍳5)
∆indexof∆32_TEST←'indexof' MK∆T2 (F ⌽⍳5)(⌽⍳5)
∆indexof∆33_TEST←'indexof' MK∆T2 (F ⌽⍳5)(5 5⍴⍳5)
∆indexof∆34_TEST←'indexof' MK∆T2 (F ⌽⍳5)(5 5 5⍴⍳5)
∆indexof∆35_TEST←'indexof' MK∆T2 (F ⍳2)(2)
∆indexof∆36_TEST←'indexof' MK∆T2 (F ⍳2)(⍳5)
∆indexof∆37_TEST←'indexof' MK∆T2 (F ⍳2)(⌽⍳5)
∆indexof∆38_TEST←'indexof' MK∆T2 (F ⌽⍳2)(⍳5)
∆indexof∆39_TEST←'indexof' MK∆T2 (F ⌽⍳2)(⌽⍳5)
∆indexof∆40_TEST←'indexof' MK∆T2 (F ⌽⍳2)(5 5⍴⍳5)
∆indexof∆41_TEST←'indexof' MK∆T2 (F ⌽⍳2)(5 5 5⍴⍳5)
∆indexof∆42_TEST←'indexof' MK∆T2 (F ?1024⍴2*19)(?1024⍴2*19)
∆indexof∆43_TEST←'indexof' MK∆T2 (⍬)(F ⍬)
∆indexof∆44_TEST←'indexof' MK∆T2 (⍬)(F 1)
∆indexof∆45_TEST←'indexof' MK∆T2 (⍬)(F ⍳5)
∆indexof∆46_TEST←'indexof' MK∆T2 (⍳5)(F ⍬)
∆indexof∆47_TEST←'indexof' MK∆T2 (⍳5)(÷1)
∆indexof∆48_TEST←'indexof' MK∆T2 (⍳5)(÷2)
∆indexof∆49_TEST←'indexof' MK∆T2 (⍳5)(÷3)
∆indexof∆50_TEST←'indexof' MK∆T2 (⍳5)(F ⍳5)
∆indexof∆51_TEST←'indexof' MK∆T2 (⍳5)(F ⌽⍳5)
∆indexof∆52_TEST←'indexof' MK∆T2 (⌽⍳5)(F ⍳5)
∆indexof∆53_TEST←'indexof' MK∆T2 (⌽⍳5)(F ⌽⍳5)
∆indexof∆54_TEST←'indexof' MK∆T2 (⌽⍳5)(F 5 5⍴⍳5)
∆indexof∆55_TEST←'indexof' MK∆T2 (⌽⍳5)(F 5 5 5⍴⍳5)
∆indexof∆56_TEST←'indexof' MK∆T2 (⍳2)(F 2)
∆indexof∆57_TEST←'indexof' MK∆T2 (⍳2)(F ⍳5)
∆indexof∆58_TEST←'indexof' MK∆T2 (⍳2)(F ⌽⍳5)
∆indexof∆59_TEST←'indexof' MK∆T2 (⌽⍳2)(F ⍳5)
∆indexof∆60_TEST←'indexof' MK∆T2 (⌽⍳2)(F ⌽⍳5)
∆indexof∆61_TEST←'indexof' MK∆T2 (⌽⍳2)(F 5 5⍴⍳5)
∆indexof∆62_TEST←'indexof' MK∆T2 (⌽⍳2)(F 5 5 5⍴⍳5)
∆indexof∆63_TEST←'indexof' MK∆T2 (?1024⍴2*19)(F ?1024⍴2*19)
∆indexof∆64_TEST←'indexof' MK∆T2 (F ⍬)(F ⍬)
∆indexof∆65_TEST←'indexof' MK∆T2 (F ⍬)(F 1)
∆indexof∆66_TEST←'indexof' MK∆T2 (F ⍬)(F ⍳5)
∆indexof∆67_TEST←'indexof' MK∆T2 (F ⍳5)(F ⍬)
∆indexof∆68_TEST←'indexof' MK∆T2 (F ⍳5)(÷1)
∆indexof∆69_TEST←'indexof' MK∆T2 (F ⍳5)(÷2)
∆indexof∆70_TEST←'indexof' MK∆T2 (F ⍳5)(÷3)
∆indexof∆71_TEST←'indexof' MK∆T2 (F ⍳5)(F ⍳5)
∆indexof∆72_TEST←'indexof' MK∆T2 (F ⍳5)(F ⌽⍳5)
∆indexof∆73_TEST←'indexof' MK∆T2 (F ⌽⍳5)(F ⍳5)
∆indexof∆74_TEST←'indexof' MK∆T2 (F ⌽⍳5)(F ⌽⍳5)
∆indexof∆75_TEST←'indexof' MK∆T2 (F ⌽⍳5)(F 5 5⍴⍳5)
∆indexof∆76_TEST←'indexof' MK∆T2 (F ⌽⍳5)(F 5 5 5⍴⍳5)
∆indexof∆77_TEST←'indexof' MK∆T2 (F ⍳2)(F 2)
∆indexof∆78_TEST←'indexof' MK∆T2 (F ⍳2)(F ⍳5)
∆indexof∆79_TEST←'indexof' MK∆T2 (F ⍳2)(F ⌽⍳5)
∆indexof∆80_TEST←'indexof' MK∆T2 (F ⌽⍳2)(F ⍳5)
∆indexof∆81_TEST←'indexof' MK∆T2 (F ⌽⍳2)(F ⌽⍳5)
∆indexof∆82_TEST←'indexof' MK∆T2 (F ⌽⍳2)(F 5 5⍴⍳5)
∆indexof∆83_TEST←'indexof' MK∆T2 (F ⌽⍳2)(F 5 5 5⍴⍳5)
∆indexof∆84_TEST←'indexof' MK∆T2 (F ?1024⍴2*19)(F ?1024⍴2*19)
∆indexof∆85_TEST←'indexof' MK∆T2 (3⌿⍳10) (3⌿⍳10)
∆indexof∆86_TEST←'indexof' MK∆T2 (25⍴⍳10) (25⍴⍳10)
∆indexof∆87_TEST←'indexof' MK∆T2 ('abc' 'def' 'ghi')('abc' 'xyz' 'ghi' 'def' 'abc')
∆indexof∆88_TEST←'indexof' MK∆T2 (3 2⍴'abcdef')('cd')
∆indexof∆89_TEST←'indexof' MK∆T2 (3 2⍴'abcdef')(4 2⍴'efxtcdab')

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
