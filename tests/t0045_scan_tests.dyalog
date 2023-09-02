:Require file://t0045.dyalog
:Namespace t0045_tests

 tn←'t0045' ⋄ cn←'c0045'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0045←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆scan∆01_TEST←'scan∆R1' MK∆T1 (⍬⍴1)
∆scan∆02_TEST←'scan∆R1' MK∆T1 (5⍴⍳5)
∆scan∆03_TEST←'scan∆R1' MK∆T1 (?5⍴2)
∆scan∆04_TEST←'scan∆R1' MK∆T1 ((2*16)+?5⍴128)
∆scan∆05_TEST←'scan∆R1' MK∆T1 (?5⍴0)
∆scan∆06_TEST←'scan∆R1' MK∆T1 ((?5⍴0)+0j1×?5⍴0)
∆scan∆07_TEST←'scan∆R1' MK∆T1 (?2048⍴0)
∆scan∆08_TEST←'scan∆R1' MK∆T1 ((2*18)⍴2 0 0 0 0)
∆scan∆09_TEST←'scan∆R1' MK∆T1 (3 3⍴⍳9)
∆scan∆10_TEST←'scan∆R3' MK∆T1 (⍬⍴3)
∆scan∆11_TEST←'scan∆R2' MK∆T1 (⍬)
∆scan∆12_TEST←'scan∆R1' MK∆T1 (⍬)
∆scan∆13_TEST←'scan∆R3' MK∆T1 (⍬⍴1)
∆scan∆14_TEST←'scan∆R3' MK∆T1 (5⍴⍳5)
∆scan∆15_TEST←'scan∆R3' MK∆T1 (3 3⍴⍳9)
∆scan∆16_TEST←'scan∆R4' MK∆T1 ((2 10)⍴1)
∆scan∆17_TEST←'scan∆R4' MK∆T1 ((2 10)⍴5)
∆scan∆18_TEST←'scan∆R1' MK∆T1 ((2 10)⍴1)
∆scan∆19_TEST←'scan∆R4' MK∆T1 ((2 10)⍴1 0)
∆scan∆20_TEST←'scan∆R4' MK∆T1 ((2 10)⍴5 0)
∆scan∆21_TEST←'scan∆R4' MK∆T1 (⍬⍴1)
∆scan∆22_TEST←'scan∆R4' MK∆T1 (5⍴⍳5)
∆scan∆23_TEST←'scan∆R4' MK∆T1 (3 3⍴⍳9)
∆scan∆24_TEST←'scan∆R3' MK∆T1 (3 0⍴⍳9)
∆scan∆25_TEST←'scan∆R4' MK∆T1 (3 0⍴⍳9)
∆scan∆26_TEST←'scan∆R3' MK∆T1 (3 1⍴⍳9)
∆scan∆27_TEST←'scan∆R4' MK∆T1 (3 1⍴⍳9)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace