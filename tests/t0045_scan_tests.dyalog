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
∆scan∆02_TEST←'scan∆R1' MK∆T1 (?5⍴2)
∆scan∆03_TEST←'scan∆R1' MK∆T1 (5⍴⍳5)
∆scan∆04_TEST←'scan∆R1' MK∆T1 ((2*16)+?5⍴128)
∆scan∆05_TEST←'scan∆R1' MK∆T1 (?5⍴0)
∆scan∆06_TEST←'scan∆R1' MK∆T1 ((?5⍴0)+0j1×?5⍴0)
∆scan∆07_TEST←'scan∆R1' MK∆T1 (?2048⍴2)
∆scan∆08_TEST←'scan∆R1' MK∆T1 (2048⍴⍳5)
∆scan∆09_TEST←'scan∆R1' MK∆T1 ((2*16)+?2048⍴128)
∆scan∆10_TEST←'scan∆R1' MK∆T1 (?2048⍴0)
∆scan∆11_TEST←'scan∆R1' MK∆T1 ((?2048⍴0)+0j1×?2048⍴0)
∆scan∆12_TEST←'scan∆R1' MK∆T1 ((2*18)⍴2 0 0 0 0)
∆scan∆13_TEST←'scan∆R1' MK∆T1 (?3 3⍴2)
∆scan∆14_TEST←'scan∆R1' MK∆T1 ((2*8)+?3 3⍴128)
∆scan∆15_TEST←'scan∆R1' MK∆T1 ((2*16)+?3 3⍴128)
∆scan∆16_TEST←'scan∆R1' MK∆T1 (?3 3⍴0)
∆scan∆17_TEST←'scan∆R1' MK∆T1 ((?3 3⍴0)+0j1+?3 3⍴0)
∆scan∆18_TEST←'scan∆R1' MK∆T1 (?64 64⍴2)
∆scan∆19_TEST←'scan∆R1' MK∆T1 ((2*8)+?64 64⍴128)
∆scan∆20_TEST←'scan∆R1' MK∆T1 ((2*16)+?64 64⍴128)
∆scan∆21_TEST←'scan∆R1' MK∆T1 (?64 64⍴0)
∆scan∆22_TEST←'scan∆R1' MK∆T1 ((?64 64⍴0)+0j1+?64 64⍴0)
∆scan∆23_TEST←'scan∆R1' MK∆T1 (?3 3 3⍴2)
∆scan∆24_TEST←'scan∆R1' MK∆T1 ((2*8)+?3 3 3⍴128)
∆scan∆25_TEST←'scan∆R1' MK∆T1 ((2*16)+?3 3 3⍴128)
∆scan∆26_TEST←'scan∆R1' MK∆T1 (?3 3 3⍴0)
∆scan∆27_TEST←'scan∆R1' MK∆T1 ((?3 3 3⍴0)+0j1+?3 3 3⍴0)
∆scan∆28_TEST←'scan∆R1' MK∆T1 (?16 16 16⍴2)
∆scan∆29_TEST←'scan∆R1' MK∆T1 ((2*8)+?16 16 16⍴128)
∆scan∆30_TEST←'scan∆R1' MK∆T1 ((2*16)+?16 16 16⍴128)
∆scan∆31_TEST←'scan∆R1' MK∆T1 (?16 16 16⍴0)
∆scan∆32_TEST←'scan∆R1' MK∆T1 ((?16 16 16⍴0)+0j1+?16 16 16⍴0)
∆scan∆33_TEST←'scan∆R2' MK∆T1 (⍬⍴1)
∆scan∆34_TEST←'scan∆R2' MK∆T1 (?5⍴2)
∆scan∆35_TEST←'scan∆R2' MK∆T1 (5⍴⍳5)
∆scan∆36_TEST←'scan∆R2' MK∆T1 ((2*16)+?5⍴128)
∆scan∆37_TEST←'scan∆R2' MK∆T1 (?5⍴0)
∆scan∆38_TEST←'scan∆R2' MK∆T1 ((?5⍴0)+0j1×?5⍴0)
∆scan∆39_TEST←'scan∆R2' MK∆T1 (?2048⍴2)
∆scan∆40_TEST←'scan∆R2' MK∆T1 (2048⍴⍳5)
∆scan∆41_TEST←'scan∆R2' MK∆T1 ((2*16),1+?1500⍴2)
∆scan∆42_TEST←'scan∆R2' MK∆T1 (?2048⍴0)
∆scan∆43_TEST←'scan∆R2' MK∆T1 ((?2048⍴0)+0j1×?2048⍴0)
∆scan∆44_TEST←'scan∆R2' MK∆T1 (?3 3⍴2)
∆scan∆45_TEST←'scan∆R2' MK∆T1 ((2*8)+1+?3 3⍴2)
∆scan∆46_TEST←'scan∆R2' MK∆T1 ((2*16)+1+?3 3⍴2)
∆scan∆47_TEST←'scan∆R2' MK∆T1 (?3 3⍴0)
∆scan∆48_TEST←'scan∆R2' MK∆T1 ((?3 3⍴0)+0j1+?3 3⍴0)
∆scan∆49_TEST←'scan∆R2' MK∆T1 (?64 64⍴2)
∆scan∆50_TEST←'scan∆R2' MK∆T1 ((2*8)+1+?64 64⍴2)
∆scan∆51_TEST←'scan∆R2' MK∆T1 ((2*16),1+?64 64⍴2)
∆scan∆52_TEST←'scan∆R2' MK∆T1 (?64 64⍴0)
∆scan∆53_TEST←'scan∆R2' MK∆T1 ((?64 64⍴0)+0j1+?64 64⍴0)
∆scan∆54_TEST←'scan∆R2' MK∆T1 (?3 3 3⍴2)
∆scan∆55_TEST←'scan∆R2' MK∆T1 ((2*8)+1+?3 3 3⍴2)
∆scan∆56_TEST←'scan∆R2' MK∆T1 ((2*16)+1+?3 3 3⍴2)
∆scan∆57_TEST←'scan∆R2' MK∆T1 (?3 3 3⍴0)
∆scan∆58_TEST←'scan∆R2' MK∆T1 ((?3 3 3⍴0)+0j1+?3 3 3⍴0)
∆scan∆59_TEST←'scan∆R2' MK∆T1 (?16 16 16⍴2)
∆scan∆60_TEST←'scan∆R2' MK∆T1 ((2*8)+1+?16 16 16⍴2)
∆scan∆61_TEST←'scan∆R2' MK∆T1 ((2*16)+1+?16 16 16⍴2)
∆scan∆62_TEST←'scan∆R2' MK∆T1 (?16 16 16⍴0)
∆scan∆63_TEST←'scan∆R2' MK∆T1 ((?16 16 16⍴0)+0j1+?16 16 16⍴0)
∆scan∆64_TEST←'scan∆R3' MK∆T1 (⍬⍴3)
∆scan∆65_TEST←'scan∆R2' MK∆T1 (⍬)
∆scan∆66_TEST←'scan∆R1' MK∆T1 (⍬)
∆scan∆67_TEST←'scan∆R3' MK∆T1 (⍬⍴1)
∆scan∆68_TEST←'scan∆R3' MK∆T1 (5⍴⍳5)
∆scan∆69_TEST←'scan∆R3' MK∆T1 (3 3⍴⍳9)
∆scan∆70_TEST←'scan∆R4' MK∆T1 ((2 10)⍴1)
∆scan∆71_TEST←'scan∆R4' MK∆T1 ((2 10)⍴5)
∆scan∆72_TEST←'scan∆R1' MK∆T1 ((2 10)⍴1)
∆scan∆73_TEST←'scan∆R4' MK∆T1 ((2 10)⍴1 0)
∆scan∆74_TEST←'scan∆R4' MK∆T1 ((2 10)⍴5 0)
∆scan∆75_TEST←'scan∆R4' MK∆T1 (⍬⍴1)
∆scan∆76_TEST←'scan∆R4' MK∆T1 (5⍴⍳5)
∆scan∆77_TEST←'scan∆R4' MK∆T1 (3 3⍴⍳9)
∆scan∆78_TEST←'scan∆R3' MK∆T1 (3 0⍴⍳9)
∆scan∆79_TEST←'scan∆R4' MK∆T1 (3 0⍴⍳9)
∆scan∆80_TEST←'scan∆R3' MK∆T1 (3 1⍴⍳9)
∆scan∆81_TEST←'scan∆R4' MK∆T1 (3 1⍴⍳9)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace