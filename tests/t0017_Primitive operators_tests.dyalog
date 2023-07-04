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
