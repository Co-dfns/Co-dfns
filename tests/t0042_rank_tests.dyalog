:Require file://t0042.dyalog
:Namespace t0042_tests

 tn←'t0042' ⋄ cn←'c0042'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0042←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

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
∆rank∆46_TEST←'rank∆R4' MK∆T2 (?8 4⍴2) (?1 8 4⍴2)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace