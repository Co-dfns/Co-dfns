:Require file://t0041.dyalog
:Namespace t0041_tests

 tn←'t0041' ⋄ cn←'c0041'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0041←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

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

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace